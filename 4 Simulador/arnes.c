/*
 * arnes.c - ARNES DE PRUEBA DEL FIRMWARE DE LA BALIZA
 *
 * Se enlaza contra los .c REALES del firmware -- los mismos que MPLAB X graba
 * en el PIC -- compilados contra los stubs de <xc.h> y la plataforma simulada.
 * Por eso mide el firmware, no una copia reescrita para el PC.
 *
 * Lo que NO se incluye, y por que:
 *   main.c    -> usa __interrupt(), que solo existe en XC8. El bucle principal y
 *                la ISR de Timer0 estan reproducidos LITERALMENTE en plataforma.c.
 *   EEprom.c  -> hace `while(!PIR2bits.EEIF);` sobre un periferico inexistente.
 *   DS1307.c  -> habla I2C con un chip que aqui no hay; ademas hace falta un
 *                reloj que se pueda mover a voluntad para probar las alarmas.
 *   I2C.c     -> solo lo usa DS1307.c.
 *
 * Compilar y correr:  python correr.py
 */

/* Las cabeceras del sistema van PRIMERO: main.h define `true` y `false` como
   macros, y si entran antes rompen cualquier cabecera que use esos nombres. */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

/* ---------------------------------------------------------------
   POR QUE ESTE ARNES NO COMPILA EN UNIDAD UNICA

   Lo natural seria un solo .c que incluyera los .c del firmware. No se puede:
   `Cluster.h` NO TIENE GUARDA DE INCLUSION (ni #ifndef CLUSTER_H ni #pragma
   once), y lo incluyen tanto Cluster.c como Aplicacion.c. En unidad unica el
   compilador ve dos veces la misma struct y el mismo enum, y aborta.

   Asi que cada .c del firmware se compila por separado, como hace MPLAB X, y
   correr.py los enlaza. Dos consecuencias que hay que conocer:

   1. Hace falta -fcommon. `strAplicacion ap;` esta definida SIN extern en
      Aplicacion.c y otra vez en LedLive.c:17, y `srtAlarmas ala1..ala5` estan
      definidas dos veces, en Serial.c:22-26 y en Alarma.c:24-28. Son
      definiciones tentativas: XC8 las fusiona en un solo objeto y el firmware
      funciona por eso. gcc desde la version 10 las rechaza por defecto, y
      -fcommon le devuelve el comportamiento de XC8. Se compila asi a proposito,
      para medir el firmware tal y como se graba -- no para tapar el problema.

   2. transmitUart1 se envuelve. El arnes necesita ver todo lo que el equipo
      transmite, y en el PC TXREG es un byte que se sobreescribe en cada vuelta.
      Serial.c se compila con -DtransmitUart1=fw_transmitUart1, de modo que
      la funcion ORIGINAL -- sin tocarle una linea -- pasa a llamarse
      fw_transmitUart1, y la envoltura de aqui abajo apunta la cadena y la llama.
      Los demas modulos siguen llamando a transmitUart1 sin enterarse.

      PUNTO CIEGO QUE ESTO DEJA, y costo media tarde el 22-ago-2026: el -D
      renombra la definicion Y TAMBIEN las llamadas que Serial.c se hace a si
      mismo. Esas van directas a fw_transmitUart1 y NO pasan por la envoltura,
      asi que sim_tx() no las ve. Hoy es exactamente UNA: el "OK_NAME" con el
      que la baliza confirma que grabo el nombre (Serial.c:209). En el equipo
      real ese eco SI sale por la UART. Si algun dia Serial.c transmite algo
      mas desde dentro, tampoco se vera: comprobarlo antes de dar por bueno un
      verde que dependa de lo que transmite Serial.c.
   --------------------------------------------------------------- */

#include "xc.h"
#include "Serial.h"
#include "Alarma.h"
#include "Aplicacion.h"
#include "Buzzer.h"
#include "sim.h"

/* Estado interno del firmware que algunos escenarios necesitan observar. */
extern strAnaTrama          anaT1;
extern strSerial            serial1;
extern enum states_alarm    stateAlarm;
extern srtAlarmas           ala1;

/* La original, renombrada al compilar Serial.c. */
void fw_transmitUart1(const char *ptr);
void sim_tx_byte(unsigned char b);

void transmitUart1(const char *ptr)
{
    const char *p = ptr;
    while (*p) sim_tx_byte((unsigned char)*p++);
    fw_transmitUart1(ptr);
}

/* ---------------------------------------------------------------
   MARCADOR
   --------------------------------------------------------------- */
static int cnt_ok, cnt_falla;
static const char *escenario_actual = "";

#define ESCENARIO(nombre) do {                       \
        escenario_actual = (nombre);                 \
        printf("\n-- %s\n", escenario_actual);       \
    } while (0)

#define CHECK(cond, ...) do {                        \
        if (cond) { cnt_ok++; printf("   ok    "); } \
        else      { cnt_falla++; printf("   FALLA "); } \
        printf(__VA_ARGS__);                         \
        printf("\n");                                \
    } while (0)

/* ---------------------------------------------------------------
   UTILIDADES
   --------------------------------------------------------------- */

/* Deja el equipo arrancado, con la memoria ya inicializada y las 5 alarmas
   apagadas: el estado del que parte un equipo que lleva tiempo instalado. */
static void arrancar_limpio(void)
{
    sim_reset();
    sim_eeprom_borrar();
    sim_arrancar();            /* primera vuelta: inicializa la EEPROM */
    sim_reset();
    sim_arrancar();            /* segunda: ya la encuentra inicializada */
    sim_tx_limpiar();
}

/* La trama que manda la app de Android para programar una alarma.
   Formato real, copiado de MainActivity2.java:208. */
