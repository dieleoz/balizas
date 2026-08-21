package com.example.balizav10;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.util.Set;

public class MainActivity extends AppCompatActivity {

    BluetoothAdapter mBluetoothAdapter = null;
    private static final int REQUEST_ENABLE_BT = 2;

    private Button btnEntrar;
    private EditText edTxtName;
    private EditText edTxtPass;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // poner incono  al lado del acction bar ***
        getSupportActionBar().setDisplayShowHomeEnabled(true);
        getSupportActionBar().setIcon(R.mipmap.ic_launcher);
        //******************************************

        btnEntrar = (Button)findViewById(R.id.idBtEntrar);
        edTxtName = (EditText)findViewById(R.id. idEditTxName);
        edTxtPass = (EditText)findViewById(R.id.idEditTxtPass);

        startBt();


        //press button ENTRAR
        btnEntrar.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View view)
            {
                changeActivity2(view);
            }
        });

    }//fin onCreate

    public void startBt()
    {
        BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if(mBluetoothAdapter == null)
        {
            Toast.makeText(getApplicationContext(),"Este Dispositivo no soporta Bluetooth",Toast.LENGTH_SHORT).show();
            return;
        }
        if(!mBluetoothAdapter.isEnabled())
        {
            Toast.makeText(getApplicationContext(),"EL Bluetooth esta Apagado",Toast.LENGTH_SHORT).show();
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
             startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }
        else
        {
            Toast.makeText(getApplicationContext(),"EL Bluetooth esta Encendido",Toast.LENGTH_SHORT).show();
            //querypaired();
        }
    }


    public void querypaired()
    {
        //mkmsg("Paired Devices:");
        Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
        // If there are paired devices
        if (pairedDevices.size() > 0)
        {
            // Loop through paired devices
            final BluetoothDevice blueDev[] = new BluetoothDevice[pairedDevices.size()];
            String item;
            int i = 0;
            for (BluetoothDevice devicel : pairedDevices) {
                blueDev[i] = devicel;
                item = blueDev[i].getName() + ": " + blueDev[i].getAddress();
                //mkmsg("Device: " + item);
                i++;
            }

        }
        else
        {
            Toast.makeText(getApplicationContext(),"no hay bluetooth Emparejado",Toast.LENGTH_SHORT).show();
        }
    }

    /*
    //METODO QUE ANALIZA CUANDO SE HA PRENDIDO EL BLUETOOTH
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_ENABLE_BT) {
            //bluetooth result code.
            if (resultCode == Activity.RESULT_OK) {
                Toast.makeText(getApplicationContext(),"El Bluetooth esta Encendido",Toast.LENGTH_SHORT).show();
                querypaired();
            } else {
                Toast.makeText(getApplicationContext(),"Encienda el Bluetooth",Toast.LENGTH_SHORT).show();
            }
        }
    }*/

    public void changeActivity2 (View view)
    {
        String  sName, sPass;

        sName = edTxtName.getText().toString();
        sPass = edTxtPass.getText().toString();

        if(sName.equals("admin"))
        {
            if(sPass.equals("admin"))
            {
                Intent i = new Intent(this, MainActivity2.class);
                startActivity(i);
            }
            else
            {
                Toast.makeText(getApplicationContext(),"Nombre o contraseña Incorrecta!!",Toast.LENGTH_SHORT).show();
            }
        }
        else
        {
            Toast.makeText(getApplicationContext(),"Nombre o contraseña Incorrecta!!",Toast.LENGTH_SHORT).show();
        }

        edTxtName.setText("");
        edTxtPass.setText("");

    }

}//fin main activity