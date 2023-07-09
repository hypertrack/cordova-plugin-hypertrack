# API Documentation


## Static

### HyperTrack.initialize

Static. Initializes the SDK

```javascript
let hyperTrack = await HyperTrack.initialize(
    'YourPublishableKey',
    {
        loggingEnabled: false,
        allowMockLocations: false,
        requireBackgroundTrackingPermission: false,
    }
)
```

####Parameters

| Name | Type        | Description              |
| --- |-------------|--------------------------|
| publishableKey | String | Your HyperTrack publishable key |
| sdkInitParams | [SdkInitParams](#sdkinitparams) | Init params for the SDK |

#### Returns

HyperTrack object instance

## HyperTrack object

### addGeotag

Adds a geotag

```javascript
let result = await hyperTrack.addGeotag(
    {
        "test_object": {
            "test_key1": "test_value1"
        }
    }
);
```

#### Parameters

| Name | Type        | Description |
| --- |-------------|-------------|
| geotagData | Object | Geotag data |

#### Returns

[Result](#resultsuccess-failure)<[Location](#location), [LocationError](#locationerror)>

### addGeotagWithExpectedLocation

Adds a geotag with expected location

```javascript
let result = await hyperTrack.addGeotagWithExpectedLocation(
    {
        "test_object": {
            "test_key1": "test_value1"
        }
    },
    {
        "latitude": 37.33182,
        "longitude": -122.03118
    }
);
```

#### Parameters

| Name | Type        | Description              |
| --- |-------------|--------------------------|
| geotagData | Object | Geotag data              |
| expectedLocation | [Location](#location) | Expected location object |

#### Returns

[Result](#resultsuccess-failure)<[LocationWithDeviation](#locationwithdeviation), [LocationError](#locationerror)>

### getDeviceId

Returns the device ID

```javascript
let result = await hyperTrack.getDeviceId()
```

### getLocation

Returns the current device location or error if it is not available

```javascript
let result = await hyperTrack.getLocation()
```

#### Returns

[Result](#resultsuccess-failure)<[Location](#location), [LocationError](#locationerror)>

### setAvailability

Sets the availability of the device for the Nearby search

```javascript
hyperTrack.setAvailability(true)
```

#### Parameters

| Name | Type        | Description              |
| --- |-------------|--------------------------|
| isAvailable | Boolean | True when is available or false when unavailable |

### setMetadata

Sets the metadata for the device

```javascript
hyperTrack.setMetadata(
    {
        "test_object": {
            "test_key1": "test_value1"
        }
    }
);
```

#### Parameters

| Name | Type        | Description              |
| --- |-------------|--------------------------|
| metadata | Object | Metadata JSON |

### setName

Sets the name for the device

```javascript
hyperTrack.setName('Test name')
```

#### Parameters

| Name | Type        | Description              |
| --- |-------------|--------------------------|
| name | String | Name |

### isAvailable

Reflects availability of the device for the Nearby search

```javascript
let result = await hyperTrack.isAvailable()
```

#### Returns

Boolean.
True when is available or false when unavailable


### isTracking

Reflects the tracking intent for the device

```javascript
let result = await hyperTrack.isTracking()
```

#### Returns

Boolean. 
Whether the user's movement data is getting tracked or not.

### startTracking

Starts tracking

```javascript
hyperTrack.startTracking()
```

### stopTracking

Stops tracking

```javascript
hyperTrack.stopTracking()
```

### sync

Syncronizes the device state with the HyperTrack servers

```javascript
hyperTrack.sync()
```

## Data types

### SdkInitParams

```javascript
{
    /**
     * Enable debug logging. 
     * Default: false
     */
    loggingEnabled: Boolean,
    
    /**
     * Allow mock locations to pass through and don’t send mock location outage. 
     * Default: false
     */
    allowMockLocations: Boolean,

    /**
     * Require Background location permissions while requiring permissions on Android.
     * Default: false
     */
    requireBackgroundTrackingPermission: Boolean,
}
```

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
    * GPS satellites are not in view.
    */
    gpsSignalLost = 'gpsSignalLost',
    
    /**
    * The user enabled mock location app while mocking locations is prohibited.
    */
    locationMocked = 'locationMocked',
    
    /**
    * The user denied location permissions.
    */
    locationPermissionsDenied = 'locationPermissionsDenied',
    
    /**
    * Can’t start tracking in background with When In Use location permissions.
    * SDK will automatically start tracking when app will return to foreground.
    */
    locationPermissionsInsufficientForBackground = 'locationPermissionsInsufficientForBackground',
    
    /**
    * [iOS only] The user has not chosen whether the app can use location services.
    */
    locationPermissionsNotDetermined = 'locationPermissionsNotDetermined',
    
    /**
    * The user didn’t grant precise location permissions or downgraded permissions to imprecise.
    */
    locationPermissionsReducedAccuracy = 'locationPermissionsReducedAccuracy',
    
    /**
    * [iOS only] The app is in Provisional Always authorization state, which stops sending locations when app is in background.
    */
    locationPermissionsProvisional = 'locationPermissionsProvisional',
    
    /**
    * [iOS only] The app is not authorized to use location services.
    */
    locationPermissionsRestricted = 'locationPermissionsRestricted',
    
    /**
    * The user disabled location services systemwide.
    */
    locationServicesDisabled = 'locationServicesDisabled',
    
    /**
    * [Android only] The device doesn't have location services.
    */
    locationServicesUnavailable = 'locationServicesUnavailable',
    
    /**
    * [iOS only] The user has not chosen whether the app can use motion activity services.
    */
    motionActivityPermissionsNotDetermined = 'motionActivityPermissionsNotDetermined',
    
    /**
    * The user denied motion activity permissions.
    */
    motionActivityPermissionsDenied = 'motionActivityPermissionsDenied',
    
    /**
    * [iOS only] The user has restricted motion activity services.
    */
    motionActivityServicesDisabled = 'motionActivityServicesDisabled',
    
    /**
    * [iOS only] The device doesn't have motion activity services.
    */
    motionActivityServicesUnavailable = 'motionActivityServicesUnavailable',
    
    /**
    * [iOS only] The app is not authorized to use motion activity services.
    */
    motionActivityPermissionsRestricted = 'motionActivityPermissionsRestricted',
    
    /**
    *  [Android only] The user denied notification permissions needed to display persistent notification needed for foreground location tracking.
    */
    invalidPublishableKey = 'invalidPublishableKey',
    
    /**
    * The SDK is not collecting locations because it’s neither tracking nor available.
    */
    blockedFromRunning = 'blockedFromRunning',
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

