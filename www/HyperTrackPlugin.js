var cordova = require('cordova');
var exec = require('cordova/exec');

function HyperTrackPlugin() { 

    // Create new event handler on the window (returns a channel instance)
	this.channel =  cordova.addWindowEventHandler('onHyperTrackStatusChanged');
	this.channel.onHasSubscribersChange = HyperTrackPlugin.onHasSubscribersChange;	
	console.log("HyperTrackPlugin.js: is created");
}

/** Initialize SDK */
HyperTrackPlugin.prototype.initialize = function(publishableKey, success, error) {
	console.log("Initializing with key " + publishableKey);
	exec(success, error, "HyperTrackPlugin", 'initialize', [publishableKey]);
}

/** Enable debug logging */
HyperTrackPlugin.prototype.enableDebugLogging = function(success, error) {
	console.log("enableDebugLogging");
	exec(success, error, "HyperTrackPlugin", 'enableDebugLogging', []);
}

/** Get the device Id */
HyperTrackPlugin.prototype.getDeviceId = function(success, error) {
	console.log("getDeviceId");
	exec(success, error, "HyperTrackPlugin", 'getDeviceId', []);
}

/** Set the device name */
HyperTrackPlugin.prototype.setDeviceName = function(deviceName, success, error) {
	console.log("setDeviceName " + deviceName);
	exec(success, error, "HyperTrackPlugin", 'setDeviceName', [deviceName]);
}

/** Set the device metadata */
HyperTrackPlugin.prototype.setDeviceMetadata = function(deviceMetadata, success, error) {
	const metadataString = JSON.stringify(deviceMetadata);
	console.log("setDeviceMetadata " + metadataString);
	exec(success, error, "HyperTrackPlugin", 'setDeviceMetadata', [metadataString]);
}

/** 
 * Add geotag 
 * 
 * @param {Object} geotagData
 * @param {Object} expectedLocation    keys: latitude, longitude
 */
HyperTrackPlugin.prototype.addGeoTag = function(geotagData, expectedLocation, success, error) {
	const geodataString = JSON.stringify(geotagData);
	const locationString = JSON.stringify(expectedLocation);
	console.log("addGeoTag " + geodataString + ", location " + locationString);
	exec(success, error, "HyperTrackPlugin", 'addGeoTag', [geodataString, locationString]);
}

/** Request permissions if required */
HyperTrackPlugin.prototype.requestPermissionsIfNecessary = function(success, error) {
	console.log("requestPermissionsIfNecessary");
	exec(success, error, "HyperTrackPlugin", 'requestPermissionsIfNecessary', []);
}

/** Allow mock locations for testing */
HyperTrackPlugin.prototype.allowMockLocations = function(success, error) {
	console.log("allowMockLocations");
	exec(success, error, "HyperTrackPlugin", 'allowMockLocations', []);
}

/** Change foreground service notification properties (Android Only) */
HyperTrackPlugin.prototype.setTrackingNotificationProperties = function(title, message, success, error) {
	console.log("setTrackingNotificationProperties " + title + ", " + message);
	exec(success, error, "HyperTrackPlugin", 'setTrackingNotificationProperties', [title, message]);
}

/** Sync device's tracking state with the platform */
HyperTrackPlugin.prototype.syncDeviceSettings = function(success, error) {
	console.log("syncDeviceSettings");
	exec(success, error, "HyperTrackPlugin", 'syncDeviceSettings', []);
}

/** If tracking service is running */
HyperTrackPlugin.prototype.isRunning = function(success, error) {
	console.log("isRunning");
	exec(success, error, "HyperTrackPlugin", 'isRunning', []);
}

/** Event handler for when callbacks get (un)registered for the sdk state. */
HyperTrackPlugin.onHasSubscribersChange = function () {
	// If we just registered the first handler, add tracking state listener.
	  if (this.channel.numHandlers === 1) {
		  exec(hyperTrackPlugin._status, hyperTrackPluginhyperTrackPlugin._error, 'HyperTrackPlugin', 'subscribe', []);
	  } else if (this.channel.numHandlers === 0) {
		  exec(null, null, 'HyperTrackPlugin', 'unsubscribe', []);
	  }
  };

/**
 * Callback for the HyperTrack sdk state changes
 *
 * @param {Object} state            keys: event, error
 */
HyperTrackPlugin.prototype._status = function (state) {

    if (info) {
        if (hyperTrackPlugin._lastEvent !== state.event || hyperTrackPlugin._lastError !== state.error) {

            cordova.fireWindowEvent('onHyperTrackStatusChanged', state);

            hyperTrackPlugin._lastEvent = state.event;
            hyperTrackPlugin._lastError = state.error;
        }
    }
};

/** Error callback for subscribing to the tracking  state */
HyperTrackPlugin.prototype._error = function (e) {
    console.log('Error attaching listener to HyperTrack SDK: ' + e);
};

// FIRE READY //
exec(function(result){ console.log("HyperTrackPlugin is Ready") }, function(result){ console.log("HyperTrackPlugin initalization ERROR") }, "HyperTrackPlugin",'ready',[]);

var hyperTrackPlugin = new HyperTrackPlugin();
module.exports = hyperTrackPlugin;
