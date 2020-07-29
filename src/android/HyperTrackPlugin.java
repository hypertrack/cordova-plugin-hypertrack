package com.hypertrack.sdk.cordova.plugin;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;

import com.hypertrack.sdk.HyperTrack;

public class HyperTrackPlugin extends CordovaPlugin {
 
	private static final String TAG = "HyperTrackPlugin";
	
	private CordovaWebView gWebView;
	private HyperTrack sdkInstance;
	 
	@Override	 
	public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

		Log.d(TAG,"==> HyperTrackPlugin execute: "+ action);
		
		try{
			if (action.equals("initialize")) {
				if (sdkInstance == null) {
					String publishableKey = args.getString(0);
					sdkInstance = HyperTrack.getInstance()
				}
				callbackContext.success();
			} else {
				callbackContext.error("Method not found");
				return false;
			}
			
		}catch(Throwable e){
			Log.d(TAG, "ERROR: onPluginAction: " + e.getMessage());
			callbackContext.error(e.getMessage());
			return false;
		}
		
		//cordova.getThreadPool().execute(new Runnable() {
		//	public void run() {
		//	  //
		//	}
		//});
		
		//cordova.getActivity().runOnUiThread(new Runnable() {
        //    public void run() {
        //      //
        //    }
        //});
		return true;
	}
	
  @Override public void onDestroy() { gWebView = null; }
} 
