package com.example.yoursiteapp;

import com.studio.artaban.Unchained.*;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.view.WindowManager;
import android.widget.RelativeLayout;

public class MainActivity extends Activity implements UView.OnUrlChangeListener {

    private final String YOUR_INTERNET_SITE = "http://jsunchained.com/demo.html";
    private final String YOUR_ASSETS_SITE = "assets://demo.html";
    // NOTE: For the demo the site from assets will be used only when Internet connection will be unavailable
	
    private UView mUView;
    
	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

		setContentView(R.layout.activity_main);
        final RelativeLayout mainLayout = (RelativeLayout)findViewById(R.id.mainLayout);

        //////
        final String url;
        if (((ConnectivityManager)getSystemService(CONNECTIVITY_SERVICE)).getActiveNetworkInfo() != null)
        	url = YOUR_INTERNET_SITE;
        else
        	url = YOUR_ASSETS_SITE;

        mUView = new UView(this, url, UView.VERSION_1_0_0);
        mUView.setUrlChangeListener(this);
        mainLayout.addView(mUView);
	}
    @Override
    protected void onResume() {

        super.onResume();
        mUView.onResume();
    }
    @Override
    protected void onPause() {

        super.onResume();
        mUView.onPause();
    }
    @Override
    protected void onStop() {

    	super.onStop();
    	mUView.onStop();
    }
    @Override
    protected void onDestroy() {

    	super.onDestroy();
    	mUView.onDestroy();
    }

	@Override
	public void onUrlChange(String newUrl) {
		// TODO Add behaviour according the new URL

	}
}
