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
    private ConnectAsyncTask connectAsyncTask;

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
    public String sFrameHourCal = "";
    public String sFrameConf = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);

        // poner incono  al lado del acction bar ***
        getSupportActionBar().setDisplayShowHomeEnabled(true);
        getSupportActionBar().setIcon(R.mipmap.ic_launcher);
        //******************************************

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

                //*** rutina calendar ***
                calendar = Calendar.getInstance();
                simpleDateFormat = new SimpleDateFormat("HHmm ddMMyy-u");
                Date = simpleDateFormat.format(calendar.getTime());


                char bufferHour[] = new  char[6];
                char bufferCalen[] = new char [10];


                Date.getChars(0,4, bufferHour, 0);
                Date.getChars(5,13, bufferCalen, 0);


                sFrameHourCal = "¿R"+ String.valueOf(bufferHour)+",C"+String.valueOf(bufferCalen)+"?\n\r";

                //***************************


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

        //setup the bluetooth adapter.
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        if (mBluetoothAdapter == null)
        {
            // Device does not support Bluetooth
            Toast.makeText(getApplicationContext(),"No Hay Bluetooth",Toast.LENGTH_SHORT).show();
            btnRead.setEnabled(false);
            btnDevice.setEnabled(false);
        }

    }//fin onCreate

     private Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            txtVoutput.append(msg.getData().getString("msg"));
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
                            btnDevice.setText(dName);

                            // habilitar botones de acción
                            btnRead.setEnabled(true);
                            btConf.setEnabled(true);

                            Toast.makeText(MainActivity2.this, "Seleccionado: " + dName, Toast.LENGTH_SHORT).show();
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

    //***** METODO QUE INICIA EL HILO DE PRUEBA DEL BLUETOOTH, ABRIENDO, ENVIANDO EL MENSAJE Y CERRANDO LA CONEXION
    public void startClient()
    {
        if(device != null)
        {
            new Thread(new ConnectThread(device)).start();
        }
    }

    /**
     * This thread runs while attempting to make an outgoing connection
     * with a device. It runs straight through; the connection either
     * succeeds or fails.
     */

    private class ConnectThread extends Thread
    {

        private BluetoothSocket socket;
        private final BluetoothDevice mmDevice;



        public ConnectThread(BluetoothDevice device)
        {
            mmDevice = device;
            BluetoothSocket tmp = null;

            txtVoutput.setText("");
            // Get a BluetoothSocket for a connection with the
            // given BluetoothDevice
            try
            {
                tmp = device.createRfcommSocketToServiceRecord(MainActivity2.MY_UUID);
            }
            catch (IOException e)
            {
                mkmsg("Client connection failed: " + e.getMessage() + "\n");
            }
            socket = tmp;

        }




        public void run()
        {
            if (socket == null)
            {
                mkmsg("Socket Bluetooth nulo. Seleccione el dispositivo de nuevo.\n");
                return;
            }

            try
            {
                mBluetoothAdapter.cancelDiscovery();
            }
            catch (Exception ignored) {}

            try
            {
                mkmsg("Conectando con " + (mmDevice != null ? mmDevice.getName() : "Bluetooth") + "...\n");
                socket.connect();
            }
            catch (IOException e)
            {
                mkmsg("Error al conectar: " + e.getMessage() + "\nVerifique que el modulo este encendido y no ocupado.\n");
                try { socket.close(); } catch (Exception ignored) {}
                return;
            }

            try
            {
                OutputStream outStream = socket.getOutputStream();
                InputStream inStream = socket.getInputStream();

                if (bReadConf)
                {
                    // Enviar sincronización de reloj
                    mkmsg("Enviando fecha y hora...\n");
                    byte[] rawHour = sFrameHourCal.getBytes("ISO-8859-1");
                    outStream.write(rawHour);
                    outStream.flush();

                    try { Thread.sleep(600); } catch (Exception ignored) {}

                    // Enviar configuración de alarma
                    mkmsg("Enviando configuracion de alarma...\n");
                    byte[] rawConf = sFrameConf.getBytes("ISO-8859-1");
                    outStream.write(rawConf);
                    outStream.flush();

                    mkmsg("¡Configuracion enviada con exito a la baliza!\n\n");
                }
                else
                {
                    // Trama de lectura ¿L?\r\n
                    mkmsg("Enviando comando ¿L?...\n");
                    String sTramaLeer = "¿L?\r\n";
                    byte[] rawLeer = sTramaLeer.getBytes("ISO-8859-1");
                    outStream.write(rawLeer);
                    outStream.flush();

                    mkmsg("Esperando respuesta...\n");

                    byte[] buffer = new byte[1024];
                    StringBuilder sb = new StringBuilder();
                    long startTime = System.currentTimeMillis();

                    // Lectura bloqueante inicial (espera hasta 3 segundos por los primeros datos)
                    while (System.currentTimeMillis() - startTime < 3000)
                    {
                        if (inStream.available() > 0)
                        {
                            int read = inStream.read(buffer);
                            if (read > 0)
                            {
                                sb.append(new String(buffer, 0, read, "ISO-8859-1"));
                                // Dar tiempo a que el micro termine de escupir las 5 alarmas
                                long readEnd = System.currentTimeMillis() + 800;
                                while (System.currentTimeMillis() < readEnd)
                                {
                                    if (inStream.available() > 0)
                                    {
                                        int extra = inStream.read(buffer);
                                        if (extra > 0)
                                        {
                                            sb.append(new String(buffer, 0, extra, "ISO-8859-1"));
                                            readEnd = System.currentTimeMillis() + 400;
                                        }
                                    }
                                    try { Thread.sleep(30); } catch (Exception ignored) {}
                                }
                                break;
                            }
                        }
                        try { Thread.sleep(50); } catch (Exception ignored) {}
                    }

                    if (sb.length() > 0)
                    {
                        mkmsg("--- DATOS RECIBIDOS ---\n" + sb.toString() + "\n-----------------------\n");
                    }
                    else
                    {
                        mkmsg("Sin respuesta de la baliza.\nVerifique conexion fisica y alimentacion.\n");
                    }
                }
            }
            catch (Exception e)
            {
                mkmsg("Error en transmision: " + e.getMessage() + "\n");
            }
            finally
            {
                try
                {
                    socket.close();
                }
                catch (Exception ignored) {}
            }
        }


        public void cancel()
        {
            try
            {
                socket.close();
            }
            catch (IOException e)
            {
                mkmsg("close() of connect socket failed: " + e.getMessage() + "\n");
            }
        }

    }//fin class connect thread
    //**************************************************************************************



    //Funcion:Tarea paralela que permitira supervisar la conexion bluethooth a todo momento
    //parametros:Ninguna
    //Retorno:Ninguno
    private class ConnectAsyncTask extends AsyncTask<BluetoothDevice, Integer, BluetoothSocket>
    {

        private BluetoothSocket mmSocket;
        private BluetoothDevice mmDevice;

        @Override
        protected BluetoothSocket doInBackground(BluetoothDevice... device)
        {
            mmDevice = device[0];

            try
            {

                String mmUUID = "00001101-0000-1000-8000-00805F9B34FB";
                mmSocket = mmDevice.createInsecureRfcommSocketToServiceRecord(UUID.fromString(mmUUID));
                mmSocket.connect();

            }
            catch (Exception e)
            {

            }

            return mmSocket;
        }


        @Override
        protected void onPostExecute(BluetoothSocket result)
        {

            btSocket = result;

        }
    }

}//fin main activity2