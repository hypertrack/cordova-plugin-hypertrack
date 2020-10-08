var exec = require('cordova/exec');
var platform = window.cordova.platformId;
var channel = require("cordova/channel");

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

/**
 * Start tracking service
 *
 *
 * @param {function(number)} success - - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.start = function(success, error) {
	console.log("HyperTrack:start");
	exec(success, error, "HyperTrackPlugin", 'start', []);
}

/**
 * Stop tracking service
 *
 *
 * @param {function(number)} success - - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.stop = function(success, error) {
	console.log("HyperTrack:stop");
	exec(success, error, "HyperTrackPlugin", 'stop', []);
}

/* ------------ */
/* Internal API */
/* ------------ */

// Event listeners

/**
 * Event listeners collection.
 *
 * __Supported Platforms__
 *
 * -iOS
 */
var listeners = {};

dispatchEvent = function(event) {
	if (platform === "ios") {
		var result = undefined;
		var functions = listeners[event.type];
		if (functions) {
			for (var i = 0; i < functions.length; i++) {
				result = functions[i](event);
				if (typeof result != "undefined") {
					if (!result) return result;
				}
			}
		}
		return result;
	} else {
		console.log("Not implemented on " + platform + ".");
		return undefined;
	}
};

/**
 * Event channels.
 *
 * __Supported Platforms__
 *
 * -Android
 */
var channel = require("cordova/channel");

var channels = {
  onHyperTrackStatusChanged: channel.create("onHyperTrackStatusChanged"),
  onHyperTrackError: channel.create("onHyperTrackError")
};

/**
 * Retrieves total number of handlers for all available channels.
 *
 * __Supported Platforms__
 *
 * -Android
 */
function numberOfHandlers() {
  return (
    channels.onHyperTrackStatusChanged.numHandlers +
    channels.onHyperTrackError.numHandlers
  );
}

/**
 * Notifies about any changes to collection of event handlers.
 *
 * __Supported Platforms__
 *
 * -Android
 */
function onEventSubscribersChanged() {
  console.log("event subscribers changed");
  // If we just registered the first handler, make sure native listener is started.
  if (this.numHandlers === 1 && numberOfHandlers() === 1) {
    console.log("connecting event channel");
    exec(
      function(info) {
        console.log("Received event", info);
        channels[info.eventType].fire(info.data);
      },
      function() {
        console.log("Error while receiving event.");
      },
      "HyperTrackPlugin",
      "subscribe",
      []
    );
  } else if (numberOfHandlers() === 0) {
    console.log("disconnecting event channel");
    exec(null, null, "HyperTrackPlugin", "unsubscribe", []);
  }
}

for (var key in channels) {
  console.log("subscriber listener for " + key);
  channels[key].onHasSubscribersChange = onEventSubscribersChanged;
}

var hypertrack = {

		/**
		 * Subscribes listener for given event type.
		 *
		 * __Supported Platforms__
		 *
		 * -iOS
		 * -Android
		 */
		addEventListener: function(type, listener) {
		  if (platform === "ios") {
		    var existing = listeners[type];
		    if (!existing) {
		      existing = [];
		      listeners[type] = existing;
		    }
		    existing.push(listener);
		  } else if (platform === "android") {
		    if (type in channels) {
		      channels[type].subscribe(listener);
		    }
		  } else {
		    console.log("Not implemented on " + platform + ".");
		  }
		},

		/**
		 * Unsubscribes listener for given event type.
		 *
		 * __Supported Platforms__
		 *
		 * -iOS
		 * -Android
		 */
		removeEventListener: function(type, listener) {
		  if (platform === "ios") {
		    var existing = listeners[type];
		    if (existing) {
		      var index;
		      while ((index = existing.indexOf(listener)) != -1) {
		        existing.splice(index, 1);
		      }
		    }
		  } else if (platform === "android") {
		    if (type in channels) {
		      channels[type].unsubscribe(listener);
		    }
		  } else {
		    console.log("Not implemented on " + platform + ".");
		  }
		},

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
