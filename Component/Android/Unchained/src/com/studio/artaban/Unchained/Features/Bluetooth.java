package com.studio.artaban.Unchained.Features;

import java.util.ArrayList;
import java.util.Set;

import com.studio.artaban.Unchained.Resources;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

public class Bluetooth extends Feature {

	public Bluetooth(Context context) {
		super(context);

    	mBluetooth = false;
    	if (Resources.checkPermission(context, Resources.PERMISSION_BLUETOOTH))
    		initBluetooth();
	}
	
    private boolean mBluetooth;
	private BluetoothAdapter mAdapter;
	private ArrayList<String> mDevices;
    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {

    	@Override public void onReceive(Context context, Intent intent) {
            if (BluetoothDevice.ACTION_FOUND.equals(intent.getAction())) {

            	BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                if (device.getBondState() != BluetoothDevice.BOND_BONDED) // Not already paired
                	synchronized (mDevices) { mDevices.add(device.getName() + "\n" + device.getAddress()); }
            }
        }
    };

    public boolean isBluetooth() {

    	if (!Resources.checkPermission(mContext, Resources.PERMISSION_BLUETOOTH)) {
    		Log.e("Unchained.Resources", "ERROR: Missing '" + Resources.PERMISSION_BLUETOOTH + "' permission");
    		return false;
    	}
    	if (!Resources.checkPermission(mContext, Resources.PERMISSION_BLUETOOTH_ADMIN)) {
    		Log.e("Unchained.Resources", "ERROR: Missing '" + Resources.PERMISSION_BLUETOOTH_ADMIN + "' permission");
    		return false;
    	}
    	BluetoothAdapter adapterBT = BluetoothAdapter.getDefaultAdapter();
    	if (adapterBT == null)
    		return false; // Bluetooth not supported

    	return adapterBT.isEnabled();
    }
    private void initBluetooth() {

		if (mBluetooth)
        	return;

    	mAdapter = BluetoothAdapter.getDefaultAdapter();
    	if ((mAdapter != null) && (mAdapter.isEnabled())) {

            mContext.registerReceiver(mReceiver, new IntentFilter(BluetoothDevice.ACTION_FOUND));
            mDevices = new ArrayList<String>();
            Set<BluetoothDevice> devices = mAdapter.getBondedDevices();
            if (devices.size() > 0)
            	for (BluetoothDevice device : devices)
                	mDevices.add(device.getName() + "\n" + device.getAddress());

            mBluetooth = true;
    	}
    }
	public void discover() {

		initBluetooth();
		if (!mBluetooth)
        	return;

		if (mAdapter.isDiscovering())
        	mAdapter.cancelDiscovery();
		mAdapter.startDiscovery();
	}
	public boolean isDiscovering() {

		if (mAdapter == null)
        	return false;
		return mAdapter.isDiscovering();
	}
	public String getDevice(short index) {
		synchronized (mDevices) {

			if ((!mBluetooth) || (index >= mDevices.size()))
	        	return Resources.nullString;		

			return mDevices.get(index);
		}
	}
	
	////// Activity
	@Override public void destroy() {
		
		if (!mBluetooth)
        	return;

		if (mAdapter.isDiscovering())
        	mAdapter.cancelDiscovery();
        mContext.unregisterReceiver(mReceiver);
	}
}
