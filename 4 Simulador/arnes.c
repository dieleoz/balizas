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

    ESCENARIO("D1. [ROJO ESPERADO 21-ago-2026] Arrancar DENTRO de la franja");
    {
        /* Alarma.c:420-445 compara por igualdad exacta: rtc.hor == hourInit &&
           rtc.min == minInit. Si el equipo arranca -- o se le va la luz y vuelve --
           a las 07:00 con una franja de 06:00 a 09:00, ese minuto exacto ya paso
           y no vuelve hasta manana. La senal se queda APAGADA toda la manana
           escolar mientras la chapa atornillada anuncia 30 km/h.
           Un corte de luz de un minuto a las 06:30 tiene el mismo efecto. */
        arrancar_limpio();
        sim_rx_str("\xBF" "R0700,C210826-5?\n\r");
        sim_tick(300);
        trama_alarma(1, 6, 0, 9, 0, 8);
        sim_tick(20000);
        CHECK(sim_cluster() != 0,
              "arrancando a las 07:00 dentro de la franja 06:00-09:00, la luz enciende");
    }

    ESCENARIO("D2. [ROJO ESPERADO 21-ago-2026] Dias personalizados: se traga la orden");
    {
        /* Serial.c:270 -- `if((ulDayAlarm > 7) && (ulDayAlarm < 11))`. Un dia
           concreto (1..7, que es lo que el propio Alarma.h define como LUNE..DOMI)
           cae en el `else`, y ese else esta VACIO. No se graba nada en EEPROM y
           no se contesta un error: el movil dice "Mensaje Enviado!!" y la alarma
           no existe. Peor: ala1.flagAlarm ya se habia puesto a true unas lineas
           antes (Serial.c:263), asi que queda una alarma habilitada con dayAlar
           sin asignar. */
        arrancar_limpio();
        trama_alarma(1, 6, 0, 9, 0, 3);      /* D3 = solo los miercoles */
        CHECK(sim_eeprom_leer(0x01) == 1,
              "una alarma pedida para un dia concreto queda grabada (EE[0x01]=%d)",
              sim_eeprom_leer(0x01));
        CHECK(sim_eeprom_leer(0x11) == 3,
              "el dia pedido queda grabado en 0x11 (leido %d)", sim_eeprom_leer(0x11));
    }

    ESCENARIO("D3. [ROJO ESPERADO 21-ago-2026] Dias personalizados: cuelgan la tarea");
    {
        /* Alarma.c:240-245 y sus cuatro copias: la rama `else` de flagDayAlar
           esta vacia. Sin asignacion a stateAlarm la maquina se queda en
           ST_CHECK_ALARMn para siempre -- deja de leer el reloj y deja de mirar
           las otras cuatro alarmas. No es que falle una alarma: se lleva por
           delante el equipo entero.

           Hoy la app nunca manda dias personalizados, asi que la unica via es un
           byte de "personalizado" distinto de cero en EEPROM (direcciones 0x02,
           0x09, 0x10, 0x17, 0x1E). Se pone a mano, que es exactamente lo que
           dejaria una EEPROM a medio inicializar o un golpe de tension durante
           una escritura. */
        int estado_antes, estado_despues;
        arrancar_limpio();
        trama_alarma(1, 6, 0, 9, 0, 8);
        sim_eeprom_escribir(0x02, 1);        /* alarma 1 = dias personalizados */
        sim_reset();                         /* y se le corta la luz: al volver,
                                                ST_READ_MEMO_AP relee la EEPROM
                                                y ST_UPDATE_ALA copia el flag */
        sim_arrancar();
        sim_tick(3000);                      /* ~1 s despues del arranque ya esta
                                                clavada; se deja margen */
        estado_antes   = (int)stateAlarm;
        sim_tick(10000);
        estado_despues = (int)stateAlarm;
        CHECK(!(estado_antes == estado_despues &&
                estado_antes >= (int)ST_CHECK_ALARM1 &&
                estado_antes <= (int)ST_CHECK_ALARM5),
              "con dias personalizados la tarea de alarma sigue avanzando "
              "(estado %d -> %d)", estado_antes, estado_despues);
    }

    ESCENARIO("D4. [ROJO ESPERADO 21-ago-2026] transmitUart1 manda un NUL de mas");
    {
        /* Serial.c:59 -- `for(int x = 0; x <= ucCntTx1; x++)`. El `<=` hace que
           el ultimo byte transmitido sea bufferTx1[strlen], es decir el '\0'
           terminador. Cada linea que el equipo manda al movil lleva un 0x00
           pegado detras. */
        arrancar_limpio();
        TXREG = 0xAA;
        fw_transmitUart1((char *)"HOLA");
        CHECK(TXREG != 0x00,
              "el ultimo byte escrito en TXREG no es el terminador (es 0x%02X)", TXREG);
    }

    ESCENARIO("D5. [ROJO ESPERADO 21-ago-2026] Trama truncada: se sale de la trama");
    {
        /* Serial.c:449-467 -- extraerValue() llama a strstr() y NO comprueba si
           devolvio NULL, y despues copia en `char buffer[4]` hasta encontrar el
           caracter final, SIN limite. Una trama a la que le falte la coma recorre
           memoria hasta dar con un byte que coincida por casualidad, y de paso
           desborda buffer[4].

           Esto TUMBA el proceso, asi que se mide en un hijo: si el hijo muere,
           el defecto esta vivo. Medirlo aqui dentro dejaria sin correr todo lo
           que viene detras -- y un arnes que se cae a la mitad no midio nada de
           lo que faltaba. */
        int r = system(cmd_hijo("--trama-truncada"));
        CHECK(r == 0,
              "una trama truncada no tumba el firmware (el hijo salio con %d)", r);
    }

    ESCENARIO("D6. [ROJO ESPERADO 21-ago-2026] Franjas solapadas: se apagan entre ellas");
    {
        /* Las 5 alarmas comparten UN SOLO flag, ap.flagAlarm (Alarma.c:427 y sus
           copias). No hay cuenta de cuantas franjas estan activas: la primera que
           llega a su hora de fin lo baja, aunque otra siga dentro de su franja.
           Con dos franjas que se solapen -- 06:00-09:00 y 08:00-12:00 -- la senal
           se apaga a las 09:00 y no vuelve hasta las 11:30 del dia siguiente. */
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
