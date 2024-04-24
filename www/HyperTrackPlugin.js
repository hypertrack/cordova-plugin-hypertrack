const exec = require("cordova/exec");

const pluginName = "HyperTrackCordovaPlugin";

const HyperTrack = (function () {
  const staticMethods = {
    /**
     * Adds a new geotag
     *
     * @param {string} orderHandle - Order handle
     * @param {string} orderStatus - Order status
     * @param {Object} data - Geotad data JSON
     * @returns current location if success or LocationError if failure
     */
    addGeotag: async function (orderHandle, orderStatus, geotagMetadata) {
      if (
        typeof orderHandle !== "string" ||
        typeof orderStatus !== "object" ||
        typeof geotagMetadata !== "object"
      ) {
        throw new Error(
          "Invalid arguments, expected: (orderHandle: string, orderStatus: object, geotagMetadata: object)"
        );
      }
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeLocationResult(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "addGeotag", [
          Serialization.serializeGeotagData(
            geotagMetadata,
            undefined,
            orderHandle,
            orderStatus
          ),
        ]);
      });
    },

    /**
     * Adds a new geotag with expected location
     *
     * @param {string} orderHandle - Order handle
     * @param {string} orderStatus - Order status
     * @param {Object} data - Geotad data JSON
     * @param {Location} expectedLocation - Expected location
     * @returns location with deviation if success or LocationError if failure
     */
    addGeotagWithExpectedLocation: async function (
      orderHandle,
      orderStatus,
      geotagData,
      expectedLocation
    ) {
      if (
        typeof orderHandle !== "string" ||
        typeof orderStatus !== "object" ||
        typeof geotagData !== "object" ||
        typeof expectedLocation !== "object"
      ) {
        throw new Error(
          "Invalid arguments, expected: (orderHandle: string, orderStatus: object, geotagData: object, expectedLocation: object)"
        );
      }
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(
            Serialization.deserializeLocationWithDeviationResult(success)
          );
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "addGeotag", [
          Serialization.serializeGeotagData(
            geotagData,
            Serialization.serializeLocation(expectedLocation),
            orderHandle,
            orderStatus
          ),
        ]);
      });
    },

    /**
     * @deprecated
     * Adds a new geotag.
     * This method is deprecated. Use addGeotag with orderHandle and orderStatus instead.
     *
     * @param {Object} data - Geotad data JSON
     * @returns current location if success or LocationError if failure
     */
    addGeotagDeprecated: async function (geotagData) {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeLocationResult(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "addGeotag", [
          Serialization.serializeGeotagData(
            geotagData,
            undefined,
            undefined,
            undefined
          ),
        ]);
      });
    },

    /**
     * @deprecated
     * Adds a new geotag with expected location.
     * This method is deprecated. Use addGeotag with orderHandle and orderStatus instead.
     *
     * @param {Object} data - Geotad data JSON
     * @param {Location} expectedLocation - Expected location
     * @returns location with deviation if success or LocationError if failure
     */
    addGeotagWithExpectedLocationDeprecated: async function (
      geotagData,
      expectedLocation
    ) {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(
            Serialization.deserializeLocationWithDeviationResult(success)
          );
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "addGeotag", [
          Serialization.serializeGeotagData(
            geotagData,
            Serialization.serializeLocation(expectedLocation),
            undefined,
            undefined
          ),
        ]);
      });
    },

    /**
     * Returns a string that is used to uniquely identify the device
     *
     * @returns {string} Device ID
     */
    getDeviceId: async function () {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeDeviceId(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "getDeviceID", []);
      });
    },

    /**
     * Returns a list of errors that blocks SDK from tracking
     *
     * @returns {HyperTrackError[]} List of errors
     */
    getErrors: async function () {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeHyperTrackErrors(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "getErrors", []);
      });
    },

    /**
     * Reflects availability of the device for the Nearby search
     *
     * @returns true when is available or false when unavailable
     */
    getIsAvailable: async function () {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeIsAvailable(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "getIsAvailable", []);
      });
    },

    /**
     * Reflects the tracking intent for the device
     *
     * @returns {boolean} Whether the user's movement data is getting tracked or not.
     */
    getIsTracking: async function () {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeIsTracking(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "getIsTracking", []);
      });
    },

    /**
     * Reflects the current location of the user or an outage reason
     */
    getLocation: async function () {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeLocationResult(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "getLocation", []);
      });
    },

    /**
     * Gets the metadata that is set for the device
     *
     * @returns {Object} Metadata JSON
     */
    getMetadata: async function () {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeMetadata(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "getMetadata", []);
      });
    },

    /**
     * Gets the name that is set for the device
     *
     * @returns {string} Device name
     */
    getName: async function () {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeName(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "getName", []);
      });
    },

    /**
     * Requests one-time location update and returns the location once it is available, or error.
     *
     * Only one locate subscription can be active at a time. If you re-subscribe, the old subscription
     * will be automaticaly removed.
     *
     * This method will start location tracking if called, and will stop it when the location is received or
     * the subscription is cancelled. If any other tracking intent is present (e.g. isAvailable is set to `true`),
     * the tracking will not be stopped.
     *
     * @param callback
     * @returns EmitterSubscription
     * @example ```js
     * const subscription = HyperTrack.locate(location => {
     *  ...
     * })
     *
     * // to unsubscribe
     * subscription.remove()
     * ```
     */
    locate: async function (callback) {
      const onSuccess = function (success) {
        callback(Serialization.deserializeLocateResult(success));
      };
      const onError = function (error) {
        throw Error(error);
      };
      exec(onSuccess, onError, pluginName, "locate", []);
    },

    /**
     * Sets the availability of the device for the Nearby search
     *
     * @param availability true when is available or false when unavailable
     */
    setIsAvailable: function (isAvailable) {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "setIsAvailable",
        [Serialization.serializeIsAvailable(isAvailable)]
      );
    },

    /**
     * Sets the tracking intent for the device
     *
     * @param {boolean} isTracking
     */
    setIsTracking: function (isTracking) {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "setIsTracking",
        [Serialization.serializeIsTracking(isTracking)]
      );
    },

    /**
     * Sets the metadata for the device
     *
     * @param {Object} data - Metadata JSON
     */
    setMetadata: function (metadata) {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "setMetadata",
        [Serialization.serializeMetadata(metadata)]
      );
    },

    /**
     * Sets the name for the device
     *
     * @param {string} name
     */
    setName: function (name) {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "setName",
        [Serialization.serializeName(name)]
      );
    },

    /**
     * Subscribe to tracking errors.
     *
     * Only one subscription can be active at a time.
     * If you re-subscribe, the old subscription will be automaticaly removed.
     *
     * @param listener
     * @returns EmitterSubscription
     * @example
     * ```js
     * const subscription = HyperTrack.subscribeToErrors(errors => {
     *   errors.forEach(error => {
     *     // ... error
     *   })
     * })
     *
     * // later, to stop listening
     * subscription.remove()
     * ```
     */
    subscribeToErrors: function (callback) {
      exec(
        function (success) {
          callback(Serialization.deserializeHyperTrackErrors(success));
        },
        function (error) {
          throw Error(error);
        },
        pluginName,
        "subscribeToErrors",
        []
      );
    },

    /**
     * Subscribe to availability changes.
     *
     * Only one subscription can be active at a time.
     * If you re-subscribe, the old subscription will be automaticaly removed.
     *
     * @param listener
     * @returns EmitterSubscription
     * @example
     * ```js
     * const subscription = HyperTrack.subscribeToIsAvailable(isAvailable => {
     *   if (isAvailable) {
     *     // ... ready to go
     *   }
     * })
     *
     * // later, to stop listening
     * subscription.remove()
     * ```
     */
    subscribeToIsAvailable: function (callback) {
      exec(
        function (success) {
          callback(Serialization.deserializeIsAvailable(success));
        },
        function (error) {
          throw Error(error);
        },
        pluginName,
        "subscribeToIsAvailable",
        []
      );
    },

    /**
     * Subscribe to tracking intent changes.
     *
     * Only one subscription can be active at a time.
     * If you re-subscribe, the old subscription will be automaticaly removed.
     *
     * @param listener
     * @returns EmitterSubscription
     * @example
     * ```js
     * const subscription = HyperTrack.subscribeToIsTracking(isTracking => {
     *   if (isTracking) {
     *     // ... ready to go
     *   }
     * })
     *
     * // later, to stop listening
     * subscription.remove()
     * ```
     */
    subscribeToIsTracking: function (callback) {
      exec(
        function (success) {
          callback(Serialization.deserializeIsTracking(success));
        },
        function (error) {
          throw Error(error);
        },
        pluginName,
        "subscribeToIsTracking",
        []
      );
    },

    /**
     * Subscribe to location changes.
     *
     * Only one subscription can be active at a time.
     * If you re-subscribe, the old subscription will be automaticaly removed.
     *
     * @param listener
     * @returns EmitterSubscription
     * @example
     * ```js
     * const subscription = HyperTrack.subscribeToLocation(location => {
     *   ...
     * })
     *
     * // later, to stop listening
     * subscription.remove()
     * ```
     */
    subscribeToLocation: function (callback) {
      exec(
        function (success) {
          callback(Serialization.deserializeLocationResult(success));
        },
        function (error) {
          throw Error(error);
        },
        pluginName,
        "subscribeToLocation",
        []
      );
    },

    /**
     * Unsubscribe from tracking errors
     */
    unsubscribeFromErrors: function () {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "unsubscribeFromErrors",
        []
      );
    },

    /**
     * Unsubscribe from availability changes
     */
    unsubscribeFromIsAvailable: function () {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "unsubscribeFromIsAvailable",
        []
      );
    },

    /**
     * Unsubscribe from tracking intent changes
     */
    unsubscribeFromIsTracking: function () {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "unsubscribeFromIsTracking",
        []
      );
    },

    /**
     * Unsubscribe from location changes
     */
    unsubscribeFromLocation: function () {
      exec(
        function (_success) {},
        function (error) {
          throw Error(error);
        },
        pluginName,
        "unsubscribeFromLocation",
        []
      );
    },
  };
  return staticMethods;
})();

module.exports = HyperTrack;