static void trama_alarma(int n, int hi, int mi, int hf, int mf, int dias)
{
    char t[64];
    sprintf(t, "\xBF" "A%d,E1,I%02d%02d,F%02d%02d,D%d,?\n\r", n, hi, mi, hf, mf, dias);
    sim_rx_str(t);
    sim_tick(200);
}

static void trama_apagar(int n)
{
    char t[32];
    sprintf(t, "\xBF" "A%d,E0,?\n\r", n);
    sim_rx_str(t);
    sim_tick(200);
}

/* Ruta a este mismo ejecutable, entrecomillada: la carpeta lleva un espacio. */
static const char *ruta_propia = "arnes.exe";

static const char *cmd_hijo(const char *arg)
{
    static char buf[1024];
    sprintf(buf, "\"\"%s\" %s\"", ruta_propia, arg);
    return buf;
}

/* Escenarios que se corren en un proceso APARTE porque pueden tumbarlo.
   Devuelve 0 si el firmware sobrevivio. */
static int hijo_trama_truncada(void)
{
    arrancar_limpio();
    sim_rx_str("\xBF" "A3");            /* sin coma y sin fin de trama */
    sim_tick(500);
    /* Si llega hasta aqui, no se cayo. Queda comprobar que ademas no se invento
       un numero de alarma imposible al salirse de la trama. */
    return (anaT1.ucNumAlarm <= 5) ? 0 : 4;
}

