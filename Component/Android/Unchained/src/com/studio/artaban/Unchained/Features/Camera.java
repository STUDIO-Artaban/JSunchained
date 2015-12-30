package com.studio.artaban.Unchained.Features;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutionException;

import android.content.Context;
import android.graphics.ImageFormat;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.Size;
import android.os.AsyncTask;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.SurfaceHolder.Callback;

import com.studio.artaban.Unchained.Core;
import com.studio.artaban.Unchained.Resources;

public class Camera extends Feature {

	public Camera(Context context) {
		super(context);

    	mCamera = null;
		mCamSurface = new SurfaceView(context);
        mCamSurface.getHolder().setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
        mCamCallback = new Callback() {

            public void surfaceDestroyed(SurfaceHolder holder) { camSurfaceDestroy(); }
            public void surfaceCreated(SurfaceHolder holder) { camSurfaceCreated(holder); }
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
            	camSurfaceChanged();
            }
        };
        mCamSurface.getHolder().addCallback(mCamCallback);
	}

	private android.hardware.Camera mCamera;
	private final Callback mCamCallback;
	private final SurfaceView mCamSurface;
	public SurfaceView getCamSurface() { return mCamSurface; }

    private boolean mCamStarted;
    private boolean mCamRunning;
    private Size mCamSize;
	public void initCamera() {

        mCamStarted = (mCamera != null);
        mCamRunning = false;
        mCamSize = null;
	}

	private void camSurfaceDestroy() {

        waitCamTaskDone();
        if (Resources.checkPermission(mContext, Resources.PERMISSION_CAMERA))
        	resetCamera();
	}
	private void camSurfaceCreated(SurfaceHolder holder) { mCamTask = (CameraTask)new CameraTask().execute(holder); }
	private void camSurfaceChanged() { waitCamTaskDone(); }

    private boolean openCamera() {

        try { mCamera = android.hardware.Camera.open(); } // Try to open back-facing camera
        catch (RuntimeException e) {
            Log.e("Unchained.Resources", "Failed to open back-facing camera: " + e.getMessage());
            return false;
        }
        if (mCamera == null) {

            Log.w("Unchained.Resources", "Failed to open back-facing camera");
            try { mCamera = android.hardware.Camera.open(0); } // Try to open default camera
            catch (RuntimeException e) {

                Log.e("Unchained.Resources", "Failed to open camera: " + e.getMessage());
                return false;
            }
            if (mCamera == null) {

                Log.e("Unchained.Resources", "Failed to open camera");
                return false;
            }
        }
        return true;
    }
    private class CameraTask extends AsyncTask<SurfaceHolder, Void, Void> {

        @Override protected Void doInBackground(SurfaceHolder... surfaces) {

        	if (!Resources.checkPermission(mContext, Resources.PERMISSION_CAMERA)) {
                Log.e("Unchained.Resources", "Missing camera permission: " + Resources.PERMISSION_CAMERA);
        		return null;
        	}
            if (!openCamera())
                return null;

            Parameters camParams = mCamera.getParameters(); // Let's crash if null

            //camParams.setAntibanding(Parameters.ANTIBANDING_OFF);
            //camParams.setColorEffect(Parameters.EFFECT_NONE);
            //camParams.setFlashMode(Parameters.FLASH_MODE_OFF);
            //camParams.setFocusMode(Parameters.FOCUS_MODE_INFINITY);
            camParams.setPreviewFormat(ImageFormat.NV21);

            mCamera.setParameters(camParams);

            try { mCamera.setPreviewDisplay(surfaces[0]); }
            catch (IOException e) {
                Log.e("Unchained.Resources", "Failed to set preview display holder");
                return null;
            }
            mCamera.setErrorCallback(new android.hardware.Camera.ErrorCallback() {
				@Override public void onError(int error, android.hardware.Camera camera) {
                    Log.e("Unchained.Resources", "Camera error: " + error);
				}
            });

            if (mCamStarted)
                startCamera((short)mCamSize.width, (short)mCamSize.height);
            return null;
        }
    };
    private CameraTask mCamTask;
    private void waitCamTaskDone() {

        if (mCamTask != null) {

            try { mCamTask.get(); }
            catch (InterruptedException e) {
                Log.w("Unchained.Resources", "Camera task has been interrupted");
            }
            catch (ExecutionException e) {
                Log.w("Unchained.Resources", "Camera task has generated an exception");
            }
            mCamTask = null;
        }
    }

    //
    public boolean isCamStarted() { return mCamStarted; }
    public boolean startCamera(short width, short height) {

        if (mCamera == null) {
            Log.e("Unchained.Resources", "Failed to start camera: Camera not ready");
            return false;
        }

        mCamera.setDisplayOrientation(0); // Landscape (width > height)
        if (width < height) {
            Log.e("Unchained.Resources", "Wrong camera preview format requested: Portrait");
            return false;
        }
        Parameters camParams = mCamera.getParameters();
        mCamSize = null;

        List<Size> listPrevSizes = camParams.getSupportedPreviewSizes();
        for (int i = 0; i < listPrevSizes.size(); ++i)
            if ((width == (short)listPrevSizes.get(i).width) && (height == (short)listPrevSizes.get(i).height))
                mCamSize = listPrevSizes.get(i);

        if (mCamSize == null) {
            Log.e("Unchained.Resources", "No supported camera preview size: " + width + "*" + height);
            return false;
        }
        camParams.setPreviewSize(mCamSize.width, mCamSize.height);
        mCamera.setParameters(camParams);
        mCamera.setPreviewCallback(new android.hardware.Camera.PreviewCallback() {

			@Override public void onPreviewFrame(byte[] data, android.hardware.Camera arg1) {
            	Core.camera(data);
			}
        });

        mCamera.startPreview();
        mCamStarted = true;
        mCamRunning = true;
        return true;
    }
    public boolean stopCamera() {

        if (mCamera == null) {
            Log.e("Unchained.Resources", "Failed to stop camera: Camera not ready");
            return false;
        }
        mCamera.stopPreview();
        mCamera.setPreviewCallback(null);
        mCamStarted = false;
        mCamRunning = false;
        return true;
    }
    private boolean resetCamera() {

    	if (mCamera == null)
    		return true;

        try {
            mCamera.setPreviewDisplay(null);
        }
        catch (IOException e) {
            Log.e("Unchained.Resources", "Failed to reset preview display");
            return false;
        }
        mCamera.release();
        mCamera = null;
        return true;
    }
    
    ////// Activity
    @Override public void resume() {
    	
        if (mCamStarted) {

            waitCamTaskDone();
            if ((mCamera != null) && (!mCamRunning))
                startCamera((short)mCamSize.width, (short)mCamSize.height);
        }
    }
    @Override public void pause() {
    	
        if (mCamStarted) {

            waitCamTaskDone();
            if (mCamera != null)
            	stopCamera();
            mCamStarted = true;
        }
    }
	@Override public void destroy() {
        mCamSurface.getHolder().removeCallback(mCamCallback);
    }
}
