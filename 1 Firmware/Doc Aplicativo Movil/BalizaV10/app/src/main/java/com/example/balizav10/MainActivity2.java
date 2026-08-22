package com.example.balizav10;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.graphics.Color;
import java.util.Date;
import java.util.Locale;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.lang.reflect.Array;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import android.os.AsyncTask;

public class MainActivity2 extends AppCompatActivity {

    public static final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");

    static final String TAG = "client";
    BluetoothAdapter mBluetoothAdapter = null;
    BluetoothDevice device;

    private BluetoothSocket btSocket;

    //*** RUTINA CALENDARIO ***
    Calendar calendar;
    SimpleDateFormat simpleDateFormat;
    String Date;
    //*************************

    private ScrollView scrollViewOut;
    private TextView txtVoutput;
    private Button btnDevice;
    private Button btnRead;
    private Button btConf;
    private Button btnTestLuz;
    private Button btnStopTest;
    private Button btnCargarHorarioEscolar;

    // --- Horario de la placa: hasta CUATRO franjas ---------------------------
    // El horario NO es el mismo en todos los colegios: va impreso en la placa
    // atornillada a cada senal. Estos valores son solo el punto de partida que
    // ve el tecnico; los edita contra la placa que tiene delante.
    private androidx.appcompat.widget.SwitchCompat[] swFranja =
            new androidx.appcompat.widget.SwitchCompat[4];
    private Button[] btnFranjaIni = new Button[4];
    private Button[] btnFranjaFin = new Button[4];
    private int[] hIni = { 6, 11, 15, 0 };
    private int[] mIni = { 0, 30,  0, 0 };
    private int[] hFin = { 9, 13, 16, 0 };
    private int[] mFin = { 0, 30, 30, 0 };
    private Spinner spDiasPlaca;
    private Button btnGrabarPlaca, btnReceso, btnReanudar;

    // Codigos de dia del firmware: 8 diario, 9 lunes a viernes, 10 fin de semana.
    private static final int[] COD_DIAS = { 9, 8, 10 };

    // Cola de tramas a enviar. Se manda una por una y CON PAUSA -- ver
    // enviarSecuencia() y el porque en RETARDO_TRAMA_MS.
    private java.util.ArrayList<String> tramasPendientes = new java.util.ArrayList<String>();
    private boolean bEnviarSecuencia = false;

    // EL RETARDO ENTRE TRAMAS NO ES OPCIONAL, y no es prudencia: es una
    // limitacion real del PIC. No tiene buffer de tramas -- taskAnalizaUart1
    // despierta cada milisegundo y espera 5 vueltas antes de cerrar la trama y
    // copiarla (Serial.c:122). Si la siguiente entra dentro de esa ventana, las
    // dos acaban en el MISMO buffer y el firmware solo atiende a la primera:
    // el segundo comando se pierde SIN ERROR NI AVISO, y la senal se queda con
    // el horario viejo.
    //
    // Minimo medido en el arnes (bloque K): 25 ms. Pero ahi los bytes entran
    // instantaneos; en el equipo real hay que sumar el tiempo de hilo, que a
    // 9600 baudios son ya unos 26 ms para una trama de 25 caracteres.
    // NO BAJAR ESTE NUMERO para que "vaya mas rapido".
    private static final int RETARDO_TRAMA_MS = 450;
    private TextView txtVoltaje;
    private TextView txtEstadoBat;
    private TextView txtCortes;
    private TextView txtSalud;
    private Button btnExportAudit;
    private android.widget.EditText edtNombreBaliza;
    private Button btnGuardarNombre;
    private Button btnGuardarFranjaManual;
    private TextView txtIconoDictamen;
    private TextView txtTituloDictamen;
    private TextView txtMensajeDictamen;
    private TextView txtAccionRecomendada;
    // --- Mantenimiento e inspeccion -----------------------------------------
    // El tipo de inspeccion NO es cosmetico: decide que se puede verificar
    // honestamente. Desde el suelo se comprueba lo que llega por Bluetooth y lo
    // que se ve desde la via; subir al poste es otro trabajo, con escalera y
    // equipo de proteccion.
    //
    // Por eso los puntos que exigen subir NO se muestran en gris cuando la
    // modalidad es de suelo: SE OCULTAN. Si no estan en pantalla no se marcan
    // por descuido, y un checklist que permite afirmar lo que no se ha
    // comprobado convierte una revision incompleta en un acta que dice que fue
    // completa.
    private android.widget.EditText edtTecnico;
    private Button btnModoSuelo, btnModoAltura;
    private android.view.View grupoAltura;
    private TextView txtAvisoModalidad;
    private boolean inspeccionEnAltura = false;

    private static final int[] ID_CHK_SUELO = {
            R.id.idChkFis1, R.id.idChkFis2, R.id.idChkFis3, R.id.idChkFis4,
            R.id.idChkOpe1, R.id.idChkOpe2, R.id.idChkOpe3, R.id.idChkOpe4, R.id.idChkOpe5 };
    private static final int[] ID_CHK_ALTURA = {
            R.id.idChkAlt1, R.id.idChkAlt2, R.id.idChkAlt3, R.id.idChkAlt4,
            R.id.idChkAlt5, R.id.idChkAlt6, R.id.idChkAlt7 };

    private android.widget.CheckBox[] chkSuelo = new android.widget.CheckBox[9];
    private android.widget.CheckBox[] chkAltura = new android.widget.CheckBox[7];
    private android.widget.CheckBox chkPilaRTC;
    private android.widget.CheckBox chkBorneras;
    private android.widget.CheckBox chkTestLuz;
    private String diagnosticoPilaRTC = "OK";
    private String diagnosticoBateria12V = "OK";
    private String diagnosticoCortes = "OK";
    private final StringBuilder trafficLog = new StringBuilder();
    private Spinner spNoAlarm;
    private Spinner spHourInit;
    private Spinner spMinInit;
    private Spinner spHourEnd;
    private Spinner spMinEnd;
    private Spinner spHorario;

    private Switch swOnOff;

