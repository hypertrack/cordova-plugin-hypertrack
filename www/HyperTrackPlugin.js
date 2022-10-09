var exec = require("cordova/exec");
var platform = window.cordova.platformId;
var channel = require("cordova/channel");

const sdkHandle = {};

/**
 * Get the device Id.
 *
 * @param {function(string)} success - callback that recieves the deviceId string.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.getDeviceId = function (success, error) {
  console.log("HyperTrack:getDeviceId");
  exec(success, error, "HyperTrackPlugin", "getDeviceId", []);
};

/**
 * Set the device name.
 *
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.setDeviceName = function (deviceName, success, error) {
  console.log("HyperTrack:setDeviceName " + deviceName);
  exec(success, error, "HyperTrackPlugin", "setDeviceName", [deviceName]);
};

/**
 * Set the device metadata
 *
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.setDeviceMetadata = function (deviceMetadata, success, error) {
  const metadataString = JSON.stringify(deviceMetadata);
  console.log("HyperTrack:setDeviceMetadata " + metadataString);
  exec(success, error, "HyperTrackPlugin", "setDeviceMetadata", [
    metadataString,
  ]);
};

/**
 * Add geotag.
 *
 * Adds a geotag, that contains arbitrary key-value data with optional expected location argument.
 *
 * @param {Object} geotagData
 * @param {Object} expectedLocation    keys: latitude, longitude
 * @param {function(Location)} success - success callback that receives a current location object
 * @param {function(error)} errror - error callback is called if current location can't be detemined with reason
 * being one of the following codes:
 * 0 if location permissions are missing
 * 1 if activity permissions are missing
 * 2 if location is disabled
 * 3 if sdk is not tracking (start wasn't called)
 * 4 if the sdk start have been called but the current location wasn't yet determined
 * 5 if no GNSS signal is available
 * 6 if app restart required to enable geolocation.
 */
sdkHandle.addGeoTag = function (geotagData, expectedLocation, success, error) {
  const geodataString = JSON.stringify(geotagData);
  const locationString = JSON.stringify(expectedLocation);
  console.log(
    "HyperTrack:addGeoTag " + geodataString + ", location " + locationString
  );
  exec(success, error, "HyperTrackPlugin", "addGeoTag", [
    geodataString,
    locationString,
  ]);
};

/**
 * Request permissions if required
 *
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.requestPermissionsIfNecessary = function (success, error) {
  console.log("HyperTrack:requestPermissionsIfNecessary");
  exec(success, error, "HyperTrackPlugin", "requestPermissionsIfNecessary", []);
};

/**
 * Allow mock locations for testing
 *
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.allowMockLocations = function (success, error) {
  console.log("HyperTrack:allowMockLocations");
  exec(success, error, "HyperTrackPlugin", "allowMockLocations", []);
};

/**
 * Change foreground service notification properties (Android Only)
 *
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.setTrackingNotificationProperties = function (
  title,
  message,
  success,
  error
) {
  console.log(
    "HyperTrack:setTrackingNotificationProperties " + title + ", " + message
  );
  exec(
    success,
    error,
    "HyperTrackPlugin",
    "setTrackingNotificationProperties",
    [title, message]
  );
};

/**
 * Sync device's tracking state with the platform
 *
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.syncDeviceSettings = function (success, error) {
  console.log("HyperTrack:syncDeviceSettings");
  exec(success, error, "HyperTrackPlugin", "syncDeviceSettings", []);
};

/**
 * If tracking service is running
 *
 *
 * @param {function(number)} success - receives 1 as a callback agrument if sdk tracking service is running and 0 othewise.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.isRunning = function (success, error) {
  console.log("HyperTrack:isRunning");
  const success_cb = function (status) {
    if (typeof success == "function") {
      success(status === 1 ? true : false);
    }
  };
  const error_cb = function (err) {
    if (typeof error == "function") {
      error(err);
    }
  };
  exec(success_cb, error_cb, "HyperTrackPlugin", "isRunning", []);
};

/**
 * Reflects tracking intent.
 *
 *
 * @param {function(number)} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.isTracking = function (success, error) {
  console.log("HyperTrack:isTracking");
  const success_cb = function (status) {
    if (typeof success == "function") {
      success(status === 1 ? true : false);
    }
  };
  const error_cb = function (err) {
    if (typeof error == "function") {
      error(err);
    }
  };
  exec(success_cb, error_cb, "HyperTrackPlugin", "isTracking", []);
};

/**
 * Sets device's availability for nearby search.
 *
 *
 * @param {function()} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.setAvailability = function (isAvailable, success, error) {
  console.log("HyperTrack:setAvailability");
  exec(success, error, "HyperTrackPlugin", "setAvailability", [isAvailable]);
};

/**
 * Resolves device's availability for nearby search.
 *
 * @param {function(string)} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.getAvailability = function (success, error) {
  console.log("HyperTrack:getAvailability");
  exec(success, error, "HyperTrackPlugin", "getAvailability", []);
};

/**
 * Start tracking service
 *
 *
 * @param {function(number)} success - - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.start = function (success, error) {
  console.log("HyperTrack:start");
  exec(success, error, "HyperTrackPlugin", "start", []);
};

/**
 * Stop tracking service
 *
 *
 * @param {function(number)} success - - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.stop = function (success, error) {
  console.log("HyperTrack:stop");
  exec(success, error, "HyperTrackPlugin", "stop", []);
};

/**
 * Allows tracking hypertrack sdk  listener.
 *
 *
 * @param {function(string)} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.trackingStateChange = function (success, error) {
  console.log("HyperTrack:trackingStateChange");
  const success_cb = function (val) {
    if (typeof success == "function") {
      if (val) {
        success(val);
      }
    }
  };
  const error_cb = function (err) {
    if (typeof error == "function") {
      error(err);
    }
  };
  exec(success_cb, error_cb, "HyperTrackPlugin", "trackingStateChange", []);
};

/**
 * Stops tracking hypertrack sdk  listener.
 *
 *
 * @param {function(string)} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.disposeTrackingState = function (success, error) {
  console.log("HyperTrack:disposeTrackingState");
  exec(success, error, "HyperTrackPlugin", "disposeTrackingState", []);
};

/**
 * Allows availability hypertrack sdk listener.
 *
 *
 * @param {function(string)} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.availabilityStateChange = function (success, error) {
  console.log("HyperTrack:availabilityStateChange");
  const success_cb = function (val) {
    if (typeof success == "function") {
      if (val) {
        success(val);
      }
    }
  };
  const error_cb = function (err) {
    if (typeof error == "function") {
      error(err);
    }
  };
  exec(success_cb, error_cb, "HyperTrackPlugin", "availabilityStateChange", []);
};

/**
 * Stops availability hypertrack sdk listener.
 *
 *
 * @param {function(string)} success - success callback.
 * @param {function(error)} errror - error callback.
 */
