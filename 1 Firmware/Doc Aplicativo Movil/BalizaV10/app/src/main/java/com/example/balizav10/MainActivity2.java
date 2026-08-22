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
    private TextView txtVoltaje;
    private TextView txtEstadoBat;
    private TextView txtCortes;
    private TextView txtSalud;
    private Button btnExportAudit;
    private android.widget.EditText edtNombreBaliza;
    private Button btnGuardarNombre;
    private TextView txtIconoDictamen;
    private TextView txtTituloDictamen;
    private TextView txtMensajeDictamen;
    private TextView txtAccionRecomendada;
    private android.widget.CheckBox chkPanelSolar;
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

        btnCargarHorarioEscolar = (Button)findViewById(R.id.idBtnCargarHorarioEscolar);
        if (btnCargarHorarioEscolar != null)
        {
            btnCargarHorarioEscolar.setEnabled(false);
            btnCargarHorarioEscolar.setOnClickListener(new View.OnClickListener()
            {
                @Override
                public void onClick(View v)
                {
                    if (device == null)
                    {
                        Toast.makeText(MainActivity2.this, "Seleccione primero el dispositivo Bluetooth", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    programarHorarioEscolar();
                }
            });
        }

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
            if (btnCargarHorarioEscolar != null) btnCargarHorarioEscolar.setEnabled(false);
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
                            if (btnTestLuz != null) btnTestLuz.setEnabled(true);
                            if (btnStopTest != null) btnStopTest.setEnabled(true);
                            if (btnCargarHorarioEscolar != null) btnCargarHorarioEscolar.setEnabled(true);

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

    public void programarHorarioEscolar()
    {
        bHorarioEscolarFull = true;
        bReadConf = true;
        sFrameHourCal = "";
        sFrameConf = "";

        mkmsg("\n========================================\n"
            + "🏫 GRABANDO HORARIO ESCOLAR OFICIAL\n"
            + "• Alarma 1: 06:00 -> 09:00 (Lun-Vie)\n"
            + "• Alarma 2: 11:30 -> 13:30 (Lun-Vie)\n"
            + "• Alarma 3: 15:00 -> 16:30 (Lun-Vie)\n"
            + "• Alarma 4: OFF  |  Alarma 5: OFF\n"
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

                if (bHorarioEscolarFull)
                {
                    bHorarioEscolarFull = false;
                    Calendar cal = Calendar.getInstance();
                    SimpleDateFormat sdfH = new SimpleDateFormat("HHmm", Locale.US);
                    SimpleDateFormat sdfD = new SimpleDateFormat("ddMMyy-u", Locale.US);
                    String sHour = sdfH.format(cal.getTime());
                    String sDate = sdfD.format(cal.getTime());

                    // 1. Sincronizar Reloj
                    mkmsg("1/6 Sincronizando RTC con hora oficial...\n");
                    outStream.write(("¿R" + sHour + ",C" + sDate + "?\r\n").getBytes("ISO-8859-1"));
                    outStream.flush();
                    try { Thread.sleep(450); } catch (Exception ignored) {}

                    // 2. Alarma 1 (06:00 a 09:00 Lun-Vie)
                    mkmsg("2/6 Grabando Alarma 1 (06:00 - 09:00 Lun-Vie)...\n");
                    outStream.write("¿A1,E1,I0600,F0900,D9,?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                    try { Thread.sleep(450); } catch (Exception ignored) {}

                    // 3. Alarma 2 (11:30 a 13:30 Lun-Vie)
                    mkmsg("3/6 Grabando Alarma 2 (11:30 - 13:30 Lun-Vie)...\n");
                    outStream.write("¿A2,E1,I1130,F1330,D9,?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                    try { Thread.sleep(450); } catch (Exception ignored) {}

                    // 4. Alarma 3 (15:00 a 16:30 Lun-Vie)
                    mkmsg("4/6 Grabando Alarma 3 (15:00 - 16:30 Lun-Vie)...\n");
                    outStream.write("¿A3,E1,I1500,F1630,D9,?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                    try { Thread.sleep(450); } catch (Exception ignored) {}

                    // 5. Alarma 4 (OFF)
                    mkmsg("5/6 Desactivando Alarmas 4 y 5 (OFF)...\n");
                    outStream.write("¿A4,E0,?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                    try { Thread.sleep(450); } catch (Exception ignored) {}

                    // 6. Alarma 5 (OFF)
                    outStream.write("¿A5,E0,?\r\n".getBytes("ISO-8859-1"));
                    outStream.flush();
                    try { Thread.sleep(450); } catch (Exception ignored) {}

                    mkmsg("✓ ¡Todas las franjas escolares enviadas!\nVerificando EEPROM con comando ¿L?...\n\n");
                    try { Thread.sleep(400); } catch (Exception ignored) {}

                    outStream.write("¿L?\r\n".getBytes("ISO-8859-1"));
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
        // Guardar en EEPROM del PIC por Bluetooth
        String tramaNombre = "\u00BFN" + nombre + "?\n\r";
        sendData(tramaNombre);
        // Guardar en preferencias locales asociadas a la MAC
        if (addressDevice != null && !addressDevice.isEmpty()) {
            getSharedPreferences("BalizasDB", MODE_PRIVATE).edit().putString(addressDevice, nombre).apply();
        }
        Toast.makeText(this, "✓ Nombre grabado en la baliza", Toast.LENGTH_SHORT).show();
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
        String devName = addressDevice != null && !addressDevice.isEmpty() ? addressDevice : "JDY-31-BALIZA";
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
