const exec = require("cordova/exec");

const pluginName = "HyperTrackCordovaPlugin";

const HyperTrack = (function () {
  const staticMethods = {
    addGeotag: async function (geotagData) {
      return new Promise(function (resolve, _reject) {
        const onSuccess = function (success) {
          resolve(Serialization.deserializeLocationResult(success));
        };
        const onError = function (error) {
          throw Error(error);
        };
        exec(onSuccess, onError, pluginName, "addGeotag", [
          Serialization.serializeGeotag(geotagData),
        ]);
      });
    },

    addGeotagWithExpectedLocation: async function (
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
          Serialization.serializeGeotag(
            geotagData,
            Serialization.serializeLocation(expectedLocation)
          ),
        ]);
      });
    },

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

    locate: async function (callback) {
      const onSuccess = function (success) {
        callback(Serialization.deserializeLocateResult(success));
      };
      const onError = function (error) {
        throw Error(error);
      };
      exec(onSuccess, onError, pluginName, "locate", []);
    },

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
