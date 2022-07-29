package com.hypertrack.sdk.cordova.plugin;

import android.location.Location;
import android.location.LocationManager;
import android.util.Log;

import androidx.annotation.NonNull;

import com.hypertrack.sdk.AsyncResultReceiver;
import com.hypertrack.sdk.Blocker;
import com.hypertrack.sdk.GeotagResult;
import com.hypertrack.sdk.HyperTrack;
import com.hypertrack.sdk.ServiceNotificationConfig;
import com.hypertrack.sdk.TrackingError;
import com.hypertrack.sdk.TrackingStateObserver;
import com.hypertrack.sdk.logger.HTLogger;
import com.hypertrack.sdk.Result;
import com.hypertrack.sdk.OutageReason;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class HyperTrackPlugin extends CordovaPlugin implements TrackingStateObserver.OnTrackingStateChangeListener {

  private static final String TAG = "HyperTrackPlugin";

  private HyperTrack sdkInstance;
  private CallbackContext statusUpdateCallback;

  @Override
  public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) {

    Log.d(TAG,"HyperTrackPlugin execute: " + action);

    try {
      switch (action) {
        case "initialize":
          if (sdkInstance == null) {
            String publishableKey = args.getString(0);
            sdkInstance = HyperTrack.getInstance(publishableKey);
          }
          callbackContext.success();
          return true;
        case "enableDebugLogging":
          HyperTrack.enableDebugLogging();
          callbackContext.success();
          return true;
        case "getBlockers":
          Set<Blocker> blockers = HyperTrack.getBlockers();
          callbackContext.success(serializeBlockers(blockers));
          return true;
        case "resolveBlocker":
          String blockerCode = args.getString(0);
          resolveBlocker(callbackContext, blockerCode);
          return true;
        case "getDeviceId":
          throwIfNotInitialized();
          String deviceId = sdkInstance.getDeviceID();
          callbackContext.success(deviceId);
          return true;
        case "start":
          throwIfNotInitialized();
          sdkInstance.start();
          callbackContext.success();
          return true;
        case "stop":
          throwIfNotInitialized();
          sdkInstance.stop();
          callbackContext.success();
          return true;
        case "setDeviceName":
          throwIfNotInitialized();
          String deviceName = args.getString(0);
          sdkInstance.setDeviceName(deviceName);
          callbackContext.success();
          return true;
        case "setDeviceMetadata":
          throwIfNotInitialized();
          String deviceMetaJson = args.getString(0);
          JSONObject deviceMetaJsonObject = new JSONObject(deviceMetaJson);
          Map<String, Object> meta = jsonToMap(deviceMetaJsonObject);
          Log.i("setDeviceMetadata", String.valueOf(meta));
          sdkInstance.setDeviceMetadata(meta);
          callbackContext.success();
          return true;
        case "setTrackingNotificationProperties":
          throwIfNotInitialized();
          String title = args.getString(0);
          String body = args.getString(1);
          sdkInstance.setTrackingNotificationConfig(
            new ServiceNotificationConfig.Builder()
              .setContentTitle(title)
              .setContentText(body)
              .build()
          );
          callbackContext.success();
          return true;
        case "addGeoTag":
          throwIfNotInitialized();
          String tagMetaJson = args.getString(0);
          Location expectedLocation = getExpectedLocation(args);
          JSONObject tagMetaJsonObject = new JSONObject(tagMetaJson);
          Map<String, Object> payload = jsonToMap(tagMetaJsonObject);
          GeotagResult result = sdkInstance.addGeotag(payload, expectedLocation);
          if (result instanceof  GeotagResult.Success) {
            HTLogger.d(TAG, "Geotag created successfully " + result);
            callbackContext.success(getLocationJson(result));
          } else {
            HTLogger.w(TAG, "Geotag error:" + result);
            GeotagResult.Error error = (GeotagResult.Error) result;
            callbackContext.error(error.getReason().ordinal());
          }
          return true;
        case "requestPermissionsIfNecessary":
          throwIfNotInitialized();
          sdkInstance.requestPermissionsIfNecessary();
          callbackContext.success();
          return true;
        case "allowMockLocations":
          throwIfNotInitialized();
          sdkInstance.allowMockLocations();
          callbackContext.success();
          return true;
        case "syncDeviceSettings":
          throwIfNotInitialized();
          sdkInstance.syncDeviceSettings();
          callbackContext.success();
          return true;
        case "isRunning":
          throwIfNotInitialized();
          callbackContext.success(sdkInstance.isRunning()?1:0);
          return true;
        case "subscribe":
          throwIfNotInitialized();
          createTrackingStateChannel(callbackContext);
          PluginResult subscriptionResult = new PluginResult(PluginResult.Status.NO_RESULT);
          subscriptionResult.setKeepCallback(true);
          callbackContext.sendPluginResult(subscriptionResult);
          return true;
        case "unsubscribe":
          throwIfNotInitialized();
          disposeTrackingStateChannel();
          PluginResult unsubscribeResult = new PluginResult(PluginResult.Status.NO_RESULT);
          unsubscribeResult.setKeepCallback(true);
          callbackContext.sendPluginResult(unsubscribeResult);
          return true;
        case "getLatestLocation":
          throwIfNotInitialized();
          callbackContext.success(createLocationResult(sdkInstance.getLatestLocation()));
          return true;
        case "getCurrentLocation":
          throwIfNotInitialized();
          sdkInstance.getCurrentLocation(new AsyncResultReceiver<Location, OutageReason>() {
            @Override
            public void onResult(Result<Location, OutageReason> result) {
              callbackContext.success(createLocationResult(result));
            }
          });
          return true;
        default:
          callbackContext.error("Method not found");
          return false;
      }
    } catch(Throwable e) {
      Log.d(TAG, "onPluginAction: " + action + ", ERROR: " + e.getMessage());
      callbackContext.error(e.getMessage());
      return false;
    }

  }

  private void resolveBlocker(CallbackContext callbackContext, String blockerCode) {
    switch (blockerCode) {
      case "OL1": Blocker.LOCATION_PERMISSION_DENIED.resolve();
        callbackContext.success();
        break;
      case "OS1": Blocker.LOCATION_SERVICE_DISABLED.resolve();
        callbackContext.success();
        break;
      case "OA1": Blocker.ACTIVITY_PERMISSION_DENIED.resolve();
        callbackContext.success();
        break;
      case "OL2": Blocker.BACKGROUND_LOCATION_DENIED.resolve();
        callbackContext.success();
        break;
      default:
        callbackContext.error("Unknown blocker code " + blockerCode);
    }
  }

  private void disposeTrackingStateChannel() {
    sdkInstance.removeTrackingListener(this);
    if (statusUpdateCallback != null) {
      PluginResult result = new PluginResult(PluginResult.Status.NO_RESULT, "");
      result.setKeepCallback(false);
      statusUpdateCallback.sendPluginResult(result);
    }
  }

  private void createTrackingStateChannel(CallbackContext callbackContext) {
    statusUpdateCallback = callbackContext;
    sdkInstance.addTrackingListener(this);
  }

  private Location getExpectedLocation(JSONArray args) throws JSONException {
    Log.i("getExpectedLocation", String.valueOf(args));
    if (args.length() < 2) return null;
    Log.i(TAG, "expected location argument " + args.optString(1));
    String coordinates = args.optString(1);
    JSONObject coordinate = new JSONObject(coordinates);
    Double latitude = coordinate.getDouble("latitude");
    Double longitude = coordinate.getDouble("longitude");
    Location expectedLocation = new Location(LocationManager.GPS_PROVIDER);
    expectedLocation.setLatitude(latitude);
    expectedLocation.setLongitude(longitude);
    Log.i(TAG, "getExpectedLocation " + expectedLocation);
    return  expectedLocation;
  }

  private void throwIfNotInitialized() throws IllegalStateException {
    if (sdkInstance == null) throw new IllegalStateException("Sdk wasn't initialized");
  }

  private void sendUpdate(String update) {
    if (statusUpdateCallback!= null) {
      PluginResult result = new PluginResult(PluginResult.Status.OK, update);
      result.setKeepCallback(true);
      statusUpdateCallback.sendPluginResult(result);

    }
  }

  @NonNull
  private JSONArray serializeBlockers(Set<Blocker> blockers) {
    JSONArray result = new JSONArray();
    for (Blocker blocker: blockers) {
      try {
        JSONObject serializedBlocker = new JSONObject();
        serializedBlocker.put("userActionTitle", blocker.userActionTitle);
        serializedBlocker.put("userActionExplanation", blocker.userActionExplanation);
        serializedBlocker.put("userActionCTA", blocker.userActionCTA);
        serializedBlocker.put("code", blocker.code);
        result.put(serializedBlocker);
      } catch (JSONException e) {
        Log.w(TAG, "Got exception serializing blocker.", e);
      }
    }
    return result;
  }

  private JSONObject createLocationResult(Result<Location, OutageReason> locationResult) {
    if(locationResult.isSuccess()) {
      return createLocationSuccessResult(locationResult.getValue());
    } else {
      return createOutageLocationResult(locationResult.getError());
    }
  }

  private JSONObject createLocationSuccessResult(Location location) {
    JSONObject serializedResult = new JSONObject();
    try {
      serializedResult.put("type", "location");
      serializedResult.put(
        "location",
        getLocationJson(location)
      );
    } catch (JSONException e) {
      HTLogger.w(TAG, "Can't serialize Json", e);
    }
    return serializedResult;
  }

  private JSONObject createOutageLocationResult(OutageReason outage) {
    JSONObject serializedResult = new JSONObject();
    try {
      serializedResult.put("type", "outage");
      serializedResult.put("outage", getOutageJson(outage));
    } catch (JSONException e) {
      HTLogger.w(TAG, "Can't serialize Json", e);
    }
    return serializedResult;
  }

  private JSONObject getOutageJson(OutageReason outage) {
    JSONObject json = new JSONObject();
    try {
      json.put("code", outage.ordinal());
      json.put("name", outage.name());
    } catch (JSONException e) {
      HTLogger.w(TAG, "Can't serialize Json", e);
    }
    return json;
  }

  private JSONObject getLocationJson(GeotagResult result) {
    assert result instanceof GeotagResult.Success;
    GeotagResult.Success success = (GeotagResult.Success) result;
    JSONObject json = new JSONObject();
    Location location = success.getDeviceLocation();
    try {
      json.put("latitude", location.getLatitude());
      json.put("longitude", location.getLongitude());
      if (result instanceof GeotagResult.SuccessWithDeviation) {
        GeotagResult.SuccessWithDeviation successWithDeviation = (GeotagResult.SuccessWithDeviation) success;
        json.put("deviation", successWithDeviation.getDeviationDistance());
      }
    } catch (JSONException e) {
      HTLogger.w(TAG, "Can't serialize Json", e);
    }
    return json;
  }

  private JSONObject getLocationJson(Location location) {
    JSONObject json = new JSONObject();
    try {
      json.put("latitude", location.getLatitude());
      json.put("longitude", location.getLongitude());
    } catch (JSONException e) {
      HTLogger.w(TAG, "Can't serialize Json", e);
    }
    return json;
  }

  private Map<String, Object> jsonToMap(JSONObject json) throws JSONException {
    Map<String, Object> retMap = new HashMap<String, Object>();

    if(json != JSONObject.NULL) {
      retMap = toMap(json);
    }
    return retMap;
  }

  private Map<String, Object> toMap(JSONObject object) throws JSONException {
    Map<String, Object> map = new HashMap<String, Object>();

    Iterator<String> keysItr = object.keys();
    while(keysItr.hasNext()) {
      String key = keysItr.next();
      Object value = object.get(key);

      if(value instanceof JSONArray) {
        value = toList((JSONArray) value);
      }

      else if(value instanceof JSONObject) {
        value = toMap((JSONObject) value);
      }
      map.put(key, value);
    }
    return map;
  }

  private List<Object> toList(JSONArray array) throws JSONException {
    List<Object> list = new ArrayList<Object>();
    for(int i = 0; i < array.length(); i++) {
      Object value = array.get(i);
      if(value instanceof JSONArray) {
        value = toList((JSONArray) value);
      }

      else if(value instanceof JSONObject) {
        value = toMap((JSONObject) value);
      }
      list.add(value);
    }
    return list;
  }

  @Override public void onError(TrackingError trackingError) { sendUpdate(trackingError.message); }

  @Override public void onTrackingStart() { sendUpdate("start"); }

  @Override public void onTrackingStop() { sendUpdate("stop"); }

}
