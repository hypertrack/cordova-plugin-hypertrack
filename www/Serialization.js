let deserializeHyperTrackErrors = function (errors) {
  let result = errors.map((error) => {
    if (error.type != "error") {
      throw new Error("Invalid error type");
    }
    return error.value;
  });
  return result;
};

let deserializeLocationError = function (locationError) {
  switch (locationError.type) {
    case "notRunning":
    case "starting":
      return locationError;
    case "errors":
      return {
        type: "errors",
        value: deserializeHyperTrackErrors(locationError.value),
      };
  }
};

module.exports = {
  deserializeDeviceId: function (response) {
    return response.value;
  },

  deserializeHyperTrackErrors: deserializeHyperTrackErrors,

  deserializeIsAvailable: function (response) {
    return response.value;
  },

  deserializeIsTracking: function (response) {
    return response.value;
  },

  deserializeLocateResult: function (response) {
    if (response.type == "success") {
      return {
        type: "success",
        value: response.value.value,
      };
    } else {
      return {
        type: "failure",
        value: deserializeHyperTrackErrors(response.value),
      };
    }
  },

  deserializeLocationResult: function (response) {
    if (response.type == "success") {
      return {
        type: "success",
        value: response.value.value,
      };
    } else {
      return {
        type: "failure",
        value: deserializeLocationError(response.value),
      };
    }
  },

  deserializeLocationWithDeviationResult: function (response) {
    if (response.type == "success") {
      return {
        type: "success",
        value: {
          location: response.value.value.location,
          deviation: response.value.value.deviation,
        },
      };
    } else {
      return {
        type: "failure",
        value: deserializeLocationError(response.value),
      };
    }
  },

  serializeLocation(location) {
    return {
      type: "location",
      value: {
        latitude: location.latitude,
        longitude: location.longitude,
      },
    };
  },

  serializeIsAvailable: function (value) {
    return {
      type: "isAvailable",
      value: value,
    };
  },

  serializeIsTracking: function (value) {
    return {
      type: "isTracking",
      value: value,
    };
  },

  serializeMetadata: function (value) {
    return {
      type: "metadata",
      value: value,
    };
  },

  serializeName: function (value) {
    return {
      type: "deviceName",
      value: value,
    };
  },

  serializeGeotag: function (data, expectedLocation) {
    return {
      data: data,
      expectedLocation: expectedLocation,
    };
  },
};