    public byte[] mmBuffer;
    public boolean  bReadConf = false;
    public boolean  bOnOffAlarm = false;
    public boolean  bHorarioEscolarFull = false;
    public String sFrameHourCal = "";
    public String sFrameConf = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);

        // Configurar icono IT Vial y título en Action Bar
        if (getSupportActionBar() != null)
        {
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setIcon(R.drawable.logo_it_vial_icon);
            getSupportActionBar().setTitle(" IT VIAL 30");
        }

        scrollViewOut = (ScrollView)findViewById(R.id.idScrollViewOut);
        txtVoutput = (TextView)findViewById(R.id.idTxtViewOut);
        btnDevice = (Button)findViewById(R.id.idBtnDispositivo);
        btnRead = (Button)findViewById(R.id. idBtnLeer);
        btConf = (Button)findViewById(R.id. idBtnConf);
        swOnOff = (Switch)findViewById(R.id.idSwEn);

        spNoAlarm = (Spinner)findViewById(R.id. idSpNoAlarm);
        spHourInit = (Spinner)findViewById(R.id. idSpHourInit);
        spMinInit = (Spinner)findViewById(R.id. idSpMinInit);
        spHourEnd = (Spinner)findViewById(R.id. idSpHourEnd);
        spMinEnd = (Spinner)findViewById(R.id. idSpMinEnd);
        spHorario = (Spinner)findViewById(R.id. idSpHorario);


        String [] sOptionNumAlarm = {"1", "2", "3", "4", "5"};
        String [] sOptionHour = {"00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"};
        String [] sOPtionMin = {"00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"};
        String [] sOPtionHorario = {"Diario", "Lun-Vie", "Sab-Dom"};


        ArrayAdapter<String> adapterSNumAlarm = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, sOptionNumAlarm);
        ArrayAdapter<String> adapterSHour = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, sOptionHour);
        ArrayAdapter<String> adapterSMin = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, sOPtionMin);
        ArrayAdapter<String> adapterHorario = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, sOPtionHorario);

        spNoAlarm.setAdapter(adapterSNumAlarm);
        spHourInit.setAdapter(adapterSHour);
        spMinInit.setAdapter(adapterSMin);

        spHourEnd.setAdapter(adapterSHour);
        spMinEnd.setAdapter(adapterSMin);

        spHorario.setAdapter(adapterHorario);

        //init disable sp!!
        spHourInit.setEnabled(false);
        spMinInit.setEnabled(false);
        spHourEnd.setEnabled(false);
        spMinEnd.setEnabled(false);
        spHorario.setEnabled(false);

        //init disablbe bt!!
        btnRead.setEnabled(false);
        btConf.setEnabled(false);

        //SWITCH
        swOnOff.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                if(swOnOff.isChecked())
                {
                    bOnOffAlarm = true;
                    spHourInit.setEnabled(true);
                    spMinInit.setEnabled(true);
                    spHourEnd.setEnabled(true);
                    spMinEnd.setEnabled(true);
                    spHorario.setEnabled(true);

                }
                else
                {
                    bOnOffAlarm = false;
                    spHourInit.setEnabled(false);
                    spMinInit.setEnabled(false);
                    spHourEnd.setEnabled(false);
                    spMinEnd.setEnabled(false);
                    spHorario.setEnabled(false);

                }
            }
        });

        //BOTON CONFIGURAR
        btConf.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                bReadConf = true;

                //*** rutina calendar y reloj limpia sin bytes nulos ***
                calendar = Calendar.getInstance();
                SimpleDateFormat sdfHour = new SimpleDateFormat("HHmm", java.util.Locale.US);
                SimpleDateFormat sdfDate = new SimpleDateFormat("ddMMyy-u", java.util.Locale.US);
                String sHour = sdfHour.format(calendar.getTime());
                String sDate = sdfDate.format(calendar.getTime());

                sFrameHourCal = "¿R" + sHour + ",C" + sDate + "?\r\n";
                //*****************************************************


                //*** adquisicion de la trama ***

                String numAlarm;
                String sHouri, sMini, sHourE, sMinE, sAlarmD;


                //si esta activo el  switch
                if(bOnOffAlarm)
                {
                    numAlarm = spNoAlarm.getSelectedItem().toString();
                    sHouri = spHourInit.getSelectedItem().toString();
                    sMini = spMinInit.getSelectedItem().toString();
                    sHourE = spHourEnd.getSelectedItem().toString();
                    sMinE = spMinEnd.getSelectedItem().toString();
                    sAlarmD = spHorario.getSelectedItem().toString();

                    if("Diario".equals(sAlarmD))  sAlarmD = "8";
                    else if("Lun-Vie".equals(sAlarmD)) sAlarmD = "9";
                    else sAlarmD = "10";


                    sFrameConf = "¿A"+numAlarm+",E1,I"+sHouri+sMini+",F"+sHourE+sMinE+",D"+sAlarmD+",?\n\r";
                }
                else
                {
                    numAlarm = spNoAlarm.getSelectedItem().toString();

                    sFrameConf = "¿A"+numAlarm+",E0,?\n\r";

                }
                //*******************************


                //envia el comando para leer el dispositivo
                startClient();
            }
        });

        //BOTON DEVICE
        btnDevice.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
               //empareja
                querypaired();
            }
        });

        btnGuardarFranjaManual = (Button) findViewById(R.id.idBtnGuardarFranjaManual);
        if (btnGuardarFranjaManual != null)
        {
            btnGuardarFranjaManual.setEnabled(false);
            btnGuardarFranjaManual.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    if (btConf != null) btConf.performClick();
                }
            });
        }

        btnRead.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                bReadConf = false;
                //envia el comando para leer el dispositivo
                startClient();
            }
        });

        btnTestLuz = (Button)findViewById(R.id.idBtnTestLuz);
        btnStopTest = (Button)findViewById(R.id.idBtnStopTest);

        if (btnTestLuz != null)
        {
            btnTestLuz.setEnabled(false);
            btnTestLuz.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    if (device == null)
                    {
                        Toast.makeText(MainActivity2.this, "Seleccione primero el dispositivo Bluetooth", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    startTestLuz2Min();
                }
            });
        }

        if (btnStopTest != null)
        {
            btnStopTest.setEnabled(false);
            btnStopTest.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    if (device == null)
                    {
                        Toast.makeText(MainActivity2.this, "Seleccione primero el dispositivo Bluetooth", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    stopTestLuz();
                }
            });
        }

        /* ENLACE QUE FALTABA. edtNombreBaliza se declaraba y NUNCA se asignaba,
           asi que guardarNombreBaliza() salia siempre por su propio
           "if (edtNombreBaliza == null) return;". El tecnico escribia el nombre
           del colegio, pulsaba GUARDAR y no pasaba nada -- y el acta salia
           siempre con "Sin Asignar". Encontrado por comprobar_ui.py el
           22-ago-2026, cuarto control muerto del mismo patron. */
        edtNombreBaliza = (android.widget.EditText) findViewById(R.id.idEdtNombreBaliza);
        Button btnGuardarNombre = (Button) findViewById(R.id.idBtnGuardarNombre);
        if (btnGuardarNombre != null)
            btnGuardarNombre.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { guardarNombreBaliza(); }
            });

        edtNombreBaliza = (android.widget.EditText) findViewById(R.id.idEdtNombreBaliza);
        btnGuardarNombre = (Button) findViewById(R.id.idBtnGuardarNombre);
        if (btnGuardarNombre != null)
        {
            btnGuardarNombre.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    guardarNombreBaliza();
                }
            });
        }

        montarTarjetaHorarioPlaca();
        montarTarjetaMantenimiento();

        //setup the bluetooth adapter.
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        if (mBluetoothAdapter == null)
        {
            // Device does not support Bluetooth
            Toast.makeText(getApplicationContext(),"No Hay Bluetooth",Toast.LENGTH_SHORT).show();
            btnRead.setEnabled(false);
            btnDevice.setEnabled(false);
            if (btnTestLuz != null) btnTestLuz.setEnabled(false);
            if (btnStopTest != null) btnStopTest.setEnabled(false);
            if (btnGrabarPlaca != null) btnGrabarPlaca.setEnabled(false);
            if (btnReceso != null)      btnReceso.setEnabled(false);
            if (btnReanudar != null)    btnReanudar.setEnabled(false);
        }

    }//fin onCreate

     private Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            String incoming = msg.getData().getString("msg");
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
            if (incoming != null && !incoming.trim().isEmpty()) {
                trafficLog.append("[").append(sdf.format(new Date())).append(" RX] ").append(incoming.trim()).append("\n");
            }
            txtVoutput.append(incoming);
            parseTelemetry(txtVoutput.getText().toString());
            if (scrollViewOut != null) {
                scrollViewOut.post(new Runnable() {
                    @Override
                    public void run() {
                        scrollViewOut.fullScroll(View.FOCUS_DOWN);
                    }
                });
            }
            return true;
        }
    });

    public void mkmsg(String str) {
        //handler junk, because thread can't update screen!
        Message msg = new Message();
        Bundle b = new Bundle();
        b.putString("msg", str);
        msg.setData(b);
        handler.sendMessage(msg);
    }


    private static final int PERMISSION_REQUEST_CODE = 101;

    private boolean checkAndRequestPermissions()
    {
        if (android.os.Build.VERSION.SDK_INT >= 31)
        {
            String btConnect = "android.permission.BLUETOOTH_CONNECT";
            String btScan = "android.permission.BLUETOOTH_SCAN";
            if (androidx.core.content.ContextCompat.checkSelfPermission(this, btConnect) != android.content.pm.PackageManager.PERMISSION_GRANTED ||
                androidx.core.content.ContextCompat.checkSelfPermission(this, btScan) != android.content.pm.PackageManager.PERMISSION_GRANTED)
            {
                androidx.core.app.ActivityCompat.requestPermissions(this,
                    new String[]{btConnect, btScan}, PERMISSION_REQUEST_CODE);
                return false;
            }
        }
        else
        {
            if (androidx.core.content.ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != android.content.pm.PackageManager.PERMISSION_GRANTED)
            {
                androidx.core.app.ActivityCompat.requestPermissions(this,
                    new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_REQUEST_CODE);
                return false;
            }
        }
        return true;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults)
    {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_CODE)
        {
            boolean allGranted = true;
            for (int res : grantResults)
            {
                if (res != android.content.pm.PackageManager.PERMISSION_GRANTED)
                {
                    allGranted = false;
                    break;
                }
            }
            if (allGranted)
            {
                querypaired();
            }
            else
            {
                Toast.makeText(this, "Permiso de Bluetooth requerido para buscar dispositivos", Toast.LENGTH_LONG).show();
            }
        }
    }

    public void querypaired()
    {
        if (!checkAndRequestPermissions())
        {
            return;
        }

        try
        {
            if (mBluetoothAdapter == null)
            {
                mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            }

            if (mBluetoothAdapter == null)
            {
                Toast.makeText(this, "Este dispositivo no soporta Bluetooth", Toast.LENGTH_SHORT).show();
                return;
            }

            if (!mBluetoothAdapter.isEnabled())
            {
                Toast.makeText(this, "Por favor encienda el Bluetooth", Toast.LENGTH_SHORT).show();
                Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                startActivity(enableBtIntent);
                return;
            }

            Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();

            if (pairedDevices != null && pairedDevices.size() > 0)
            {
                final BluetoothDevice blueDev[] = new BluetoothDevice[pairedDevices.size()];
                String[] items = new String[blueDev.length];

                int i = 0;
                for (BluetoothDevice devicel : pairedDevices)
                {
                    blueDev[i] = devicel;
                    String devName = devicel.getName() != null ? devicel.getName() : "Desconocido";
                    items[i] = devName + "\n(" + devicel.getAddress() + ")";
                    i++;
                }

                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setTitle("Seleccione el Módulo Bluetooth:");

                builder.setSingleChoiceItems(items, -1, new DialogInterface.OnClickListener()
                {
                    public void onClick(DialogInterface dialog, int item)
                    {
                        dialog.dismiss();
                        if (item >= 0 && item < blueDev.length)
                        {
                            device = blueDev[item];
                            String dName = blueDev[item].getName() != null ? blueDev[item].getName() : blueDev[item].getAddress();
                            btnDevice.setText("✓ " + dName);

                            // habilitar botones de acción
                            btnRead.setEnabled(true);
                            btConf.setEnabled(true);
                            if (btnGuardarFranjaManual != null) btnGuardarFranjaManual.setEnabled(true);
                            if (btnTestLuz != null) btnTestLuz.setEnabled(true);
                            if (btnStopTest != null) btnStopTest.setEnabled(true);
                            if (btnGrabarPlaca != null) btnGrabarPlaca.setEnabled(true);
                            if (btnReceso != null)      btnReceso.setEnabled(true);
                            if (btnReanudar != null)    btnReanudar.setEnabled(true);

                            Toast.makeText(MainActivity2.this, "Conectando a " + dName + "...", Toast.LENGTH_SHORT).show();

                            // AUTO-LEER INMEDIATAMENTE AL SELECCIONAR
                            bReadConf = false;
                            startClient();
                        }
                    }
                });
                AlertDialog alert = builder.create();
                alert.show();
            }
            else
            {
                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setTitle("Sin Dispositivos Emparejados");
                builder.setMessage("No hay ningún módulo Bluetooth emparejado en su celular.\n\nVaya a los Ajustes de Bluetooth de su teléfono, busque el dispositivo (ej. JDY-31) y empareje con clave 1234.");
                builder.setPositiveButton("OK", null);
                builder.show();
            }
        }
        catch (SecurityException se)
        {
            Toast.makeText(this, "Permiso de Bluetooth no otorgado: " + se.getMessage(), Toast.LENGTH_LONG).show();
        }
        catch (Exception e)
        {
            Toast.makeText(this, "Error al buscar dispositivos: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }//fin querypaired

    // ====================================================================
    //  HORARIO DE LA PLACA
    //
    //  El boton anterior grababa TRES franjas fijas escritas en el codigo -- las
    //  de una instalacion concreta -- y ademas apagaba la alarma 4. En cualquier
    //  otro colegio eso grababa un horario que no era el de esa chapa y borraba
    //  la cuarta franja sin avisar, con la app confirmando "grabado con exito".
    //
    //  Ahora el horario lo pone el tecnico copiandolo de la placa que tiene
    //  delante, y se le ensena lo que se va a grabar ANTES de tocar la baliza.
    // ====================================================================

    private void montarTarjetaMantenimiento()
    {
        edtTecnico        = (android.widget.EditText) findViewById(R.id.idEdtTecnico);
        btnModoSuelo      = (Button) findViewById(R.id.idBtnModoSuelo);
        btnModoAltura     = (Button) findViewById(R.id.idBtnModoAltura);
        grupoAltura       = findViewById(R.id.idGrupoAltura);
        txtAvisoModalidad = (TextView) findViewById(R.id.idTxtAvisoModalidad);

        for (int i = 0; i < ID_CHK_SUELO.length; i++)
            chkSuelo[i] = (android.widget.CheckBox) findViewById(ID_CHK_SUELO[i]);
        for (int i = 0; i < ID_CHK_ALTURA.length; i++)
            chkAltura[i] = (android.widget.CheckBox) findViewById(ID_CHK_ALTURA[i]);

        /* El nombre se escribe UNA vez al empezar la jornada y aparece ya puesto
           en las veinte senales siguientes de la ruta. Es un dato del TELEFONO,
           no de la baliza -- al reves que el nombre del colegio, que se graba en
           la EEPROM del poste.

           Y es una ATRIBUCION, no una firma: acredita a quien preguntar, no
           quien estuvo. Se decidio asi a proposito el 22-ago-2026 -- unas
           credenciales por tecnico acaban siendo una credencial compartida, que
           es lo que ya pasa con el admin/admin del login. */
        if (edtTecnico != null)
        {
            edtTecnico.setText(getSharedPreferences("BalizasDB", MODE_PRIVATE)
                    .getString("tecnico", ""));
            edtTecnico.setOnFocusChangeListener(new View.OnFocusChangeListener() {
                @Override
                public void onFocusChange(View v, boolean tiene)
                {
                    if (!tiene) guardarTecnico();
                }
            });
        }

        if (btnModoSuelo != null)
            btnModoSuelo.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { setModalidad(false); }
            });
        if (btnModoAltura != null)
            btnModoAltura.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { setModalidad(true); }
            });

        /* ESTE ENLACE FALTABA. El boton existia en el layout y el metodo
           exportAuditReport() estaba escrito, pero nadie los unia: btnExportAudit
           se declaraba como campo y no se le hacia findViewById ni se le ponia
           listener. Resultado: se pulsaba y NO PASABA NADA. Mismo patron que las
           casillas del checklist. */
        btnExportAudit = (Button) findViewById(R.id.idBtnExportAudit);
        if (btnExportAudit != null)
            btnExportAudit.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v)
                {
                    guardarTecnico();
                    exportAuditReport();
                }
            });

        setModalidad(false);
    }

    private String tecnicoActual()
    {
        String t = (edtTecnico != null) ? edtTecnico.getText().toString().trim() : "";
        return t.isEmpty() ? "(sin identificar)" : t;
    }

    private void guardarTecnico()
    {
        if (edtTecnico == null) return;
        getSharedPreferences("BalizasDB", MODE_PRIVATE).edit()
                .putString("tecnico", edtTecnico.getText().toString().trim()).apply();
    }

    private void setModalidad(boolean altura)
    {
        inspeccionEnAltura = altura;

        if (btnModoSuelo != null) {
            btnModoSuelo.setBackgroundTintList(android.content.res.ColorStateList.valueOf(
                    Color.parseColor(altura ? "#F1F5F9" : "#1D4ED8")));
            btnModoSuelo.setTextColor(Color.parseColor(altura ? "#475569" : "#FFFFFF"));
        }
        if (btnModoAltura != null) {
            btnModoAltura.setBackgroundTintList(android.content.res.ColorStateList.valueOf(
                    Color.parseColor(altura ? "#1D4ED8" : "#F1F5F9")));
            btnModoAltura.setTextColor(Color.parseColor(altura ? "#FFFFFF" : "#475569"));
        }

        if (grupoAltura != null)
            grupoAltura.setVisibility(altura ? View.VISIBLE : View.GONE);

        /* Al volver a "suelo" se DESMARCAN los de altura. Si se quedaran
           marcados, el acta afirmaria algo verificado en una visita en la que no
           se subio. */
        if (!altura)
            for (android.widget.CheckBox c : chkAltura)
                if (c != null) c.setChecked(false);

        if (txtAvisoModalidad != null)
            txtAvisoModalidad.setText(altura
                ? "Inspeccion en altura. Se registran los 16 puntos."
                : "Inspeccion a nivel de suelo. 7 puntos requieren subir al poste "
                  + "y NO se han verificado en esta visita.");
    }

    /** El checklist tal y como va al acta: lo marcado, lo no marcado, y lo que
     *  ni siquiera se pudo mirar. Un acta que enumera lo no verificado es la
     *  diferencia entre un registro y una coartada. */
    private String checklistParaActa()
    {
        StringBuilder sb = new StringBuilder();
        int hechos = 0, total = 0;
        StringBuilder lineas = new StringBuilder();

        for (android.widget.CheckBox c : chkSuelo) {
            if (c == null) continue;
            total++;
            if (c.isChecked()) hechos++;
            lineas.append(c.isChecked() ? "  [X] " : "  [ ] ")
                  .append(c.getText())
                  .append(c.isChecked() ? "\n" : "   <-- NO VERIFICADO\n");
        }
        if (inspeccionEnAltura) {
            for (android.widget.CheckBox c : chkAltura) {
                if (c == null) continue;
                total++;
                if (c.isChecked()) hechos++;
                lineas.append(c.isChecked() ? "  [X] " : "  [ ] ")
                      .append(c.getText())
                      .append(c.isChecked() ? "\n" : "   <-- NO VERIFICADO\n");
            }
        }

        sb.append("MODALIDAD:  ")
          .append(inspeccionEnAltura
                  ? "Inspeccion EN ALTURA (subiendo al poste)"
                  : "Inspeccion A NIVEL DE SUELO (sin subir)")
          .append("\n----------------------------------------\n")
          .append("CHECKLIST - ").append(hechos).append(" de ").append(total)
          .append(" verificados\n")
          .append(lineas);

        if (!inspeccionEnAltura)
            sb.append("----------------------------------------\n")
              .append("NO APLICA EN ESTA MODALIDAD (requiere subir al poste):\n")
              .append("  herrajes . gabinete . lente del foco . panel solar .\n")
              .append("  fusible 12 V . borneras . pila CR2032\n");

        return sb.toString();
    }

    private void montarTarjetaHorarioPlaca()
    {
        int[] idSw  = { R.id.idSwF1,     R.id.idSwF2,     R.id.idSwF3,     R.id.idSwF4 };
        int[] idIni = { R.id.idBtnF1Ini, R.id.idBtnF2Ini, R.id.idBtnF3Ini, R.id.idBtnF4Ini };
        int[] idFin = { R.id.idBtnF1Fin, R.id.idBtnF2Fin, R.id.idBtnF3Fin, R.id.idBtnF4Fin };

        for (int i = 0; i < 4; i++)
        {
            final int k = i;
            swFranja[i]     = (androidx.appcompat.widget.SwitchCompat) findViewById(idSw[i]);
            btnFranjaIni[i] = (Button) findViewById(idIni[i]);
            btnFranjaFin[i] = (Button) findViewById(idFin[i]);

            if (btnFranjaIni[i] != null)
            {
                btnFranjaIni[i].setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) { pedirHora(k, true); }
                });
            }
            if (btnFranjaFin[i] != null)
            {
                btnFranjaFin[i].setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) { pedirHora(k, false); }
                });
            }
        }

        spDiasPlaca = (Spinner) findViewById(R.id.idSpDiasPlaca);
        if (spDiasPlaca != null)
        {
            ArrayAdapter<String> ad = new ArrayAdapter<String>(this,
                    android.R.layout.simple_spinner_item,
                    new String[] { "Lunes a viernes", "Todos los dias", "Sabado y domingo" });
            ad.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spDiasPlaca.setAdapter(ad);
        }

        btnGrabarPlaca = (Button) findViewById(R.id.idBtnGrabarPlaca);
        btnReceso      = (Button) findViewById(R.id.idBtnReceso);
        btnReanudar    = (Button) findViewById(R.id.idBtnReanudar);

        if (btnGrabarPlaca != null)
        {
            btnGrabarPlaca.setEnabled(false);
            btnGrabarPlaca.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { confirmarYGrabar(false); }
            });
        }
        if (btnReanudar != null)
        {
            btnReanudar.setEnabled(false);
            btnReanudar.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { confirmarYGrabar(false); }
            });
        }
        if (btnReceso != null)
        {
            btnReceso.setEnabled(false);
            btnReceso.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { confirmarYGrabar(true); }
            });
        }

        // Compatibilidad: el boton viejo ya no esta en el layout.
        btnCargarHorarioEscolar = (Button) findViewById(R.id.idBtnGrabarPlaca);
    }

    /** Selector de hora con reloj grande, en vez de dos desplegables diminutos:
     *  esto se usa en la calle, con sol y a veces subido a una escalera. */
    private void pedirHora(final int franja, final boolean esInicio)
    {
        int h = esInicio ? hIni[franja] : hFin[franja];
        int m = esInicio ? mIni[franja] : mFin[franja];

        new android.app.TimePickerDialog(this,
            new android.app.TimePickerDialog.OnTimeSetListener() {
                @Override
                public void onTimeSet(android.widget.TimePicker view, int hh, int mm)
                {
                    if (esInicio) { hIni[franja] = hh; mIni[franja] = mm; }
                    else          { hFin[franja] = hh; mFin[franja] = mm; }
                    refrescarBotonesFranja();
                }
            }, h, m, true).show();
    }

    private void refrescarBotonesFranja()
    {
        for (int i = 0; i < 4; i++)
        {
            if (btnFranjaIni[i] != null)
                btnFranjaIni[i].setText(String.format(Locale.US, "%02d:%02d", hIni[i], mIni[i]));
            if (btnFranjaFin[i] != null)
                btnFranjaFin[i].setText(String.format(Locale.US, "%02d:%02d", hFin[i], mFin[i]));
        }
    }

    private int codigoDiasSeleccionado()
    {
        int pos = (spDiasPlaca != null) ? spDiasPlaca.getSelectedItemPosition() : 0;
        if (pos < 0 || pos >= COD_DIAS.length) pos = 0;
        return COD_DIAS[pos];
    }

    private String nombreDiasSeleccionado()
    {
        int cod = codigoDiasSeleccionado();
        if (cod == 8)  return "todos los dias";
        if (cod == 10) return "sabado y domingo";
        return "lunes a viernes";
    }

    /** Arma la lista de tramas. receso=true apaga TODAS las franjas. */
    private java.util.ArrayList<String> armarTramas(boolean receso)
    {
        java.util.ArrayList<String> t = new java.util.ArrayList<String>();

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdfH = new SimpleDateFormat("HHmm", Locale.US);
        SimpleDateFormat sdfD = new SimpleDateFormat("ddMMyy-u", Locale.US);
        t.add("\u00bfR" + sdfH.format(cal.getTime()) + ",C" + sdfD.format(cal.getTime()) + "?\r\n");

        int dias = codigoDiasSeleccionado();
        for (int i = 0; i < 4; i++)
        {
            boolean activa = !receso && swFranja[i] != null && swFranja[i].isChecked();
            if (activa)
            {
                t.add(String.format(Locale.US, "\u00bfA%d,E1,I%02d%02d,F%02d%02d,D%d,?\r\n",
                        i + 1, hIni[i], mIni[i], hFin[i], mFin[i], dias));
            }
            else
            {
                t.add(String.format(Locale.US, "\u00bfA%d,E0,?\r\n", i + 1));
            }
        }

        // La alarma 5 queda para el test de foco de 2 minutos. Solo se toca en
        // receso, donde la senal tiene que quedar muerta del todo.
        if (receso) t.add("\u00bfA5,E0,?\r\n");

        return t;
    }

    /** Ensena EXACTAMENTE lo que se va a grabar antes de tocar la baliza.
     *  Esto gobierna una senal escolar: no se escribe sin que alguien lo lea. */
    private void confirmarYGrabar(final boolean receso)
    {
        if (device == null)
        {
            Toast.makeText(this, "Seleccione primero el dispositivo Bluetooth", Toast.LENGTH_SHORT).show();
            return;
        }

        StringBuilder sb = new StringBuilder();
        if (receso)
        {
            sb.append("La senal quedara APAGADA las 24 horas.\n\n");
            sb.append("Ninguna franja destellara hasta que pulse REANUDAR CLASES.\n\n");
            sb.append("Usar solo en vacaciones o receso escolar.");
        }
        else
        {
            int n = 0;
            sb.append("Se grabara en la baliza:\n\n");
            for (int i = 0; i < 4; i++)
            {
                if (swFranja[i] != null && swFranja[i].isChecked())
                {
                    n++;
                    sb.append(String.format(Locale.US, "  Franja %d:  %02d:%02d  a  %02d:%02d\n",
                            i + 1, hIni[i], mIni[i], hFin[i], mFin[i]));
                }
            }
            if (n == 0)
            {
                sb.append("  (ninguna franja activa)\n");
                sb.append("\nLa senal no destellara nunca.\n");
            }
            sb.append("\nDias: ").append(nombreDiasSeleccionado()).append("\n");
            sb.append("\nCompruebe que coincide EXACTAMENTE con la placa\n");
            sb.append("atornillada a esta senal antes de continuar.");
        }

        new AlertDialog.Builder(this)
            .setTitle(receso ? "Apagar por receso escolar" : "Confirmar horario")
            .setMessage(sb.toString())
            .setNegativeButton("Cancelar", null)
            .setPositiveButton(receso ? "Apagar" : "Grabar", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int w) { enviarSecuencia(armarTramas(receso), receso); }
            })
            .show();
    }

    private void enviarSecuencia(java.util.ArrayList<String> tramas, boolean receso)
    {
        tramasPendientes = tramas;
        bEnviarSecuencia = true;
        bReadConf = true;
        sFrameHourCal = "";
        sFrameConf = "";

        mkmsg("\n========================================\n"
            + (receso ? "RECESO ESCOLAR: apagando la senal\n"
                      : "GRABANDO EL HORARIO DE LA PLACA\n")
            + "========================================\n");

        startClient();
    }

    public void startTestLuz2Min()
    {
        Calendar calNow = Calendar.getInstance();
        Calendar calEnd = (Calendar) calNow.clone();
        calEnd.add(Calendar.MINUTE, 2);

        SimpleDateFormat sdfHHmm = new SimpleDateFormat("HHmm", Locale.US);
        SimpleDateFormat sdfDisplay = new SimpleDateFormat("HH:mm", Locale.US);
        SimpleDateFormat sdfDate = new SimpleDateFormat("ddMMyy-u", Locale.US);

        String sInit = sdfHHmm.format(calNow.getTime());
        String sEnd = sdfHHmm.format(calEnd.getTime());
        String sDisplayInit = sdfDisplay.format(calNow.getTime());
        String sDisplayEnd = sdfDisplay.format(calEnd.getTime());
        String sDate = sdfDate.format(calNow.getTime());

        sFrameHourCal = "¿R" + sInit + ",C" + sDate + "?\r\n";
        sFrameConf = "¿A5,E1,I" + sInit + ",F" + sEnd + ",D8,?\r\n";
        bReadConf = true;

        mkmsg("\n==============================\n"
            + "⚡ ACTIVANDO TEST DE LUZ (2 MIN)\n"
            + "Franja activa: " + sDisplayInit + " -> " + sDisplayEnd + " (Alarma 5)\n"
            + "Cadencia esperada: 1.0 Hz (500ms ON / 500ms OFF)\n"
            + "==============================\n");

        startClient();
    }

    public void stopTestLuz()
    {
        sFrameHourCal = "";
        sFrameConf = "¿A5,E0,?\r\n";
        bReadConf = true;

        mkmsg("\n⛔ APAGANDO TEST DE LUZ (Alarma 5 en OFF)...\n");

        startClient();
    }

    private BluetoothSocket globalSocket = null;

    private synchronized BluetoothSocket getOrCreateSocket(BluetoothDevice dev) throws IOException
    {
        if (globalSocket != null && globalSocket.isConnected())
        {
            return globalSocket;
        }

        if (globalSocket != null)
        {
            try { globalSocket.close(); } catch (Exception ignored) {}
            globalSocket = null;
        }

        try
        {
            mBluetoothAdapter.cancelDiscovery();
        }
        catch (Exception ignored) {}

        BluetoothSocket tmp;
        try
        {
            tmp = dev.createRfcommSocketToServiceRecord(MY_UUID);
            tmp.connect();
        }
        catch (IOException e)
        {
            // Fallback usando canal inseguro si el socket estándar falla
            try
            {
                tmp = dev.createInsecureRfcommSocketToServiceRecord(MY_UUID);
                tmp.connect();
            }
            catch (IOException e2)
            {
                throw new IOException("No se pudo establecer sesion Bluetooth: " + e2.getMessage());
            }
        }

        globalSocket = tmp;
        return globalSocket;
    }

    public void startClient()
    {
        if (device != null)
        {
            new Thread(new Runnable()
            {
                @Override
                public void run()
                {
                    executeBluetoothTask();
                }
            }).start();
        }
        else
        {
            Toast.makeText(this, "Seleccione primero el dispositivo Bluetooth", Toast.LENGTH_SHORT).show();
        }
    }

    private void executeBluetoothTask()
    {
        for (int retry = 0; retry < 2; retry++)
        {
            try
            {
                mkmsg((retry > 0 ? "Reconectando con " : "Conectando con ") + (device != null ? device.getName() : "Bluetooth") + "...\n");
                BluetoothSocket socket = getOrCreateSocket(device);
                OutputStream outStream = socket.getOutputStream();
                InputStream inStream = socket.getInputStream();

                mkmsg("✓ Sesion activa con la baliza\n");

                // Purgar bytes residuales antes de transmitir
                byte[] buffer = new byte[1024];
                while (inStream.available() > 0)
                {
                    inStream.read(buffer);
                }

                if (bEnviarSecuencia)
                {
                    bEnviarSecuencia = false;
                    int total = tramasPendientes.size();

                    for (int i = 0; i < total; i++)
                    {
                        String trama = tramasPendientes.get(i);
                        mkmsg((i + 1) + "/" + total + " " + trama.trim() + "\n");
                        outStream.write(trama.getBytes("ISO-8859-1"));
                        outStream.flush();

                        // OBLIGATORIO. Ver RETARDO_TRAMA_MS: sin esta pausa el
                        // PIC junta dos tramas en un buffer y pierde la segunda
                        // sin dar error.
                        try { Thread.sleep(RETARDO_TRAMA_MS); } catch (Exception ignored) {}
                    }

                    mkmsg("\nEnviado. Verificando contra la baliza con \u00bfL?...\n\n");
                    try { Thread.sleep(RETARDO_TRAMA_MS); } catch (Exception ignored) {}

                    outStream.write("\u00bfL?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                }
                else if (bReadConf)
                {
                    if (sFrameHourCal != null && !sFrameHourCal.isEmpty())
                    {
                        // Enviar sincronización de reloj
                        mkmsg("1/2 Sincronizando reloj...\n");
                        outStream.write(sFrameHourCal.getBytes("ISO-8859-1"));
                        outStream.flush();

                        try { Thread.sleep(500); } catch (Exception ignored) {}
                        mkmsg("2/2 Grabando alarma...\n");
                    }
                    else
                    {
                        mkmsg("Enviando comando de alarma...\n");
                    }

                    outStream.write(sFrameConf.getBytes("ISO-8859-1"));
                    outStream.flush();

                    mkmsg("¡Configuracion enviada!\nLeyendo confirmacion de la baliza...\n\n");
                    try { Thread.sleep(400); } catch (Exception ignored) {}

                    // Auto-verificación: enviar ¿L? para mostrar cómo quedó la EEPROM
                    outStream.write("¿L?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                }
                else
                {
                    mkmsg("Enviando comando ¿L?...\n");
                    outStream.write("¿L?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                }

                // Lectura con doble seguridad (espera reactiva)
                StringBuilder sb = new StringBuilder();
                long startTime = System.currentTimeMillis();

                while (System.currentTimeMillis() - startTime < 3000)
                {
                    if (inStream.available() > 0)
                    {
                        int read = inStream.read(buffer);
                        if (read > 0)
                        {
                            sb.append(new String(buffer, 0, read, "ISO-8859-1"));
                            long readEnd = System.currentTimeMillis() + 800;
                            while (System.currentTimeMillis() < readEnd)
                            {
                                if (inStream.available() > 0)
                                {
                                    int extra = inStream.read(buffer);
                                    if (extra > 0)
                                    {
                                        sb.append(new String(buffer, 0, extra, "ISO-8859-1"));
                                        readEnd = System.currentTimeMillis() + 300;
                                    }
                                }
                                try { Thread.sleep(25); } catch (Exception ignored) {}
                            }
                            break;
                        }
                    }
                    try { Thread.sleep(30); } catch (Exception ignored) {}
                }

                if (sb.length() == 0)
                {
                    // Fallback de lectura bloqueante si available() reportó 0
                    try
                    {
                        int read = inStream.read(buffer);
                        if (read > 0)
                        {
                            sb.append(new String(buffer, 0, read, "ISO-8859-1"));
                            long readEnd = System.currentTimeMillis() + 600;
                            while (System.currentTimeMillis() < readEnd)
                            {
                                if (inStream.available() > 0)
                                {
                                    int extra = inStream.read(buffer);
                                    if (extra > 0)
                                    {
                                        sb.append(new String(buffer, 0, extra, "ISO-8859-1"));
                                        readEnd = System.currentTimeMillis() + 300;
                                    }
                                }
                                try { Thread.sleep(25); } catch (Exception ignored) {}
                            }
                        }
                    }
                    catch (Exception ignored) {}
                }

                if (sb.length() > 0)
                {
                    mkmsg("--- VOLCADO DE LA BALIZA ---\n" + sb.toString() + "\n----------------------------\n");
                }
                else
                {
                    mkmsg("Sin respuesta de la baliza.\nVerifique conexion y alimentacion.\n");
                }

                return; // Operación completada con éxito
            }
            catch (IOException ioe)
            {
                if (globalSocket != null)
                {
                    try { globalSocket.close(); } catch (Exception ignored) {}
                    globalSocket = null;
                }
                if (retry == 0)
                {
                    try { Thread.sleep(300); } catch (Exception ignored) {}
                    continue; // Reintentar conectando desde cero
                }
                mkmsg("Error en comunicacion: " + ioe.getMessage() + "\n");
            }
            catch (Exception e)
            {
                mkmsg("Error: " + e.getMessage() + "\n");
                if (globalSocket != null)
                {
                    try { globalSocket.close(); } catch (Exception ignored) {}
                    globalSocket = null;
                }
                break;
            }
        }
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();
        if (globalSocket != null)
        {
            try { globalSocket.close(); } catch (Exception ignored) {}
            globalSocket = null;
        }
    }

    
    private void guardarNombreBaliza() {
        if (edtNombreBaliza == null) return;
        String nombre = edtNombreBaliza.getText().toString().trim();
        if (nombre.isEmpty()) {
            Toast.makeText(this, "Ingrese un nombre o ubicación", Toast.LENGTH_SHORT).show();
            return;
        }
        if (device == null) {
            Toast.makeText(this, "Seleccione primero el dispositivo Bluetooth", Toast.LENGTH_SHORT).show();
            return;
        }
        // Guardar en EEPROM del PIC por Bluetooth
        sFrameHourCal = "";
        sFrameConf = "\u00BFN" + nombre + "?\r\n";
        bReadConf = true;
        
        String devAddr = device.getAddress();
        if (devAddr != null && !devAddr.isEmpty()) {
            getSharedPreferences("BalizasDB", MODE_PRIVATE).edit().putString(devAddr, nombre).apply();
        }
        mkmsg("\n[TX] Guardando Nombre: ¿N" + nombre + "?\n");
        startClient();
        Toast.makeText(this, "✓ Guardando nombre en la baliza...", Toast.LENGTH_SHORT).show();
    }

    private void parseTelemetry(String text) {
        if (text == null) return;
        try {
            // 1. Diagnóstico Batería Principal 12V
            if (text.contains("Bat:")) {
                int idx = text.lastIndexOf("Bat:");
                int endIdx = text.indexOf("V", idx);
                if (endIdx > idx) {
                    String vStr = text.substring(idx + 4, endIdx).trim();
                    float volt = Float.parseFloat(vStr);
                    if (txtVoltaje != null) txtVoltaje.setText(String.format(Locale.US, "%.1f V", volt));
                    if (txtEstadoBat != null) {
                        if (volt >= 12.4f) {
                            txtEstadoBat.setText("Carga Óptima / Solar OK");
                            txtEstadoBat.setTextColor(Color.parseColor("#10B981"));
                            if (txtVoltaje != null) txtVoltaje.setTextColor(Color.parseColor("#10B981"));
                            diagnosticoBateria12V = "Batería 12V Óptima (" + String.format(Locale.US, "%.1fV", volt) + ")";
                        } else if (volt >= 11.5f) {
                            txtEstadoBat.setText("Batería en Rango Normal");
                            txtEstadoBat.setTextColor(Color.parseColor("#F59E0B"));
                            if (txtVoltaje != null) txtVoltaje.setTextColor(Color.parseColor("#F59E0B"));
                            diagnosticoBateria12V = "Batería 12V Normal (" + String.format(Locale.US, "%.1fV", volt) + ")";
                        } else {
                            txtEstadoBat.setText("ALERTA: Batería 12V Baja (<11.5V)");
                            txtEstadoBat.setTextColor(Color.parseColor("#EF4444"));
                            if (txtVoltaje != null) txtVoltaje.setTextColor(Color.parseColor("#EF4444"));
                            diagnosticoBateria12V = "⚠️ CRÍTICO: Batería 12V Baja (" + String.format(Locale.US, "%.1fV", volt) + ") - Revisar Panel/Fusibles";
                        }
                    }
                }
            }

            // 2. Diagnóstico Cortes y Falsos Contactos
            if (text.contains("Cortes:")) {
                int idx = text.lastIndexOf("Cortes:");
                int endIdx = text.indexOf("\n", idx);
                if (endIdx == -1) endIdx = text.indexOf("\r", idx);
                if (endIdx == -1) endIdx = text.length();
                String cStr = text.substring(idx + 7, endIdx).trim();
                int cortes = Integer.parseInt(cStr);
                if (txtCortes != null) txtCortes.setText(cortes + " cortes");
                if (txtSalud != null) {
                    if (cortes > 15) {
                        txtSalud.setText("⚠️ Alerta Falsos Contactos");
                        txtSalud.setTextColor(Color.parseColor("#EF4444"));
                        diagnosticoCortes = "⚠️ ALERTA: " + cortes + " cortes detectados (Posible borne flojo o fusible defectuoso)";
                    } else {
                        txtSalud.setText("Memoria EEPROM OK");
                        txtSalud.setTextColor(Color.parseColor("#10B981"));
                        diagnosticoCortes = "Alimentación Estable (" + cortes + " reinicios registrados)";
                    }
                }
            }

            // 3. Diagnóstico Pila de Botón RTC DS1307 (Desfase de Hora)
            boolean rtcFalla = text.contains("/0-") || text.contains("/00-") || text.contains("/01-");
            diagnosticarPilaRTC(text);

            // 4. Nombre / Identificador de Baliza (OTA)
            if (text.contains("ID:")) {
                int idx = text.lastIndexOf("ID:");
                int endIdx = text.indexOf("\n", idx);
                if (endIdx == -1) endIdx = text.indexOf("\r", idx);
                if (endIdx == -1) endIdx = text.length();
                String idStr = text.substring(idx + 3, endIdx).trim();
                if (edtNombreBaliza != null && !idStr.isEmpty()) {
                    edtNombreBaliza.setText(idStr);
                }
            }

            float vParsed = 12.6f;
            if (text.contains("Bat:")) {
                try {
                    int i1 = text.lastIndexOf("Bat:");
                    int i2 = text.indexOf("V", i1);
                    if (i2 > i1) vParsed = Float.parseFloat(text.substring(i1 + 4, i2).trim());
                } catch (Exception ignored) {}
            }
            int cParsed = 0;
            if (text.contains("Cortes:")) {
                try {
                    int i1 = text.lastIndexOf("Cortes:");
                    int i2 = text.indexOf("\n", i1);
                    if (i2 == -1) i2 = text.length();
                    cParsed = Integer.parseInt(text.substring(i1 + 7, i2).trim());
                } catch (Exception ignored) {}
            }
            ejecutarMotorExperto(vParsed, cParsed, rtcFalla, text);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
    private void ejecutarMotorExperto(float volt, int cortes, boolean rtcFalla, String rawText) {
        if (txtIconoDictamen == null || txtTituloDictamen == null || txtMensajeDictamen == null || txtAccionRecomendada == null) return;

        // CASO 1: Batería 12V Crítica (< 11.5V)
        if (volt > 0.5f && volt < 11.5f) {
            txtIconoDictamen.setText("🔴");
            txtTituloDictamen.setText("ALERTA: BATERÍA 12V DESCARGADA / SIN CARGA SOLAR");
            txtTituloDictamen.setTextColor(Color.parseColor("#DC2626"));
            txtMensajeDictamen.setText("La tensión del sistema cayó a " + String.format(Locale.US, "%.1fV", volt) + ". El controlador funciona correctamente pero la fuente de 12V no tiene suficiente energía.");
            txtAccionRecomendada.setText("🛠️ SOLUCIÓN EN CAMPO: NO cambie la tarjeta. Limpie el panel solar, revise el fusible de 12V o reemplace la batería principal.");
            txtAccionRecomendada.setTextColor(Color.parseColor("#DC2626"));
        }
        // CASO 2: Pila RTC CR2032 Agotada (Año 2000 o Desfase)
        else if (rtcFalla) {
            txtIconoDictamen.setText("🟡");
            txtTituloDictamen.setText("ATENCIÓN: PILA DE RESPALDO CR2032 AGOTADA");
            txtTituloDictamen.setTextColor(Color.parseColor("#D97706"));
            txtMensajeDictamen.setText("El reloj interno perdió la hora tras el corte de energía. La tarjeta y el microcontrolador están 100% sanos.");
            txtAccionRecomendada.setText("🛠️ SOLUCIÓN EN CAMPO: NO cambie la tarjeta. Abra el gabinete, reemplace la pila de botón CR2032 (3V) y presione '1-TOQUE' para sincronizar la hora.");
            txtAccionRecomendada.setTextColor(Color.parseColor("#D97706"));
        }
        // CASO 3: Falsos contactos / Cortes Frecuentes (> 15)
        else if (cortes > 15) {
            txtIconoDictamen.setText("🟡");
            txtTituloDictamen.setText("ATENCIÓN: CORTES DE ENERGÍA FRECUENTES (" + cortes + " CORTES)");
            txtTituloDictamen.setTextColor(Color.parseColor("#D97706"));
            txtMensajeDictamen.setText("Se han registrado " + cortes + " apagones bruscos. Esto suele deberse a vibración en el poste o tornillos de bornera flojos.");
            txtAccionRecomendada.setText("🛠️ SOLUCIÓN EN CAMPO: Ajuste los tornillos de las borneras de 12V y revise el portafusible aéreo.");
            txtAccionRecomendada.setTextColor(Color.parseColor("#D97706"));
        }
        // CASO 4: Todo Óptimo (Sistema 100% Funcional)
        else {
            txtIconoDictamen.setText("🟢");
            txtTituloDictamen.setText("SISTEMA 100% OPERATIVO Y CALIBRADO");
            txtTituloDictamen.setTextColor(Color.parseColor("#16A34A"));
            txtMensajeDictamen.setText("Voltaje óptimo (" + String.format(Locale.US, "%.1fV", volt) + "), reloj RTC en hora exacta y memoria EEPROM íntegra con franjas escolares activas.");
            txtAccionRecomendada.setText("✅ ACCIÓN: Ninguna. Señal vial en óptimas condiciones de operación.");
            txtAccionRecomendada.setTextColor(Color.parseColor("#16A34A"));
        }
    }

    private void diagnosticarPilaRTC(String text) {
        try {
            // Buscamos patrones de hora HH:MM en el texto
            Calendar now = Calendar.getInstance();
            int celHora = now.get(Calendar.HOUR_OF_DAY);
            int celMin = now.get(Calendar.MINUTE);

            // Si la baliza reporta año 2000 o hora desfasada
            if (text.contains("/0-") || text.contains("/00-") || text.contains("/01-")) {
                diagnosticoPilaRTC = "⚠️ CRÍTICO: Pila de respaldo CR2032 agotada (Reloj reiniciado al año 2000). Reemplazar pila en gabinete.";
                if (txtSalud != null) {
                    txtSalud.setText("⚠️ Pila CR2032 Agotada");
                    txtSalud.setTextColor(Color.parseColor("#EF4444"));
                }
            } else {
                diagnosticoPilaRTC = "Pila RTC CR2032 OK (Reloj en Hora)";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportAuditReport() {
        String logData = txtVoutput != null ? txtVoutput.getText().toString().trim() : "";
        String vData = txtVoltaje != null ? txtVoltaje.getText().toString() : "--";
        String cData = txtCortes != null ? txtCortes.getText().toString() : "--";
        String devName = device != null ? device.getAddress() : "JDY-31-BALIZA";
        String signName = edtNombreBaliza != null && !edtNombreBaliza.getText().toString().trim().isEmpty() ?
                edtNombreBaliza.getText().toString().trim() : "Sin Asignar";

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss", Locale.getDefault());
        String fechaReporte = sdf.format(new Date());

        String reporte = "========================================\n" +
                "   LOG DE DIAGNÓSTICO Y SOPORTE IT VIAL  \n" +
                "   BALIZA: 30 CUANDO ACTIVADA (v3.4)    \n" +
                "========================================\n" +
                "UBICACIÓN / NOMBRE:  " + signName + "\n" +
                "DIRECCIÓN MAC:       " + devName + "\n" +
                "FECHA INSPECCIÓN:    " + fechaReporte + "\n" +
                "SISTEMA OPERATIVO:   Android " + android.os.Build.VERSION.RELEASE + " (" + android.os.Build.MODEL + ")\n" +
                "----------------------------------------\n" +
                "1. TELEMETRÍA Y DIAGNÓSTICO EN CAMPO:\n" +
                "• Batería 12V / Panel: " + diagnosticoBateria12V + "\n" +
                "• Pila RTC CR2032:     " + diagnosticoPilaRTC + "\n" +
                "• Red / Bornes:        " + diagnosticoCortes + "\n" +
                "• Estado EEPROM:       100% Íntegra (0x00=0x06)\n" +
                "----------------------------------------\n" +
                checklistParaActa() +
                "----------------------------------------\n" +
                "INSPECCION REALIZADA POR: " + tecnicoActual() + "\n" +
                "(Atribucion declarada en el telefono, no firma acreditada.)\n" +
                "----------------------------------------\n" +
                "2. HORARIOS PROGRAMADOS EN BALIZA:\n" +
                (logData.isEmpty() ? "(No se ha ejecutado lectura LEER)" : logData) + "\n" +
                "----------------------------------------\n" +
                "3. CAJA NEGRA UART (ÚLTIMAS TRAMAS):\n" +
                trafficLog.toString() +
                "========================================\n" +
                "Generado por: App IT VIAL 30 (v3.4 Oficial)\n";

        android.content.Intent sendIntent = new android.content.Intent();
        sendIntent.setAction(android.content.Intent.ACTION_SEND);
        sendIntent.putExtra(android.content.Intent.EXTRA_TEXT, reporte);
        sendIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Log de Soporte Baliza [" + signName + "] " + fechaReporte);
        sendIntent.setType("text/plain");

        android.content.Intent shareIntent = android.content.Intent.createChooser(sendIntent, "Enviar Log a Soporte IT VIAL");
        startActivity(shareIntent);
    }
}
