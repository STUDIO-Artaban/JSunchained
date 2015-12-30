package com.studio.artaban.Unchained.Features;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import com.studio.artaban.Unchained.Resources;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

public class Storage extends Feature {

    static private final short FOLDER_TYPE_PICTURES = 0;
    static private final short FOLDER_TYPE_MOVIES = 1;
    static private final short FOLDER_TYPE_APPLICATION = 2;

	final private Context mContext;
	public Storage(Context context) {
		super(context);

		mContext = context;
		mBuffer = new ByteArrayOutputStream();
	}
    
    public String getFolder(short type) {

    	if (!Resources.checkPermission(mContext, Resources.PERMISSION_READ_EXTERNAL_STORAGE)) { 
    		Log.e("Unchained.Resources", "ERROR: Missing '" + Resources.PERMISSION_READ_EXTERNAL_STORAGE + "' permission");
    		return Resources.nullString;
    	}
    	String folder = Resources.nullString;
    	switch (type) {
		case FOLDER_TYPE_PICTURES:
			folder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsoluteFile().getAbsolutePath();
			break;
		case FOLDER_TYPE_MOVIES:
			folder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES).getAbsoluteFile().getAbsolutePath();
			break;
		case FOLDER_TYPE_APPLICATION:
			folder = mContext.getExternalFilesDir(null).getAbsoluteFile().getAbsolutePath();
			break;
    	}
    	return folder;
    }

	private ByteArrayOutputStream mBuffer;
    public byte[] openAsset(String file) {
        try {

            InputStream is = mContext.getAssets().open(file);
            mBuffer.close();
			byte[] data = new byte[4096];
			int read;
			while ((read = is.read(data, 0, data.length)) != -1)
			  mBuffer.write(data, 0, read);

			mBuffer.flush();
            return mBuffer.toByteArray();
        }
        catch (IOException e) {

    		Log.w("Unchained.Resources", "WARNING: No file '" + file + "' in assets (" + e.getMessage() + ")");
        	return null;
        }
    }
}
