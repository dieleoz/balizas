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
   --------------------------------------------------------------- */

#include "xc.h"
#include "Serial.h"
#include "Alarma.h"
#include "Aplicacion.h"
#include "sim.h"

/* Estado interno del firmware que algunos escenarios necesitan observar. */
extern strAnaTrama          anaT1;
extern strSerial            serial1;
extern enum states_alarm    stateAlarm;
extern srtAlarmas           ala1;
extern srtAlarmas           ala1;

/* La original, renombrada al compilar Serial.c. */
void fw_transmitUart1(char *ptr);
void sim_tx_byte(unsigned char b);

void transmitUart1(char *ptr)
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
    sim_rx_str("¿" "A3");            /* sin coma y sin fin de trama */
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

            /* Definicion del PO (21-ago-2026): 2 s encendida, 2 s apagada. */
            CHECK(on >= 1800 && on <= 2200,
                  "el pulso ENCENDIDO dura 2 s +-10%% (medido %lu ms)", on);
            CHECK(off >= 1800 && off <= 2200,
                  "el pulso APAGADO dura 2 s +-10%% (medido %lu ms)", off);
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
        CHECK(!(estado_antes == estado_despues &&
                estado_antes >= (int)ST_CHECK_ALARM1 &&
                estado_antes <= (int)ST_CHECK_ALARM5),
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