sdkHandle.disposeAvailabilityState = function (success, error) {
  console.log("HyperTrack:disposeAvailabilityState");
  exec(success, error, "HyperTrackPlugin", "disposeAvailabilityState", []);
};

var hypertrack = {
  /**
   * Enable debug logging.
   *
   * @param {function()} success success callback
   * @param {function(error)} error error callback
   */
  enableDebugLogging: function (success, error) {
    console.log("HyperTrack:enableDebugLogging");
    const success_cb = function () {
      if (typeof success == "function") {
        success();
      }
    };
    const error_cb = function (err) {
      if (typeof error == "function") {
        error(err);
      }
    };
    exec(success_cb, error_cb, "HyperTrackPlugin", "enableDebugLogging", []);
  },

  /**
   * Get the list of blockers that needs to be resolved for reliable tracking.
   *
   * @param {Function} success success callback that retrieves a list of current blockers
   * @param {Function} error error callback
   */
  getBlockers: function (success, error) {
    console.log("HyperTrack:getBlockers");
    const success_cb = function (blockers) {
      console.log("Got blockers lists " + blockers);
      blockers.forEach(
        (blocker) =>
          (blocker.resolve = function (success2, error2) {
            console.log("Resolving blocker " + blocker.code);
            exec(success2, error2, "HyperTrackPlugin", "resolveBlocker", [
              blocker.code,
            ]);
          })
      );
      if (typeof success == "function") {
        success(blockers);
      }
    };
    exec(success_cb, error, "HyperTrackPlugin", "getBlockers", []);
  },

  /**
   * Initialize SDK.
   *
   * @param {string} publishableKey - account specific key from dashboard. https://dahsboard.hypertrack.com/setup
   * @param {function(sdkInstance)} success - success callaback that receives sdkInstance as an argument.
   * @param {function(error)} errror - error callback
   */
  initialize: function (publishableKey, success, error) {
    console.log("HyperTrack:Initializing with key " + publishableKey);
    // wrap callbacks
    const success_cb = function () {
      console.debug("HyperTrack init success cb");
      if (typeof success == "function") {
        success(sdkHandle);
      }
    };
    const error_cb = function (err) {
      console.error("HyperTrack inite error cb");
      if (typeof error == "function") {
        error(err);
      }
    };
    exec(success_cb, error_cb, "HyperTrackPlugin", "initialize", [
      publishableKey,
    ]);
  },
};

module.exports = hypertrack;
