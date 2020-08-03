var cordova = require('cordova');
var exec = require('cordova/exec');

const sdkHandle = { }

/** 
 * Get the device Id.
 * 
 * @param {function(string)} success - callback that recieves the deviceId string.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.getDeviceId = function(success, error) {
	console.log("HyperTrack:getDeviceId");
	exec(success, error, "HyperTrackPlugin", 'getDeviceId', []);
}

/** 
 * Set the device name.
 * 
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.setDeviceName = function(deviceName, success, error) {
	console.log("HyperTrack:setDeviceName " + deviceName);
	exec(success, error, "HyperTrackPlugin", 'setDeviceName', [deviceName]);
}

/** 
 * Set the device metadata 
 * 
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.setDeviceMetadata = function(deviceMetadata, success, error) {
	const metadataString = JSON.stringify(deviceMetadata);
	console.log("HyperTrack:setDeviceMetadata " + metadataString);
	exec(success, error, "HyperTrackPlugin", 'setDeviceMetadata', [metadataString]);
}

/** 
 * Add geotag 
 * 
 * @param {Object} geotagData
 * @param {Object} expectedLocation    keys: latitude, longitude
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.addGeoTag = function(geotagData, expectedLocation, success, error) {
	const geodataString = JSON.stringify(geotagData);
	const locationString = JSON.stringify(expectedLocation);
	console.log("HyperTrack:addGeoTag " + geodataString + ", location " + locationString);
	exec(success, error, "HyperTrackPlugin", 'addGeoTag', [geodataString, locationString]);
}

/** 
 * Request permissions if required 
 * 
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.requestPermissionsIfNecessary = function(success, error) {
	console.log("HyperTrack:requestPermissionsIfNecessary");
	exec(success, error, "HyperTrackPlugin", 'requestPermissionsIfNecessary', []);
}

/** 
 * Allow mock locations for testing 
 * 
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.allowMockLocations = function(success, error) {
	console.log("HyperTrack:allowMockLocations");
	exec(success, error, "HyperTrackPlugin", 'allowMockLocations', []);
}

/** 
 * Change foreground service notification properties (Android Only) 
 * 
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.setTrackingNotificationProperties = function(title, message, success, error) {
	console.log("HyperTrack:setTrackingNotificationProperties " + title + ", " + message);
	exec(success, error, "HyperTrackPlugin", 'setTrackingNotificationProperties', [title, message]);
}

/** 
 * Sync device's tracking state with the platform 
 * 
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
 sdkHandle.syncDeviceSettings = function(success, error) {
	console.log("HyperTrack:syncDeviceSettings");
	exec(success, error, "HyperTrackPlugin", 'syncDeviceSettings', []);
}

/** 
 * If tracking service is running 
 * 
 * 
 * @param {function(number)} success - receives 1 as a callback agrument if sdk tracking service is running and 0 othewise.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.isRunning = function(success, error) {
	console.log("HyperTrack:isRunning");
	exec(success, error, "HyperTrackPlugin", 'isRunning', []);
}

/** Event handler for when callbacks get (un)registered for the sdk state. */
sdkHandle.onHasSubscribersChange = function () {
	// If we just registered the first handler, add tracking state listener.
	  if (this.channel.numHandlers === 1) {
		  exec(sdkHandle._status, sdkHandlesdkHandle._error, 'HyperTrackPlugin', 'subscribe', []);
	  } else if (this.channel.numHandlers === 0) {
		  exec(null, null, 'HyperTrackPlugin', 'unsubscribe', []);
	  }
  };

/**
 * Callback for the HyperTrack sdk state changes
 *
 * @param {String} state  one of "start", "stop" or tracking errors.
 */
sdkHandle._status = function (state) {

	// Poison pill guard for android2cordova callback
	if (state === "") return

    if (state) {
        if (sdkHandle._lastEvent !== state.event || sdkHandle._lastError !== state.error) {

            cordova.fireWindowEvent('onHyperTrackStatusChanged', state);

            sdkHandle._lastEvent = state.event;
            sdkHandle._lastError = state.error;
        }
    }
};

/** Error callback for subscribing to the tracking  state */
sdkHandle._error = function (e) {
    console.error('Error attaching listener to HyperTrack SDK: ' + e);
};


var hypertrack = {
    /** 
     * Enable debug logging.
     * 
     * @param {function()} success success callback
     * @param {function(error)} error error callback
     */
    enableDebugLogging: function(success, error) {
        console.log("HyperTrack:enableDebugLogging");
        const success_cb = function() { 
            if (typeof(success) == 'function') { success(); }
        }
        const error_cb = function(err) {
            if (typeof(error) == 'function') { error(err); }
        }
        exec(success_cb, error_cb, "HyperTrackPlugin", 'enableDebugLogging', []);
    },
    /** 
     * Initialize SDK.
     * 
     * @param {string} publishableKey - account specific key from dashboard. https://dahsboard.hypertrack.com/setup
     * @param {function(sdkInstance)} success - success callaback that receives sdkInstance as an argument.
     * @param {function(error)} errror - error callback
     */
    initialize: function(publishableKey, success, error) {
        console.log("HyperTrack:Initializing with key " + publishableKey);

        // Create new event handler on the window (returns a channel instance)
        var channel =  cordova.addWindowEventHandler('onHyperTrackStatusChanged');
        channel.onHasSubscribersChange = sdkHandle.onHasSubscribersChange;	
        console.debug("HyperTrack status channel created");
        sdkHandle.channel = channel;

        // wrap callbacks
        const success_cb = function() {
            console.debug("HyperTrack init success cb");

            if (typeof(success) == 'function') {
                success(sdkHandle);
            }
        };
        const error_cb = function(err) {
            console.error("HyperTrack inite error cb");
            if (typeof(error) == 'function') {
                error(err);
            }
        }
        exec(success_cb, error_cb, "HyperTrackPlugin", 'initialize', [publishableKey]);
    }
}

module.exports = hypertrack;
