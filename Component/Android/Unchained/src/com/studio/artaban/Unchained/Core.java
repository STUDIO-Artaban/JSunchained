package com.studio.artaban.Unchained;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.content.Context;
import android.util.Log;

final public class Core {

	static private String UNCHAINED_LIBRARY = "libUnchained.so";
	static private String GSTREAMER_LIBRARY = "libgstreamer_android.so";
	static private void renameLib(Context context, String src, String dest) throws FileNotFoundException, IOException {

		InputStream is = context.getAssets().open(src);
		File lib = new File(context.getFilesDir(), dest);
        OutputStream os = new FileOutputStream(lib);
        byte[] buffer = new byte[1024];
        int len;
        while ((len = is.read(buffer)) > 0)
            os.write(buffer, 0, len);
        os.close();
        is.close();
	}

	static public boolean load(Context context) {

		// Load library
    	try {
    		System.loadLibrary("gstreamer_android");
    		System.loadLibrary("Unchained");
    	}
    	catch (UnsatisfiedLinkError e) {

    		try {
    			renameLib(context, "libUnchained._so", UNCHAINED_LIBRARY);
    			renameLib(context, "libgstreamer_android._so", GSTREAMER_LIBRARY);

		        System.load(context.getFilesDir() + "/" + GSTREAMER_LIBRARY);
		        System.load(context.getFilesDir() + "/" + UNCHAINED_LIBRARY);
			}
    		catch (FileNotFoundException e1) {
	        	Log.e("Unchained.Core", "ERROR: " + e1.getMessage());
				return false;
    		}
			catch (IOException e2) {
	        	Log.e("Unchained.Core", "ERROR: " + e2.getMessage());
				return false;
			}
    	}
		return true;
	}
	static public native void init(Resources res, float xDpi, float yDpi);
	static public native String key();
	static public native boolean ready();
	static public native void permission(short allowed);
	static public native short reset(String url);
	//////

    static public native short start(String url, String version);
    static public native void pause(boolean finishing, boolean lockScreen);
    static public native void stop();
    static public native void destroy();
    // Activity

    static public native void accel(float xRate, float yRate, float zRate);
    // Sensors

    static public native void camera(byte[] data);
    // Camera
}
