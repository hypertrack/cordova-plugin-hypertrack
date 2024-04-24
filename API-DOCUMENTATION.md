# API Documentation

## HyperTrack object

### addGeotag

Adds a new geotag. Check [Shift tracking](https://hypertrack.com/docs/shift-tracking) doc to learn how to use Order handle and Order status params.

```javascript
const orderHanle = "test_order";
const orderStatus = {
  type: "orderStatusCustom",
  value: "my_order_status",
};
const data = {
  test_object: {
    test_key1: "test_value1",
  },
};

const result = await hyperTrack.addGeotag(orderHanle, orderStatus, data);
```

#### Parameters

| Name        | Type   | Description                 |
| ----------- | ------ | --------------------------- |
| orderHanle  | String | Order handle                |
| orderStatus | Object | [OrderStatus](#orderstatus) |
| geotagData  | Object | Geotag data                 |

#### Returns

[Result](#resultsuccess-failure)<[Location](#location), [LocationError](#locationerror)>

### addGeotagWithExpectedLocation

Adds a new geotag with expected location. Check [Shift tracking](https://hypertrack.com/docs/shift-tracking) doc to learn how to use Order handle and Order status params.

```javascript
const orderHandle = "test_order";
const orderStatus = {
  type: "orderStatusCustom",
  value: "my_order_status",
};
const data = {
  test_object: {
    test_key1: "test_value1",
  },
};
const expectedLocation = {
  latitude: 37.33182,
  longitude: -122.03118,
};

let result = await hyperTrack.addGeotagWithExpectedLocation(
  orderHandle,
  orderStatus,
  data,
  expectedLocation
);
```

#### Parameters

| Name             | Type                  | Description                 |
| ---------------- | --------------------- | --------------------------- |
| orderHanle       | String                | Order handle                |
| orderStatus      | Object                | [OrderStatus](#orderstatus) |
| geotagData       | Object                | Geotag data                 |
| expectedLocation | [Location](#location) | Expected location object    |

#### Returns

[Result](#resultsuccess-failure)<[LocationWithDeviation](#locationwithdeviation), [LocationError](#locationerror)>

### getDeviceId

Returns a string that is used to uniquely identify the device

```javascript
let result = await hyperTrack.getDeviceId();
```

#### Returns

String

### getErrors

Returns a list of errors that blocks SDK from tracking

```javascript
let result = await hyperTrack.getErrors();
```

#### Returns

[[HyperTrackError]](#hypertrackerror)

### getIsAvailable

Reflects availability of the device for the Nearby search

```javascript
let result = await hyperTrack.getIsAvailable();
```

#### Returns

Boolean

### getIsTracking

Reflects the tracking intent for the device

```javascript
let result = await hyperTrack.getIsTracking();
```

#### Returns

Boolean

### getLocation

Reflects the current location of the user or an outage reason

```javascript
let result = await hyperTrack.getLocation();
```

#### Returns

[Result](#resultsuccess-failure)<[Location](#location), [LocationError](#locationerror)>

### getMetadata

Gets the metadata that is set for the device

```javascript
let result = await hyperTrack.getMetadata();
```

#### Returns

Object

### getName

Gets the name that is set for the device

```javascript
let result = await hyperTrack.getName();
```

#### Returns

String

### locate

Requests one-time location update and returns the location once it is available, or error.

Only one locate subscription can be active at a time. If you re-subscribe, the old subscription will be automaticaly removed.

This method will start location tracking if called, and will stop it when the location is received or the subscription is cancelled. If any other tracking intent is present (e.g. isAvailable is set to `true`), the tracking will not be stopped.

```javascript
const subscription = HyperTrack.locate(location => {
    ...
})

// to unsubscribe
subscription.remove()
```

#### Parameters

| Name     | Type     | Description                                                                                                                                                                                         |
| -------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| callback | Function | Callback that will be called when the location is received or an error occurs, the callback param is [Result](#resultsuccess-failure)<[Location](#location), [[HyperTrackError](#hypertrackerror)]> |

### setIsAvailable

Sets the availability of the device for the Nearby search

```javascript
hyperTrack.setIsAvailable(true);
```

#### Parameters

| Name        | Type    | Description                                      |
| ----------- | ------- | ------------------------------------------------ |
| isAvailable | Boolean | True when is available or false when unavailable |

### setIsTracking

Sets the tracking intent for the device

```javascript
hyperTrack.setIsTracking(true);
```

#### Parameters

| Name       | Type    | Description                                                 |
| ---------- | ------- | ----------------------------------------------------------- |
| isTracking | Boolean | Whether the user's movement data is getting tracked or not. |

### setMetadata

Sets the metadata for the device

```javascript
hyperTrack.setMetadata({
  test_object: {
    test_key1: "test_value1",
  },
});
```

#### Parameters

| Name     | Type   | Description   |
| -------- | ------ | ------------- |
| metadata | Object | Metadata JSON |

### setName

Sets the name for the device

```javascript
hyperTrack.setName("Test name");
```

#### Parameters

| Name | Type   | Description |
| ---- | ------ | ----------- |
| name | String | Name        |

## Data types

### Result<Success, Failure>

```
{
  "type": "success",
  "value": Success
}

{
  "type": "failure",
  "value": Failure
}
```

### LocationError

Tracking is not started (adding geotags is not possible)

```
{
  "type": "notRunning
}
```

SDK is not initialized yet (no location data to add geotag)

```
{
    "type": "starting
}
```

There was an outage while getting the location data

```
{
    "type": "hyperTrackError",
    "value": HyperTrackError
}
```

### HyperTrackError

```javascript
enum HyperTrackError {
  /**
   * The SDK was remotely blocked from running.
   */
  blockedFromRunning = 'blockedFromRunning',

  /**
   * The publishable key is invalid.
   */
  invalidPublishableKey = 'invalidPublishableKey',

  /**
   * The user enabled mock location app while mocking locations is prohibited.
   */
  locationMocked = 'location.mocked',

  /**
   * The user disabled location services systemwide.
   */
  locationServicesDisabled = 'location.servicesDisabled',

  /**
   * [Android only] The device doesn't have location services.
   */
  locationServicesUnavailable = 'location.servicesUnavailable',

  /**
   * GPS satellites are not in view.
   */
  locationSignalLost = 'location.signalLost',

  /**
   * [Android only] The SDK wasn't able to start tracking because of the limitations imposed by the OS.
   * The exempt from background execution conditions weren't met.
   * {@link https://developer.android.com/guide/components/foreground-services#background-start-restriction-exemptions}
   */
  noExemptionFromBackgroundStartRestrictions = 'noExemptionFromBackgroundStartRestrictions',

  /**
   * The user denied location permissions.
   */
  permissionsLocationDenied = 'permissions.location.denied',

  /**
   * Can’t start tracking in background with When In Use location permissions.
   * SDK will automatically start tracking when app will return to foreground.
   */
  permissionsLocationInsufficientForBackground = 'permissions.location.insufficientForBackground',

  /**
   * [iOS only] The user has not chosen whether the app can use location services.
   */
  permissionsLocationNotDetermined = 'permissions.location.notDetermined',

  /**
   * [iOS only] The app is in Provisional Always authorization state, which stops sending locations when app is in background.
   */
  permissionsLocationProvisional = 'permissions.location.provisional',

  /**
   * The user didn't grant precise location permissions or downgraded permissions to imprecise.
   */
  permissionsLocationReducedAccuracy = 'permissions.location.reducedAccuracy',

  /**
   * [iOS only] The app is not authorized to use location services.
   */
  permissionsLocationRestricted = 'permissions.location.restricted',

  /**
   * [Android only] The user denied notification permissions needed to display a persistent notification
   * needed for foreground location tracking.
   */
  permissionsNotificationsDenied = 'permissions.notifications.denied',
}
```

### Location

```javascript
{
    "latitude": Double,
    "longitude": Double,
}
```

### LocationWithDeviation

```javascript
{
    "location": Location,
    "deviation": Double,
}
```

### OrderStatus

```javascript
{
    "type": "orderStatusClockIn"
}

{
    "type": "orderStatusClockOut"
}

{
    "type": "orderStatusCustom",
    "value": String
}
```
