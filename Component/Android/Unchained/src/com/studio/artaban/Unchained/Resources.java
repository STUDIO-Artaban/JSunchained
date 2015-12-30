package com.studio.artaban.Unchained;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.studio.artaban.Unchained.Features.Bluetooth;
import com.studio.artaban.Unchained.Features.Feature;
import com.studio.artaban.Unchained.Features.Sensors;
import com.studio.artaban.Unchained.Features.Storage;
import com.studio.artaban.Unchained.Features.Camera;
import com.studio.artaban.Unchained.Interfaces.IActivity;

import android.content.Context;
import android.content.pm.PackageManager;
import android.view.SurfaceView;

final public class Resources implements IActivity {

	static public final String nullString = " "; // Avoid unexplained JNI crash below when return null string after a C++ call (see use & #JNI1):
												 // @@@ ABORTING: INVALID HEAP ADDRESS IN dlfree addr=0x5d79b4a0
												 // Fatal signal 11 (SIGSEGV) at 0xdeadbaad (code=1), thread 21231 (taban.anaglyphcam)
	private List<Feature> mFeatures;
	public Resources(Context context) {

		mFeatures = new ArrayList<Feature>();

		mFeatures.add(new Sensors(context));
		mFeatures.add(new Storage(context));
		mFeatures.add(new Bluetooth(context));
		mFeatures.add(new Camera(context));
	}

	////// Permissions
	static public final String PERMISSION_READ_EXTERNAL_STORAGE = "android.permission.READ_EXTERNAL_STORAGE";
	static public final String PERMISSION_BLUETOOTH = "android.permission.BLUETOOTH";
	static public final String PERMISSION_BLUETOOTH_ADMIN = "android.permission.BLUETOOTH_ADMIN";
	static public final String PERMISSION_CAMERA = "android.permission.CAMERA";

	public static boolean checkPermission(Context context, String permission) {
		return (context.checkCallingOrSelfPermission(permission) == PackageManager.PERMISSION_GRANTED);
	}

	////// Features
	private static short STORAGE_LOC = 1;
	public String getFolder(short type) { return ((Storage)mFeatures.get(STORAGE_LOC)).getFolder(type); }
	public byte[] openAsset(String file) { return ((Storage)mFeatures.get(STORAGE_LOC)).openAsset(file); }
	
	private static short BLUETOOTH_LOC = 2;
    public boolean isBluetooth() { return ((Bluetooth)mFeatures.get(BLUETOOTH_LOC)).isBluetooth(); }
	public void discover() { ((Bluetooth)mFeatures.get(BLUETOOTH_LOC)).discover(); }
	public boolean isDiscovering() { return ((Bluetooth)mFeatures.get(BLUETOOTH_LOC)).isDiscovering(); }
	public String getDevice(short index) { return ((Bluetooth)mFeatures.get(BLUETOOTH_LOC)).getDevice(index); }

	private static short CAMERA_LOC = 3;
	public SurfaceView getCamSurface() { return ((Camera)mFeatures.get(CAMERA_LOC)).getCamSurface(); }
	public void initCamera() { ((Camera)mFeatures.get(CAMERA_LOC)).initCamera(); }
	public boolean isCamStarted() { return ((Camera)mFeatures.get(CAMERA_LOC)).isCamStarted(); }
	public boolean startCamera(short width, short height) { return ((Camera)mFeatures.get(CAMERA_LOC)).startCamera(width, height); }
	public boolean stopCamera() { return ((Camera)mFeatures.get(CAMERA_LOC)).stopCamera(); }

	////// Activity
	@Override public void resume() { for (Iterator<Feature> iter = mFeatures.iterator(); iter.hasNext(); iter.next().resume());	}
	@Override public void pause() {	for (Iterator<Feature> iter = mFeatures.iterator(); iter.hasNext(); iter.next().pause()); }
	@Override public void stop() { for (Iterator<Feature> iter = mFeatures.iterator(); iter.hasNext(); iter.next().stop()); }
	@Override public void destroy() { for (Iterator<Feature> iter = mFeatures.iterator(); iter.hasNext(); iter.next().destroy()); }
}
