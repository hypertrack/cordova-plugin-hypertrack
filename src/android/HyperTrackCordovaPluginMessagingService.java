package com.hypertrack.sdk.cordova.plugin;

import android.util.Log;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.HashMap;


import com.hypertrack.sdk.HyperTrackMessagingService;
import com.google.firebase.messaging.RemoteMessage;

public class HyperTrackCordovaPluginMessagingService extends HyperTrackMessagingService {
    private static final String TAG = "HyperTrackCordovaPlugin";


    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        Log.d(TAG, "New token: " + token);
        CordovaFcmPluginHandleWrapper.getInstance().sendTokenRefresh(token);
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        if (super.onMessageReceived(remoteMessage.getData())) {
            // message was handled by HyperTrack, skip processing
            return;
        }

        Log.d(TAG, "==> HyperTrackCordovaPluginMessagingService onMessageReceived");

        if (remoteMessage.getNotification() != null) {
            Log.d(TAG, "\tNotification Title: " + remoteMessage.getNotification().getTitle());
            Log.d(TAG, "\tNotification Message: " + remoteMessage.getNotification().getBody());
        }

        Map<String, Object> data = new HashMap<String, Object>();
        data.put("wasTapped", false);

        if (remoteMessage.getNotification() != null) {
            data.put("title", remoteMessage.getNotification().getTitle());
            data.put("body", remoteMessage.getNotification().getBody());
        }

        for (String key : remoteMessage.getData().keySet()) {
            Object value = remoteMessage.getData().get(key);
            Log.d(TAG, "\tKey: " + key + " Value: " + value);
            data.put(key, value);
        }

        Log.d(TAG, "\tNotification Data: " + data.toString());
        CordovaFcmPluginHandleWrapper.getInstance().sendPushPayload(data);
    }

    static class CordovaFcmPluginHandleWrapper {

        private Class<?> mPlugin;

        private CordovaFcmPluginHandleWrapper(Class<?> plugin) {
            mPlugin = plugin;
        }

        static CordovaFcmPluginHandleWrapper getInstance() {
            try {
                Class<?> plugin = Class.forName("com.gae.scaffolder.plugin.FCMPlugin");
                return new CordovaFcmPluginHandleWrapper(plugin);
            } catch (Throwable t) {
                return new CordovaFcmPluginHandleWrapper(null);
            }
        }

        public void sendTokenRefresh(String newToken) {
            if (mPlugin != null) {
                try {
                    Method sendTokenRefresh = mPlugin.getMethod("sendTokenRefresh", String.class);
                    sendTokenRefresh.invoke(null, newToken);
                } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
                    Log.w(TAG, "Can't pass token to FCM Plugin due to error ", e);
                }
            }
        }

        public void sendPushPayload(Map<String, Object> payload) {
            if (mPlugin != null) {
                try {
                    Method sendTokenRefresh = mPlugin.getMethod("sendPushPayload", Map.class);
                    sendTokenRefresh.invoke(null, payload);
                } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
                    Log.w(TAG, "Can't pass payload to FCM Plugin due to error ", e);
                }
            }

        }
    }

}