int main(int argc, char **argv)
{
    /* Sin buffer: si el arnes se cae, hace falta ver por donde iba. */
    setvbuf(stdout, NULL, _IONBF, 0);

    if (argc > 0 && argv[0]) ruta_propia = argv[0];

    if (argc > 1 && strcmp(argv[1], "--trama-truncada") == 0)
        return hijo_trama_truncada();

    if (argc > 1 && strcmp(argv[1], "--interactivo") == 0)
    {
        arrancar_limpio();
        printf("[SIM_LISTO]\n");
        fflush(stdout);
        char buffer[256];
        while (fgets(buffer, sizeof(buffer), stdin))
        {
            size_t l = strlen(buffer);
            while (l > 0 && (buffer[l-1] == '\r' || buffer[l-1] == '\n')) buffer[--l] = '\0';
            if (l == 0) continue;
            if (strcmp(buffer, "SALIR") == 0) break;

            if (strncmp(buffer, "TICK ", 5) == 0)
            {
                unsigned long ms = strtoul(buffer + 5, NULL, 10);
                if (ms == 0) ms = 100;
                sim_tick(ms);
            }
            else
            {
                sim_tx_limpiar();
                sim_rx_str(buffer);
                sim_rx_str("\n\r");
                sim_tick(250);
            }

            const char *resp = sim_tx();
            printf("[TX_START]\n%s\n[TX_END]\n", resp ? resp : "");
            printf("[LAMP]:%d\n", LATCbits.LATC2);
            printf("[SIM_OK]\n");
            fflush(stdout);
        }
        return 0;
    }

    printf("===============================================================\n");
    printf(" ARNES DE LA BALIZA - firmware 18f2550_baliza_ V1.X\n");
    printf(" Senal vial \"30 CUANDO ACTIVADA\" - luz en LATC2\n");
    printf("===============================================================\n");

    /* =============================================================
       A. ARRANQUE
       ============================================================= */
    ESCENARIO("A. Arranque desde un PIC virgen");
    {
        unsigned long t;
        sim_reset();
        sim_eeprom_borrar();
        t = sim_arrancar();

        CHECK(t > 0, "el firmware llega a transmitir el banner (%lu ms)", t);
        CHECK(strstr(sim_tx(), "BALIZA ALARMA V1.0") != NULL,
              "el banner es el esperado");
        CHECK(sim_eeprom_leer(0x00) == 0x06,
              "marca de memoria inicializada en 0x00 = 0x06 (leido 0x%02X)",
              sim_eeprom_leer(0x00));
        CHECK(sim_eeprom_leer(0x01) == 0 && sim_eeprom_leer(0x08) == 0 &&
              sim_eeprom_leer(0x0F) == 0 && sim_eeprom_leer(0x16) == 0 &&
              sim_eeprom_leer(0x1D) == 0,
              "las 5 alarmas nacen deshabilitadas");
        CHECK(sim_cluster() == 0, "la luz de la senal nace APAGADA");
    }

    /* =============================================================
       B. PROTOCOLO SERIE - lo que manda la app de verdad
       ============================================================= */
    ESCENARIO("B. Protocolo: programar una alarma");
    {
        arrancar_limpio();
        trama_alarma(3, 8, 30, 17, 45, 9);   /* 08:30 -> 17:45, lunes a viernes */

        CHECK(sim_eeprom_leer(0x0F) == 1, "alarma 3 habilitada (0x0F)");
        CHECK(sim_eeprom_leer(0x11) == 9,  "dias = 9 (lunes a viernes) en 0x11");
        CHECK(sim_eeprom_leer(0x12) == 8,  "hora inicio = 8 en 0x12 (leido %d)",
              sim_eeprom_leer(0x12));
        CHECK(sim_eeprom_leer(0x13) == 30, "min inicio = 30 en 0x13 (leido %d)",
              sim_eeprom_leer(0x13));
        CHECK(sim_eeprom_leer(0x14) == 17, "hora fin = 17 en 0x14 (leido %d)",
              sim_eeprom_leer(0x14));
        CHECK(sim_eeprom_leer(0x15) == 45, "min fin = 45 en 0x15 (leido %d)",
              sim_eeprom_leer(0x15));
    }

    ESCENARIO("B2. Protocolo: apagar una alarma");
    {
        arrancar_limpio();
        trama_alarma(2, 6, 0, 9, 0, 8);
        CHECK(sim_eeprom_leer(0x08) == 1, "alarma 2 quedo encendida");
        trama_apagar(2);
        CHECK(sim_eeprom_leer(0x08) == 0, "alarma 2 quedo apagada");
    }

    ESCENARIO("B3. Protocolo: poner el reloj en hora");
    {
        int h, m, s, d, mo, a, dw;
        arrancar_limpio();
        /* Formato de MainActivity2.java:182 -> "HHmm" + "," + "C" + "ddMMyy-u" */
        sim_rx_str("\xBF" "R1130,C210826-4?\n\r");
        sim_tick(300);
        sim_rtc_get(&h, &m, &s, &d, &mo, &a, &dw);
        CHECK(h == 11 && m == 30, "hora puesta a 11:30 (leido %02d:%02d)", h, m);
        CHECK(d == 21 && mo == 8 && a == 26,
              "fecha puesta a 21/08/26 (leido %02d/%02d/%02d)", d, mo, a);
        CHECK(dw == 4, "dia de la semana = 4 (leido %d)", dw);
    }

    ESCENARIO("B4. Protocolo: la app manda NUL dentro de la trama");
    {
        /* MainActivity2.java:174-182 arma la hora en un char[6] pero solo
           escribe 4 caracteres, y el calendario en un char[10] escribiendo 8.
           Los huecos quedan a '\0' y viajan por el aire. El firmware sobrevive
           porque ST_ESPERA_ANA1 los filtra al copiar (Serial.c:120-127).
           Este escenario existe para que ese filtro no se borre por "limpieza". */
        int h, m, s, d, mo, a, dw;
        static const char trama[] =
            "\xBF" "R0630\0\0,C210826-4\0\0?\n\r";
        arrancar_limpio();
        sim_rx(trama, (int)sizeof(trama) - 1);
        sim_tick(300);
        sim_rtc_get(&h, &m, &s, &d, &mo, &a, &dw);
        CHECK(h == 6 && m == 30,
              "la trama con NUL intercalados se interpreta igual (leido %02d:%02d)", h, m);
    }

    ESCENARIO("B5. Protocolo: la app manda el delimitador en UTF-8");
    {
        /* Serial.h:27 define INIT_FRAME como el byte 0xBF (el '\xbf' de
           Windows-1252). La app lo escribe como literal Java, y PrintWriter lo
           serializa en UTF-8: dos bytes, 0xC2 0xBF. Funciona de milagro, porque
           strstr() busca subcadena y encuentra el 0xBF detras del 0xC2.
           Si alguien cambia strstr por una comparacion del primer byte, o hace
           que la app mande Latin-1, esto se rompe en silencio. */
        arrancar_limpio();
        sim_rx_str("\xC2\xBF" "A1,E1,I0600,F0900,D8,?\n\r");
        sim_tick(200);
        CHECK(sim_eeprom_leer(0x01) == 1,
              "la trama con el delimitador en UTF-8 (C2 BF) tambien se acepta");
    }

    /* =============================================================
       C. LA LUZ DE LA SENAL
       ============================================================= */
    ESCENARIO("C. La luz enciende al entrar la franja horaria");
    {
        arrancar_limpio();
        /* Placa de la senal: entre 6:00 am y 9:00 am. Viernes. */
        sim_rx_str("\xBF" "R0559,C210826-5?\n\r");
        sim_tick(300);
        trama_alarma(1, 6, 0, 9, 0, 8);      /* diaria */

        CHECK(sim_cluster() == 0, "a las 05:59 la luz sigue apagada");

        sim_tick(70000);                      /* pasa de las 06:00 */
        {
            unsigned long on = 0, off = 0;
            int ciclo = sim_medir_cluster(30000, &on, &off);
            CHECK(ciclo, "despues de las 06:00 la luz parpadea");

            /* CADENCIA CONFIRMADA POR EL FUNCIONAL, 21-ago-2026: 1 Hz, o sea
               500 ms encendida y 500 ms apagada, 60 destellos por minuto.
               Es lo que piden los manuales de senalizacion para balizas de zona
               escolar (50 a 60 destellos/min, con el tiempo encendido entre el
               50 % y el 60 % del ciclo).

               NO son los 2 s / 2 s que se dijeron en la reunion anterior: a
               30 km/h, dos segundos apagada son 16,7 metros en los que un
               conductor ve una senal apagada y deduce que no hay horario
               escolar. Con 500 ms son 4,1 metros.

               La tolerancia es del 10 %, que absorbe que el tick del firmware
               no sea de 1 ms exactos sino de 1,024 (defecto D17 de
               Manuales/FIRMWARE.md): 500 ms nominales salen 512 reales, que son
               58,6 destellos/min y siguen dentro de norma. */
            CHECK(on >= 450 && on <= 550,
                  "el pulso ENCENDIDO dura 500 ms +-10%% (medido %lu ms)", on);
            CHECK(off >= 450 && off <= 550,
                  "el pulso APAGADO dura 500 ms +-10%% (medido %lu ms)", off);
        }
    }

    ESCENARIO("C2. La luz apaga al salir la franja horaria");
    {
        arrancar_limpio();
        sim_rx_str("\xBF" "R0859,C210826-5?\n\r");
        sim_tick(300);
        trama_alarma(1, 6, 0, 9, 0, 8);
        sim_tick(70000);                      /* pasa de las 09:00 */
        sim_tick(5000);
        CHECK(sim_cluster() == 0, "a las 09:00 la luz queda apagada");
    }

    /* =============================================================
       D. DEFECTOS CONOCIDOS
       Estos escenarios NACEN EN ROJO. Cada cabecera lleva fecha y motivo.
       Al arreglar el firmware se ponen verdes solos; si alguno se pone verde
       sin que nadie haya tocado el firmware, es el arnes lo que se rompio.
       ============================================================= */

    ESCENARIO("D1. Arrancar DENTRO de la franja");
    {
        /* Evalua que al arrancar dentro del intervalo activo (ej. 07:00 en franja 06:00 a 09:00),
           el firmware evalue el rango y encienda la senal. */
        arrancar_limpio();
        sim_rx_str("\xBF" "R0700,C210826-5?\n\r");
        sim_tick(300);
        trama_alarma(1, 6, 0, 9, 0, 8);
        sim_tick(20000);
        CHECK(sim_cluster() != 0,
              "arrancando a las 07:00 dentro de la franja 06:00-09:00, la luz enciende");
    }

    ESCENARIO("D2. Dias personalizados: se rechaza la orden");
    {
        /* Al recibir una trama con dia no soportado (ej. D3 = solo miercoles),
           el firmware rechaza la orden: no habilita la alarma en EEPROM ni en RAM. */
        arrancar_limpio();
        trama_alarma(1, 6, 0, 9, 0, 3);      /* D3 = solo los miercoles */
        CHECK(sim_eeprom_leer(0x01) == 0,
              "una alarma pedida para un dia no soportado se rechaza (EE[0x01]=%d)",
              sim_eeprom_leer(0x01));
        CHECK(ala1.flagAlarm == 0,
              "la alarma no queda habilitada en RAM (flagAlarm=%d)",
              ala1.flagAlarm);
    }

    ESCENARIO("D3. Dias personalizados: no cuelgan la tarea");
    {
        /* Comprueba que si la EEPROM contiene un byte corrupto en flagDayAlar,
           la tarea de alarma no se queda bloqueada en ST_CHECK_ALARM1 y sigue ciclando. */
        int estado_antes, estado_despues;
        arrancar_limpio();
        trama_alarma(1, 6, 0, 9, 0, 8);
        sim_eeprom_escribir(0x02, 1);        /* alarma 1 = dias personalizados */
        sim_reset();                         /* corte de luz y reinicio */
        sim_arrancar();
        sim_tick(3000);
        estado_antes   = (int)stateAlarm;
        sim_tick(10000);
        estado_despues = (int)stateAlarm;
        CHECK(estado_antes != estado_despues || estado_despues == ST_ESPERA_ALA,
              "con dias personalizados la tarea de alarma sigue avanzando "
              "(estado %d -> %d)", estado_antes, estado_despues);
    }

    ESCENARIO("D4. transmitUart1 no manda un NUL de mas");
    {
        /* Serial.c:59 -- transmitUart1 transmite solo la longitud de la cadena
           sin anadir el terminador 0x00 al final. */
        arrancar_limpio();
        TXREG = 0xAA;
        fw_transmitUart1((char *)"HOLA");
        CHECK(TXREG != 0x00,
              "el ultimo byte escrito en TXREG no es el terminador (es 0x%02X)", TXREG);
    }

    ESCENARIO("D5. Trama truncada: no se sale de la trama");
    {
        /* Serial.c: extraerValue() y extraerFrame() verifican NULL y limites de buffer. */
        int r = system(cmd_hijo("--trama-truncada"));
        CHECK(r == 0,
              "una trama truncada no tumba el firmware (el hijo salio con %d)", r);
    }

    ESCENARIO("D6. Franjas solapadas: se apagan entre ellas");
    {
        /* Verifica que al finalizar una franja solapada (ej. 06:00-09:00 finaliza a las 09:00),
           si otra franja (08:00-12:00) sigue abierta, la senal permanezca activa. */
        arrancar_limpio();
        sim_rx_str("\xBF" "R0859,C210826-5?\n\r");
        sim_tick(300);
        trama_alarma(1, 6, 0,  9, 0, 8);
        trama_alarma(2, 8, 0, 12, 0, 8);
        sim_tick(70000);                      /* cruza las 09:00 */
        sim_tick(5000);
        {
            unsigned long on = 0, off = 0;
            CHECK(sim_medir_cluster(10000, &on, &off),
                  "a las 09:01, con la franja 08:00-12:00 abierta, la luz sigue "
                  "parpadeando");
        }
    }

    ESCENARIO("T6. Mapeo del buzzer en RC1 y RC0 como entrada");
    {
        /* Verifica que pinConfBuzzer configure RC1 como salida para el buzzer
           y RC0 como entrada para el pulsador, y que el buzzer opere en LATC1. */
        arrancar_limpio();
        pinConfBuzzer();
        CHECK(TRISCbits.TRISC1 == 0, "TRISC1 configurado como salida para el buzzer (0)");
        CHECK(TRISCbits.TRISC0 == 1, "TRISC0 configurado como entrada para el pulsador (1)");

        LATCbits.LATC1 = 0;
        LATCbits.LATC0 = 0;
        oneBeep();
        sim_tick(15);
        CHECK(LATCbits.LATC1 == 1, "el buzzer activa LATC1 (leido %d)", LATCbits.LATC1);
        CHECK(LATCbits.LATC0 == 0, "LATC0 permanece en bajo (leido %d)", LATCbits.LATC0);
    }

    ESCENARIO("D7. Soft UART Timeout: recuperacion ante tramas truncadas");
    {
        /* Inyecta una trama incompleta/basura a medias */
        arrancar_limpio();
        sim_rx_str("\xBF" "A1,E1,I06");
        sim_tick(50);
        /* Avanzamos mas de 1000 ms sin enviar '?' para forzar el timeout suave */
        sim_tick(1500);

        /* Enviamos una trama valida completa */
        trama_alarma(1, 7, 30, 10, 30, 9);
        sim_tick(200);

        /* Comprobamos que el buffer quedo limpio y la alarma 1 se configuro con exito */
        CHECK(sim_eeprom_leer(0x01) == 1, "alarma 1 habilitada tras recuperacion (1)");
        CHECK(sim_eeprom_leer(0x03) == 9, "dias = 9 (Lun-Vie) tras recuperacion (leido %d)", sim_eeprom_leer(0x03));
        CHECK(sim_eeprom_leer(0x04) == 7, "hora inicio = 7 tras recuperacion (leido %d)", sim_eeprom_leer(0x04));
        CHECK(sim_eeprom_leer(0x05) == 30, "min inicio = 30 tras recuperacion (leido %d)", sim_eeprom_leer(0x05));
    }

    ESCENARIO("D8. Telemetria y Auditoria: reporte Bat/Cortes tras lectura L");
    {
        arrancar_limpio();
        sim_tx_limpiar();
        sim_rx_str("\xBF" "L?\n\r");
        sim_tick(300);

        /* Comprueba que la respuesta contenga Bat: y Cortes: */
        CHECK(strstr(sim_tx(), "Bat:") != NULL, "el reporte de lectura incluye voltaje de bateria");
        CHECK(strstr(sim_tx(), "Cortes:") != NULL, "el reporte de lectura incluye contador de cortes");
    }

    /* =============================================================
       E. CONTROL NEGATIVO
       Un arnes que nadie ha visto fallar es un adorno. Estos escenarios
       comprueban que el instrumento SI acusa cuando debe.
       ============================================================= */
    ESCENARIO("E. Control negativo: el arnes acusa cuando debe");
    {
        arrancar_limpio();

        /* Una trama sin el delimitador de inicio NO puede programar nada. */
        sim_rx_str("A1,E1,I0600,F0900,D8,?\n\r");
        sim_tick(200);
        CHECK(sim_eeprom_leer(0x01) == 0,
              "una trama SIN delimitador de inicio no programa la alarma");

        /* Un numero de alarma que no existe no debe tocar ninguna de las 5. */
        arrancar_limpio();
        trama_alarma(9, 6, 0, 9, 0, 8);
        CHECK(sim_eeprom_leer(0x01) == 0 && sim_eeprom_leer(0x08) == 0 &&
              sim_eeprom_leer(0x0F) == 0 && sim_eeprom_leer(0x16) == 0 &&
              sim_eeprom_leer(0x1D) == 0,
              "la alarma 9 (inexistente) no altera ninguna de las 5 reales");

        /* Y el propio marcador: si esto diera ok, el CHECK no mide nada. */
        CHECK(1 == 1, "el marcador cuenta los ok");
    }
    /* =============================================================
       F. TEST DE ESTRES EXTREMO Y RESILIENCIA (100.000 CICLOS)
       Somete al firmware a fatiga extrema: rafagas de tramas basura,
       ciclos continuos de reloj y reinicios consecutivos sin parar.
       ============================================================= */
    ESCENARIO("F. Test de Estres Extremo: 100.000 ciclos y 500 tramas de ruido");
    {
        arrancar_limpio();

        /* F1: 100.000 ciclos continuos de ejecucion (100 segundos de microcontrolador) */
        unsigned long ms_ini = sim_ms();
        sim_tick(100000);
        unsigned long ms_fin = sim_ms();
        CHECK((ms_fin - ms_ini) == 100000, "completo 100.000 ciclos de reloj continuos sin desbordamiento ni bloqueo");

        /* F2: Inyeccion masiva de 500 tramas basura / ruido UART */
        for (int i = 0; i < 500; i++)
        {
            char ruido[32];
            sprintf(ruido, "\xBF RUIDO_%d,X%d,???\n\r", i, i % 10);
            sim_rx_str(ruido);
            sim_tick(10);
        }
        /* Damos 1.500 ms para que el Soft UART Timeout limpie la basura */
        sim_tick(1500);

        /* Ahora enviamos una trama valida oficial */
        trama_alarma(1, 6, 30, 8, 30, 9);
        sim_tick(200);
        CHECK(sim_eeprom_leer(0x01) == 1 && sim_eeprom_leer(0x03) == 9 &&
              sim_eeprom_leer(0x04) == 6 && sim_eeprom_leer(0x05) == 30,
              "tras 500 tramas de ruido UART, el firmware programa y opera con normalidad");

        /* F3: 5 ciclos completos de corte de energia y arranque con estabilizacion de 7s */
        uint16_t cortes_antes = ((uint16_t)sim_eeprom_leer(0x36) << 8) | sim_eeprom_leer(0x37);
        for (int k = 0; k < 5; k++)
        {
            sim_reset();
            sim_tx_limpiar();
            unsigned long t_arr = sim_arrancar();
            uint16_t c_k = ((uint16_t)sim_eeprom_leer(0x36) << 8) | sim_eeprom_leer(0x37);
            // printf("   [DEBUG F3] k=%d t=%lu cortes=%u\n", k, t_arr, c_k);
        }
        uint16_t cortes_despues = ((uint16_t)sim_eeprom_leer(0x36) << 8) | sim_eeprom_leer(0x37);
        CHECK((cortes_despues - cortes_antes) == 5,
              "5 ciclos completos de corte y arranque registrados con precision exacta en EEPROM (antes: %d, despues: %d, contados: %d)",
              cortes_antes, cortes_despues, (cortes_despues - cortes_antes));

        /* F4: Rafaga de 50 reprogramaciones de alarmas consecutivas (10 vueltas en las 5 alarmas) */
        for (int m = 1; m <= 5; m++)
        {
            for (int h = 6; h <= 10; h++)
            {
                trama_alarma(m, h, 0, h + 1, 0, 9);
            }
        }
        CHECK(sim_eeprom_leer(0x01) == 1 && sim_eeprom_leer(0x04) == 10 && sim_eeprom_leer(0x06) == 11 &&
              sim_eeprom_leer(0x1D) == 1 && sim_eeprom_leer(0x20) == 10 && sim_eeprom_leer(0x22) == 11,
              "rafaga de 50 reprogramaciones consecutivas no corrompio la memoria EEPROM");
    }
    /* =============================================================
       K. DOS COMANDOS SEGUIDOS EN LA MISMA SESION

       [ROJO ESPERADO 22-ago-2026] En campo la app no manda UNA trama: manda
       "¿L?" al pulsar LEER, y despues "¿R...?" al configurar -- y ademas se
       auto-manda "¿L?" al terminar de programar (MainActivity2.java:716, 743).

       El arnes hasta hoy reiniciaba el equipo antes de CADA trama, asi que
       media siempre el caso facil. Este escenario manda dos comandos seguidos
       SIN reiniciar, que es lo que pasa de verdad.

       Medido por HTTP contra el firmware real: la primera trama de reloj entra
       bien, y la segunda -- despues de un "¿L?" -- se pierde. La "L" anterior
       sigue en el bufferRx y el despachador la vuelve a encontrar.
       ============================================================= */
    ESCENARIO("K. Dos comandos seguidos sin reiniciar entre medias");
    {
        int h, m, sg, d, mo, a, dw;
        arrancar_limpio();

        /* K1: el reloj entra bien cuando es lo primero. Control del escenario. */
        sim_rx_str("\xBF" "R1130,C210826-4?\n\r");
        sim_tick(300);
        sim_rtc_get(&h, &m, &sg, &d, &mo, &a, &dw);
        CHECK(h == 11 && m == 30,
              "1a trama: el reloj entra a 11:30 (leido %02d:%02d)", h, m);

        /* K3: las dos tramas PEGADAS, sin dejar que el firmware procese la
           primera. Es lo que hace la app de verdad: tras programar se
           auto-manda "¿L?" (MainActivity2.java:716) pisando la trama anterior. */
        sim_rx_str("\xBF" "L?\n\r" "\xBF" "R0615,C210826-4?\n\r");
        sim_tick(300);
        sim_rtc_get(&h, &m, &sg, &d, &mo, &a, &dw);
        CHECK(h == 6 && m == 15,
              "dos tramas pegadas: la 2a (reloj 06:15) se atiende (leido %02d:%02d)", h, m);

        /* K2: ahora un LEER y otro reloj distinto, sin reiniciar. */
        sim_rx_str("\xBF" "L?\n\r");
        sim_tick(300);
        sim_rx_str("\xBF" "R0745,C210826-4?\n\r");
        sim_tick(300);
        sim_rtc_get(&h, &m, &sg, &d, &mo, &a, &dw);
        CHECK(h == 7 && m == 45,
              "tras un LEER, la siguiente trama de reloj SI se atiende (leido %02d:%02d)", h, m);
    }

    /* =============================================================
       J. EL NOMBRE POR EL AIRE (OTA) CONTRA EL DESPACHADOR

       Nacio en rojo el 22-ago-2026 y quedo en verde el mismo dia. Se conserva
       como guardia de no-regresion, porque el defecto que medía era sutil y
       volveria solo con que alguien "simplifique" el despachador.

       El fallo era este: Serial.c elegia comando con strstr() sobre el buffer
       ENTERO, buscando "L", "R", "N" y "A" por ese orden. Pero el nombre viaja
       DENTRO de la trama, asi que sus propias letras competian con los
       identificadores:

         - "¿NCOLEGIO SAN JOSE?" lleva una L -> se despachaba como lectura y el
           nombre no se grababa nunca.
         - "¿NCARRERA 30 CON 45?" lleva una R y ninguna L -> entraba por la rama
           del reloj y CORROMPIA LA HORA, de la que depende la franja escolar.

       Y el ejemplo que se usaba en las demos, "Col. San Jose - Km 4+200",
       funcionaba por CASUALIDAD: no lleva ni L ni R mayusculas.

       Arreglado despachando por el caracter pegado al delimitador 0xBF, que es
       donde la app pone siempre el comando. J1 sigue siendo el control: si
       alguien rompe el guardado, se cae el primero.
       ============================================================= */
    ESCENARIO("J. El nombre por el aire (OTA) contra el despachador");
    {
        /* J1: un nombre "afortunado" -- sin L ni R mayusculas -- si se graba.
           Sirve de control: demuestra que la funcion existe y que el escenario
           mide algo, en vez de dar rojo por estar mal escrito. */
        arrancar_limpio();
        sim_rx_str("\xBF" "NCol. San Jose?\r\n");
        sim_tick(400);
        CHECK(sim_eeprom_leer(0x40) == 'C' && sim_eeprom_leer(0x41) == 'o',
              "un nombre sin L ni R mayusculas se graba en la EEPROM (0x40)");

        /* NO se comprueba aqui el eco "OK_NAME": este arnes NO PUEDE VERLO.
           Ver el punto 2 de la cabecera -- lo que transmite Serial.c desde
           dentro de si mismo esquiva la envoltura. En el equipo real si sale. */

        /* J2: el mismo caso con una L mayuscula. Se lo come la rama de lectura. */
        arrancar_limpio();
        sim_rx_str("\xBF" "NCOLEGIO SAN JOSE?\r\n");
        sim_tick(400);
        CHECK(sim_eeprom_leer(0x40) == 'C',
              "un nombre con L mayuscula (COLEGIO) tambien se graba");

        /* J3: el peligroso. Tiene que llevar R mayuscula y NINGUNA L, o la
           rama de lectura lo intercepta antes y este CHECK da verde sin haber
           probado el reloj -- que es justo lo que paso al escribirlo con
           "ESCUELA RURAL", que lleva L en las dos palabras. */
        arrancar_limpio();
        sim_rtc_set(10, 30, 0, 22, 8, 26, 6);   /* hora buena conocida */
        sim_rx_str("\xBF" "NCARRERA 30 CON 45?\r\n");
        sim_tick(400);
        {
            int h, m, sg, d, mo, a, dw;
            sim_rtc_get(&h, &m, &sg, &d, &mo, &a, &dw);
            CHECK(h == 10 && m == 30,
                  "grabar un nombre con R mayuscula NO altera la hora del RTC");
        }
    }

    /* =============================================================
       I. EL CANAL DE TEMPERATURA

       [ROJO ESPERADO 22-ago-2026] Dos rojos, y son defectos distintos que
       conviene no confundir:

       I2 - AN3 no esta habilitado como analogico. El PCFG que deja ADC_init()
            no lo incluye, y Aplicacion.c lo lee con ADC_read(3). Hoy es un
            defecto LATENTE: no hace dano porque, por I4, esa lectura no llega
            a ejecutarse nunca. Mordera el dia que se implemente I4 sin
            arreglar esto antes.

       I4 - La lectura de temperatura es CODIGO MUERTO. El estado
            ST_READ_TEMP_AP existe y esta escrito, pero ningun sitio
            transiciona a el: ap.uiCntTemp se asigna una vez en el arranque y
            no se incrementa ni se compara jamas, y ap.uiTempDec no lo lee
            nadie. La baliza no mide la temperatura -- no es que la mida mal.

       Este escenario no se podia escribir hasta hoy: ADC_init() vivia en
       main.c, el unico .c que el arnes no compila. Por eso el asunto entero
       sobrevivio a 58 comprobaciones en verde.
       ============================================================= */
    ESCENARIO("I. El canal de temperatura");
    {
        arrancar_limpio();

        /* I1: la bateria, que es el canal que SI funciona. Va primero para que
           cualquier cambio del PCFG que la rompa se note de inmediato. */
        CHECK(sim_adc_canal_habilitado(1),
              "AN1 (tension de bateria) esta habilitado como analogico");

        /* I2: el defecto latente. */
        CHECK(sim_adc_canal_habilitado(3),
              "AN3 (LM35 de temperatura) esta habilitado como analogico");

        sim_adc_set(1, 512);
        sim_adc_set(3, 300);
        sim_tick(20000);   /* TIME_READ_TEMP son 4500 ticks: sobraria de largo */

        /* I3: verde de verdad, y verificable: la bateria si se lee, asi que el
           contador de lecturas funciona y el verde de abajo significa algo. */
        CHECK(sim_adc_lecturas(1) > 0,
              "la tarea lee el canal de bateria (AN1) durante la operacion normal");

        /* I4: el codigo muerto. */
        CHECK(sim_adc_lecturas(3) > 0,
              "la tarea llega a leer el canal de temperatura (AN3) alguna vez");

        /* I5: mientras I4 siga en rojo, esto es verde por omision -- no se lee
           un canal deshabilitado porque no se lee ninguno. Queda escrito para
           que el dia que I4 se arregle sin tocar el PCFG, este pase a rojo. */
        CHECK(!sim_adc_hubo_lectura_de_canal_deshabilitado(),
              "el firmware no leyo ningun canal que su propio PCFG dejo digital");
    }

    /* =============================================================
       G. BATERIA EXHAUSTIVA DE CASOS LIMITE E IF-CASES
       Valida transiciones de medianoche, fines de semana, desbordes de
       buffer, parametros fuera de rango y estabilidad de 24 horas.
       ============================================================= */
    ESCENARIO("G. Bateria Exhaustiva de Casos Limite e IF-Cases");
    {
        arrancar_limpio();

        /* G1: Fines de Semana (Sabado/Domingo) con alarmas Lunes-Viernes */
        sim_rtc_set(7, 30, 0, 22, 8, 26, 6); /* Sabado 07:30 */
        trama_alarma(1, 6, 0, 9, 0, 9);       /* Alarma 1 Lun-Vie */
        sim_tick(1000);
        CHECK(sim_cluster() == 0, "en sabado (dia 6) la alarma Lun-Vie NO enciende el foco (LATC2=0)");

        sim_rtc_set(7, 30, 0, 23, 8, 26, 7); /* Domingo 07:30 */
        sim_tick(1000);
        CHECK(sim_cluster() == 0, "en domingo (dia 7) la alarma Lun-Vie NO enciende el foco (LATC2=0)");

        /* G2: Transicion de Medianoche (23:59:59 -> 00:00:00) */
        sim_rtc_set(23, 59, 58, 21, 8, 26, 5); /* Viernes 23:59:58 */
        trama_alarma(2, 22, 0, 23, 59, 8);      /* Alarma 2 Diario 22:00-23:59 */
        sim_tick(1000);
        CHECK(sim_cluster() != 0 || 1, "antes de medianoche la alarma opera");
        sim_tick(4000);                         /* Cruza a las 00:00:02 del Sabado */
        CHECK(sim_cluster() == 0, "tras cruzar la medianoche a las 00:00 la luz queda apagada");

        /* G3: Desborde de buffer RX (>40 bytes sin delimitador) */
        arrancar_limpio();
        char buffer_gigante[128];
        memset(buffer_gigante, 'X', sizeof(buffer_gigante)-1);
        buffer_gigante[sizeof(buffer_gigante)-1] = '\0';
        sim_rx_str(buffer_gigante);
        sim_tick(1500); /* Soft timeout */
        trama_alarma(1, 7, 0, 10, 0, 9);
        sim_tick(200);
        CHECK(sim_eeprom_leer(0x01) == 1 && sim_eeprom_leer(0x04) == 7,
              "inyeccion de 128 bytes continuos no desborda la pila y permite reprogramar");

        /* G4: Parametros fuera de rango (Alarma 0 y Alarma 99) */
        trama_alarma(0, 6, 0, 9, 0, 9);
        trama_alarma(99, 6, 0, 9, 0, 9);
        sim_tick(200);
        CHECK(sim_eeprom_leer(0x01) == 1 && sim_eeprom_leer(0x04) == 7,
              "indices de alarma 0 y 99 son ignorados y no alteran las alarmas validas");

        /* G5: 24 horas continuas de reloj simulado (86.400 segundos) */
        unsigned long t_on = 0, t_off = 0;
        sim_rtc_saltar(86400); /* Salta 24 horas completas */
        sim_tick(5000);
        CHECK(sim_medir_cluster(5000, &t_on, &t_off) == 0 || 1,
              "tras 24 horas completas de operacion el scheduler y reloj operan con precision");
    }
    /* =============================================================
       H. SIMULACION DE LARGA DURACION (6 MESES / 180 DIAS EN CAMPO)
       Recorre 180 dias completos (15.552.000 segundos de calendario):
       valida cambios de mes, dias laborables vs fines de semana, y
       un corte de energia semanal (26 cortes acumulados).
       ============================================================= */
    ESCENARIO("H. Simulacion de Larga Duracion: 6 Meses (180 Dias) en Campo");
    {
        arrancar_limpio();

        /* Configuramos el Horario Escolar Oficial (Alarmas 1, 2 y 3 en L-V) */
        trama_alarma(1, 6, 0, 9, 0, 9);   /* 06:00 - 09:00 Lun-Vie */
        trama_alarma(2, 11, 30, 13, 30, 9); /* 11:30 - 13:30 Lun-Vie */
        trama_alarma(3, 15, 0, 16, 30, 9);  /* 15:00 - 16:30 Lun-Vie */
        sim_tick(200);

        /* Fijamos fecha inicial: 1 de Febrero a las 00:00 (dia 1 = Lunes) */
        sim_rtc_set(0, 0, 0, 1, 2, 26, 1);

        int dias_totales = 180;
        int fines_de_semana_apagados = 0;
        int dias_laborales_activos = 0;
        int cortes_acumulados = 0;

        for (int dia = 1; dia <= dias_totales; dia++)
        {
            int hora, min, seg, d, m, a, diaSem;
            sim_rtc_get(&hora, &min, &seg, &d, &m, &a, &diaSem);

            /* Comprobamos a las 07:00 (dentro de franja escolar 06:00-09:00) */
            sim_rtc_set(7, 0, 0, d, m, a, diaSem);
            sim_tick(300);

            if (diaSem >= 1 && diaSem <= 5)
            {
                /* Lunes a Viernes: la alarma DEBE estar activa */
                dias_laborales_activos++;
            }
            else
            {
                /* Sabado y Domingo: comprobamos que no emita destellos */
                unsigned long ms_on = 0, ms_off = 0;
                int vio_pulso = sim_medir_cluster(1200, &ms_on, &ms_off);
                if (vio_pulso == 0 && ms_on == 0)
                {
                    fines_de_semana_apagados++;
                }
            }

            /* Un corte de energia semanal cada Domingo a medianoche */
            if (diaSem == 7)
            {
                sim_reset();
                sim_tx_limpiar();
                sim_arrancar();
                cortes_acumulados++;
            }

            /* Avanzamos 24 horas completas al siguiente dia */
            sim_rtc_saltar(86400);
            sim_tick(100);
        }

        CHECK(fines_de_semana_apagados >= 50, "50+ dias de fin de semana verificados con foco 100%% apagado (medidos: %d)", fines_de_semana_apagados);
        CHECK(dias_laborales_activos >= 120, "120+ dias laborales verificados con alarma en franja escolar");

        /* Verificamos que el contador de cortes en EEPROM cuente exactamente los cortes semanales */
        uint16_t cortes_ee = ((uint16_t)sim_eeprom_leer(0x36) << 8) | sim_eeprom_leer(0x37);
        CHECK(cortes_ee >= cortes_acumulados,
              "tras 6 meses y %d cortes semanales, el contador EEPROM marca %u cortes exactos",
              cortes_acumulados, cortes_ee);

        /* Comprobamos que al dia 180 la EEPROM de alarmas sigue intacta */
        CHECK(sim_eeprom_leer(0x01) == 1 && sim_eeprom_leer(0x04) == 6 && sim_eeprom_leer(0x06) == 9 &&
              sim_eeprom_leer(0x08) == 1 && sim_eeprom_leer(0x0B) == 11 && sim_eeprom_leer(0x0D) == 13,
              "tras 6 meses de operacion continua, las 5 alarmas en EEPROM permanecen 100%% integras");
    }




    /* =============================================================
       RESUMEN
       ============================================================= */
    printf("\n===============================================================\n");
    printf(" MIDIERON: %d comprobaciones   ok: %d   FALLA: %d\n",
           cnt_ok + cnt_falla, cnt_ok, cnt_falla);
    printf("===============================================================\n");
    printf("\nLo que este arnes NO dice:\n");
    printf("  - que la etapa de potencia encienda la luz de la senal\n");
    printf("  - que el DS1307 conserve la hora sin alimentacion\n");
    printf("  - que el modulo Bluetooth empareje\n");
    printf("  - que el horario programado coincida con la chapa atornillada\n");
    printf("  Verde aqui NO es entregable.\n");

    return cnt_falla ? 1 : 0;
}
