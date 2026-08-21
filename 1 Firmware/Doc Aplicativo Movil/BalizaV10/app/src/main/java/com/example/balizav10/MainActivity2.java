package com.example.balizav10;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
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
        String [] sOptionHour = {"00", "01", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"};
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

                    if(sAlarmD == "Diario")  sAlarmD = "8";
                    else if(sAlarmD == "Lun-Vie") sAlarmD = "9";
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


    public void querypaired()
    {
        Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
        // If there are paired devices
        if (pairedDevices.size() > 0)
        {
            // Loop through paired devices
            //txtVoutput.append("at least 1 paired device\n");

            final BluetoothDevice blueDev[] = new BluetoothDevice[pairedDevices.size()];
            String[] items = new String[blueDev.length];

            int i = 0;
            for (BluetoothDevice devicel : pairedDevices)
            {
                blueDev[i] = devicel;
                items[i] = blueDev[i].getName() + ": " + blueDev[i].getAddress();
                //txtVoutput.append("Dispositivo: " + items[i] + "\n");     //imprime en pantalla los dispositivos
                i++;
            }

            //AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setTitle("Elija el  Bluetooth:");

            builder.setSingleChoiceItems(items, -1, new DialogInterface.OnClickListener()
            {
                public void onClick(DialogInterface dialog, int item)
                {
                    dialog.dismiss();
                    if (item >= 0 && item < blueDev.length) {
                        device = blueDev[item];
                        btnDevice.setText( blueDev[item].getName());

                        //enable bt
                        btnRead.setEnabled(true);
                        btConf.setEnabled(true);

                    }

                }
            });
            AlertDialog alert = builder.create();
            alert.show();
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
            //mkmsg("Client running\n");


            // Always cancel discovery because it will slow down a connection
            mBluetoothAdapter.cancelDiscovery();

            // Make a connection to the BluetoothSocket
            try
            {
                // This is a blocking call and will only return on a
                // successful connection or an exception
                socket.connect();
            }
            catch (IOException e)
            {
                mkmsg("Connect failed\n");
                try
                {
                    socket.close();
                    socket = null;
                }
                catch (IOException e2)
                {
                    mkmsg("unable to close() socket during connection failure: " + e2.getMessage() + "\n");
                    socket = null;
                }
                // Start the service over to restart listening mode
            }

            // If a connection was accepted
            if (socket != null)
            {
                //mkmsg("Enviando el Mensaje...\n\r\n\r");
                //mkmsg("Remote device address: " + socket.getRemoteDevice().getAddress() + "\n");

                String sTramaLeer = "¿L?\n\r";

                OutputStream mmOutStream = null;
                InputStream  mmInStream = null;

                mmBuffer = new byte[1024];
                int numBytes;

                //Note this is copied from the TCPdemo code.
                try
                {
                    PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
                    //mkmsg("Attempting to send message ...\n");

                    //is es se envia una trama de configuracion
                    if(bReadConf)
                    {
                        out.println(sFrameHourCal);        //se envia la trama de config

                        TimeUnit.MILLISECONDS.sleep(3000);

                        out.println(sFrameConf);        //se envia la trama de config

                        out.flush();
                        mkmsg("Mensaje Enviado!!\n\r\n\r");
                        //mkmsg("Message sent...\n");
                    }
                    //si es una trama de lectura
                    else
                    {
                        out.println(sTramaLeer);        //se envia la trama para leer

                        out.flush();
                        //mkmsg("Message sent...\n");

                        mkmsg("Esperando Mensaje ...\n\r\n\r");
                        TimeUnit.MILLISECONDS.sleep(6000);

                        mmInStream = socket.getInputStream();
                        numBytes = mmInStream.read(mmBuffer);
                        String dato = new String(mmBuffer);
                        mkmsg((dato + "\n"));
                    }

                    //mkmsg("We are done, closing connection\n");
                }
                catch (Exception e)
                {
                    mkmsg("Error happened sending/receiving\n");

                }
                finally
                {
                    try
                    {
                        socket.close();
                    }
                    catch (IOException e)
                    {
                        mkmsg("Unable to close socket" + e.getMessage() + "\n");
                    }
                }
            }
            else
            {
                mkmsg("Made connection, but socket is null\n");
            }
           // mkmsg("Client ending \n");
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