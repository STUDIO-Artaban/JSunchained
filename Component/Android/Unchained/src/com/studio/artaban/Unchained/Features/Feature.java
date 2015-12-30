package com.studio.artaban.Unchained.Features;

import com.studio.artaban.Unchained.Interfaces.IActivity;

import android.content.Context;

public class Feature implements IActivity {

	final protected Context mContext;
	public Feature(Context context) {
		mContext = context;
	}

	////// Activity
	@Override public void resume() { }
	@Override public void pause() { }
	@Override public void stop() { }
	@Override public void destroy() { }
}
