package com.studio.artaban.Unchained;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.freedesktop.gstreamer.GStreamer;

import android.app.Activity;
import android.content.Context;
import android.os.AsyncTask;
import android.os.PowerManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

final public class UView extends FrameLayout {

	static private final String HTML_MIME_TYPE = "text/html";
	static private final String HTML_ENCODING = "utf-8";
	static private final String JS_UNCHAINED_URL = "http://code.jsunchained.com/";
	static private final String JS_UNCHAINED_FILE = JS_UNCHAINED_URL + "unchained";

	private class loadUrlRunnable implements Runnable {
		@Override public void run() {
			
			mWebView.loadUrl(mURL);
	    	if (mUrlListener != null)
	    		mUrlListener.onUrlChange(mURL);
		}
	}
	private class Console {
		@SuppressWarnings("unused") public void log(String msg) {
			Log.i("unchainedConsole", msg);
		}
	};
	private String mURL;
	private String mHTML;
	private WebView mWebView;
	final private boolean mOnline;
	private final Resources mResources;
	public UView(Context context, String url, String version) {

		super(context);
		Core.load(context);

        try { // Initialize GStreamer
            GStreamer.init(context);
        }
        catch (Exception e) {
            Log.e("Unchained.UView", e.getMessage());
        }
        final DisplayMetrics metrics = new DisplayMetrics();
        ((Activity)context).getWindowManager().getDefaultDisplay().getMetrics(metrics);
        mResources = new Resources(context);
        Core.init(mResources, metrics.xdpi, metrics.ydpi);

		mResources.initCamera();

        this.addView(mResources.getCamSurface());
        RelativeLayout surfaceLayout = new RelativeLayout(context);
        surfaceLayout.setLayoutParams(new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
        		RelativeLayout.LayoutParams.MATCH_PARENT));
        mWebView = new WebView(context);
        mWebView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
        		ViewGroup.LayoutParams.MATCH_PARENT));
        surfaceLayout.addView(mWebView);
        surfaceLayout.bringToFront();
        this.addView(surfaceLayout);

		//
        mWebView.clearCache(true);
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.addJavascriptInterface(new Console(), "unchainedConsole");
        mWebView.setWebViewClient(new WebViewClient() {
            @Override public boolean shouldOverrideUrlLoading(WebView view, String url) {

            	load(url);
                return true;
            }
        });

		mURL = url;
        mOnline = url.startsWith("assets://");
		int pos = mURL.indexOf('/', mURL.lastIndexOf("//") + 2);
		if (pos < 0)
			mError = Core.start(mURL, version);
		else
			mError = Core.start(mURL.substring(0, pos), version);
		if (mError == ERROR_ID_NONE)
			new UrlRequestTask().execute();

		else {

			Log.e("Unchained.UView", "ERROR: Failed to start 'JSUnchained' core - " + mError);
			mWebView.loadUrl(mURL);
		}
	}
	public void load(String url) {

        mWebView.clearCache(true);
    	mURL = url;

		int pos = mURL.indexOf('/', mURL.lastIndexOf("//") + 2);
		if (pos < 0)
			mError = Core.reset(mURL);
		else
			mError = Core.reset(mURL.substring(0, pos));
        if (mError != ERROR_ID_NONE)
            ((Activity)getContext()).runOnUiThread(new loadUrlRunnable());
        else
        	new UrlRequestTask().execute();
	}

	private class UrlRequestTask extends AsyncTask<Void, Void, Void> {

	    @Override protected Void doInBackground(Void... voids) {
	        HttpClient client = new DefaultHttpClient();
	        HttpResponse response;
	        try {

	            response = client.execute(new HttpGet(mURL));
	            StatusLine line = response.getStatusLine();
	            if (line.getStatusCode() == HttpStatus.SC_OK) {

	            	ByteArrayOutputStream os = new ByteArrayOutputStream();
	                response.getEntity().writeTo(os);
	                mHTML = os.toString();
	                os.close();

	                if (mHTML.indexOf(JS_UNCHAINED_FILE) != -1) {

		                int pos = mHTML.indexOf("<head>") + 6;
		                mHTML = mHTML.substring(0, pos) + "\n<script>\n" +
		                		"window.console.log = function(msg) {\n" +
		                		"    unchainedConsole.log(msg);\n" +
		                		"};\n" +
		                		"window.requestUnchained = function() { };\n" +
		                		"</script>\n" + mHTML.substring(pos);
		                pos = mHTML.indexOf("</body>");
		                if (mOnline)
			                mHTML = mHTML.substring(0, pos) + "\n<script src=\"" + JS_UNCHAINED_URL + Core.key() +
			                		".js\"></script>\n" + mHTML.substring(pos);
		                else {

		                	

		                	
		                	
		                	
		                	
		                	
		                	
		                	
		                	
		                	
		                	
		                	
		                }
	                }
	                while (!Core.ready()) { // Wait core ready

		                try { Thread.sleep(100); }
		                catch (InterruptedException e) {
		        			//Log.e("Unchained.UView", "ERROR: " + e.getMessage());
						}
	                }
	                ((Activity)getContext()).runOnUiThread(new Runnable() {
	        			@Override public void run() {

	        				if (mURL.lastIndexOf('/') == mURL.lastIndexOf("//") + 1)
		        				mWebView.loadDataWithBaseURL(mURL, mHTML, HTML_MIME_TYPE, HTML_ENCODING, null);
	        				else
		        				mWebView.loadDataWithBaseURL(mURL.substring(0, mURL.lastIndexOf('/') + 1), mHTML,
		        						HTML_MIME_TYPE, HTML_ENCODING, null);
	        		    	if (mUrlListener != null)
	        		    		mUrlListener.onUrlChange(mURL);
	        			}
	        		});
	            }
	            else {

	    			Log.w("Unchained.UView", "WARNING: URL not found - " + line.getReasonPhrase());
	            	response.getEntity().getContent().close();
	                mError = ERROR_ID_URL_NOT_FOUND;
	            }
	        }
	        catch (ClientProtocolException e) {

    			Log.w("Unchained.UView", "WARNING: Wrong URL protocole - " + e.getMessage());
	        	mError = ERROR_ID_URL_PROTOCOLE;
	        }
	        catch (IOException e) {

    			Log.w("Unchained.UView", "WARNING: Unexpected URL exception - " + e.getMessage());
	        	mError = ERROR_ID_URL_EXECPTION;
	        }
	        if (mError != ERROR_ID_NONE)
                ((Activity)getContext()).runOnUiThread(new loadUrlRunnable());

	        return null;
	    }
	}

	////// OnUrlChangeListener
	private OnUrlChangeListener mUrlListener;
	public interface OnUrlChangeListener {

		public void onUrlChange(String url);
	};
	public void setUrlChangeListener(OnUrlChangeListener listener) { mUrlListener = listener; }

	////// Version
	static public final String VERSION_LAST = Resources.nullString;
	static public final String VERSION_1_0_0 = "1.0.0";

	////// Error
	static public final short ERROR_ID_NONE = 0; // No error
	static public final short ERROR_ID_EMPTY_URL = 1;
	static public final short ERROR_ID_EMPTY_VERSION = 2;
	static public final short ERROR_ID_INTERNAL = 3; // Internal (see below)
	static public final short ERROR_ID_URL_PROTOCOLE = 4;
	static public final short ERROR_ID_URL_NOT_FOUND = 5;
	static public final short ERROR_ID_URL_EXECPTION = 6;

	// Internal
	@SuppressWarnings("unused")	static private final short ERROR_ID_OPEN_SOCKET = 7;

	private short mError;
	public short getError() { return mError; }

	////// Activity
	public void onResume() { mResources.resume(); }
	public void onPause() {

		mResources.pause();
		Core.pause(((Activity)getContext()).isFinishing(),
				((PowerManager)((Activity)getContext()).getSystemService(Context.POWER_SERVICE)).isScreenOn());
	}
	public void onStop() {
		if (((Activity)getContext()).isFinishing())
			Core.stop();
	}
	public void onDestroy() {

		mResources.destroy();
		Core.destroy();
        System.exit(0);
	}
}
