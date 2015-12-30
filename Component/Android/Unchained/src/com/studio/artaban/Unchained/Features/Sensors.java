package com.studio.artaban.Unchained.Features;

import com.studio.artaban.Unchained.Core;

import android.app.Activity;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.view.Surface;

public class Sensors extends Feature implements SensorEventListener {

	private final int SENSOR_TYPES = Sensor.TYPE_ACCELEROMETER;

    private SensorManager mSensorMan;
    private Sensor mSensor;

	final private Context mContext;
	public Sensors(Context context) {
		super(context);

		mContext = context;
        mSensorMan = (SensorManager)((Activity)context).getSystemService(Context.SENSOR_SERVICE);
        mSensor = mSensorMan.getDefaultSensor(SENSOR_TYPES);
	}

	////// SensorEventListener
	@Override public void onAccuracyChanged(Sensor arg0, int arg1) { }
	@Override public void onSensorChanged(SensorEvent event) {

        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            switch (((Activity)mContext).getWindowManager().getDefaultDisplay().getRotation()) {

	            case Surface.ROTATION_0: Core.accel(event.values[0], event.values[1], event.values[2]); break;
	            case Surface.ROTATION_90: Core.accel(-event.values[1], event.values[0], event.values[2]); break; 
	            case Surface.ROTATION_270: Core.accel(event.values[1], -event.values[0], event.values[2]); break;
            }
        }
	}
	
	////// Activity
	@Override public void resume() {
		mSensorMan.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_GAME);
	}
	@Override public void pause() {
		mSensorMan.unregisterListener(this);
	}
}
