let deserializeHyperTrackErrors = function (response) {
  const result = [];
  for (let i = 0; i < response.length; i++) {
    result.push(response[i].value);
  }
  return result;
};

let deserializeLocationErrorErrors = function (response) {
  const deserialized = JSON.parse(JSON.stringify(response));
  deserialized.value.value = deserializeHyperTrackErrors(
    deserialized.value.value
  );
  return deserialized;
};

module.exports = {
  deserializeLocationErrorErrors: deserializeLocationErrorErrors,

  deserializeLocationResult: function (response) {
    if (response.type == "failure" && response.value.type == "errors") {
      return deserializeLocationErrorErrors(response);
    } else {
      return response;
    }
  },

  deserializeLocationWithDeviationResult: function (response) {
    if (response.type == "failure" && response.value.type == "errors") {
      return deserializeLocationErrorErrors(response);
    } else {
      return response;
    }
  },

  deserializeHyperTrackErrors: deserializeHyperTrackErrors,

  deserializeDeviceId: function (response) {
    return response.value;
  },

  deserializeIsAvailable: function (response) {
    return response.value;
  },

  deserializeIsTracking: function (response) {
    return response.value;
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

  serializeDeviceName: function (value) {
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
