# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.2.3] - 2024-05-24

### Changed

- Updated HyperTrack SDK Android to [7.5.5](https://github.com/hypertrack/sdk-android/releases/tag/7.5.5)

## [2.2.2] - 2024-05-14

### Changed

- Updated HyperTrack SDK iOS to [5.5.4](https://github.com/hypertrack/sdk-ios/releases/tag/5.5.4)
- Updated HyperTrack SDK Android to [7.5.4](https://github.com/hypertrack/sdk-android/releases/tag/7.5.4)

## [2.2.1] - 2024-05-03

### Changed

- Updated HyperTrack SDK iOS to [5.5.3](https://github.com/hypertrack/sdk-ios/releases/tag/5.5.3)

## [2.2.0] - 2024-04-23

### Changed

- New `addGeotag` and `addGeotagWithExpectedLocation` methods signature that have `orderHandle` and `orderStatus` parameters. You can use this API when users need to clock in/out of work in your app to honor their work time (see [Clock in/out Tagging](https://hypertrack.com/docs/clock-inout-tracking#add-clock-inout-events-to-a-shift-timeline) guide for more info)
- Updated HyperTrack SDK iOS to [5.5.2](https://github.com/hypertrack/sdk-ios/releases/tag/5.5.2)
- Updated HyperTrack SDK Android to [7.5.3](https://github.com/hypertrack/sdk-android/releases/tag/7.5.3)

## [2.1.2] - 2024-02-28

### Changed

- Updated HyperTrack SDK Android to [7.4.3](https://github.com/hypertrack/sdk-android/releases/tag/7.4.3)

## [2.1.1] - 2024-02-16

### Changed

- Updated HyperTrack SDK iOS to [5.4.1](https://github.com/hypertrack/sdk-ios/releases/tag/5.4.1)
- Updated HyperTrack SDK Android to [7.4.2](https://github.com/hypertrack/sdk-android/releases/tag/7.4.2)

## [2.1.0] - 2024-02-02

### Changed

- Updated HyperTrack SDK iOS to [5.4.0](https://github.com/hypertrack/sdk-ios/releases/tag/5.4.0)
- Updated HyperTrack SDK Android to [7.4.0](https://github.com/hypertrack/sdk-android/releases/tag/7.4.0)

## [2.0.1] - 2023-12-27

### Fixed

- Undefined latitude and longitude in `addGeotagWithExpectedLocation()` response

## [2.0.0] - 2023-11-29

We are excited to announce the release of HyperTrack Cordova SDK 2.0.0, a major update to our location tracking SDK. This release ensures highest tracking performance, reduces deployed app sizes and comes with an improved API to simplify the integrations. We highly recommend upgrading, but please note that there are a few breaking changes. Check the [Migration Guide](https://hypertrack.com/docs/migration-guide).

### Added

- `locate()` to ask for one-time user location
- `subscribeToLocation()` to subscribe to user location updates
- `getErrors()`
- `getName()`
- `getMetadata()`
- HyperTrackError types:
  - `noExemptionFromBackgroundStartRestrictions`
  - `permissionsNotificationsDenied`

### Changed

- Updated HyperTrack SDK Android to [7.0.9](https://github.com/hypertrack/sdk-android/releases/tag/7.0.9)
- Added Android SDK plugins (`location-services-google` and `push-service-firebase`)
- Updated HyperTrack SDK iOS to 5.0.7
- The whole HyperTrack API is now static
- Changed the way to provide publishableKey (you need to add `HyperTrackPublishableKey` `meta-data` item to your `AndroidManifest.xml` and `Info.plist`)
- Renamed HyperTrackError types:
  - `gpsSignalLost` to `locationSignalLost`
  - `locationPermissionsDenied` to `permissionsLocationDenied`
  - `locationPermissionsInsufficientForBackground` to `permissionsLocationInsufficientForBackground`
  - `locationPermissionsNotDetermined` to `permissionsLocationNotDetermined`
  - `locationPermissionsProvisional` to `locationPermissionsProvisional`
  - `locationPermissionsReducedAccuracy` to `permissionsLocationReducedAccuracy`
  - `locationPermissionsRestricted` to `permissionsLocationRestricted`
- Renamed `isAvailable()` to `getIsAvailable()`
- Renamed `isTracking()` to `getIsTracking()`
- Renamed `setAvailability()` to `setIsAvailable(boolean)`
- Changed `startTracking()` and `stopTracking()` to `setIsTracking(boolean)`
- Renamed `subscribeToTracking()` to `subscribeToIsTracking()`
- Renamed `subscribeToAvailability()` to `subscribeToIsAvailable()`
- Renamed `unsubscribeFromTracking()` to `unsubscribeFromIsTracking()`
- Renamed `unsubscribeToAvailability()` to `unsubscribeFromIsAvailable()`

### Removed

- `initialize()` method (the API is now static)
- `SdkInitParams` (the config now should be done with the `AndroidManifest` metadata and `Info.plist`)
- Motion Activity permissions are not required for tracking anymore
- HyperTrackError types:
  - `motionActivityPermissionsDenied`
  - `motionActivityServicesDisabled`
  - `motionActivityServicesUnavailable`
  - `motionActivityPermissionsRestricted`
  - `networkConnectionUnavailable`
- `sync()` method

## [1.1.0] - 2023-07-09

### Added

- `addGeotagWithExpectedLocation()` method
- API Documentation

## [1.0.3] - 2023-06-16

### Changed

- Updated HyperTrack iOS SDK to 4.16.1

## [1.0.2] - 2023-06-15

### Changed

- Updated HyperTrack Android SDK to 6.4.2

## [1.0.1] - 2023-06-01

### Changed

- Updated HyperTrack iOS SDK to 4.16.0

## [1.0.0] - 2023-02-10

### Changed

- Updated HyperTrack Android SDK to 6.4.0
- Updated HyperTrack iOS SDK to 4.14.0
- Plugin exported object renamed from `hypertrack` to `HyperTrack`
- `setDeviceName()` renamed to `setName()`
- `setDeviceMetadata()` renamed to `setMetadata()`
- `addGeoTag()` renamed to `addGeotag()`
- `syncDeviceSettings()` renamed to `sync()`

### Added

- `subscribeToTracking()`
- `subscribeToAvailability()`
- `subscribeToErrors()`
- `unsubscribeFromTracking()`
- `unsubscribeFromAvailability()`
- `unsubscribeFromErrors()`
- `isAvailable()`
- `setAvailability()`
- Location result for `addGeotag`
- `getLocation()`

### Removed

- `getBlockers()`
- `requestPermissionsIfNecessary()`
- `allowMockLocations()` (use `allowMockLocations` param in `initialize()` istead)
- `setTrackingNotificationProperties()`
- `isRunning`

## [0.6.4] - 2022-07-08

### Changed

- Updated Hypertrack Android SDK to [6.2.2](https://github.com/hypertrack/sdk-android/blob/master/CHANGELOG.md#622---2022-08-30)

## [0.6.3] - 2022-07-29

### Changed

- Fix issue with missing com.google.gson dependency

## [0.6.2] - 2022-07-08

### Changed

- Updated Hypertrack iOS SDK to [4.12.3](https://github.com/hypertrack/sdk-ios/blob/master/CHANGELOG.md#4123---2022-06-13)

## [0.6.1] - 2022-07-08

### Changed

- Updated Hypertrack Android SDK to [6.1.4](https://github.com/hypertrack/sdk-android/blob/master/CHANGELOG.md#614---2022-06-17)

## [0.6.0] - 2022-05-04

### Changed

- Updated Hypertrack Android SDK to [6.0.4](https://github.com/hypertrack/sdk-android/blob/master/CHANGELOG.md#604---2022-04-29)

## [0.5.0] - 2022-04-05

### Added

- getLatestLocation and getCurrentLocation methods

## [0.4.2] - 2021-11-11

### Changed

- Updated Hypertrack Android SDK to [5.4.5](https://github.com/hypertrack/sdk-android/releases/tag/v5.4.5)

## [0.4.1] - 2021-08-25

### Changed

- Updated to ue Android SDK v5.4.0

## [0.4.0] - 2021-07-02

### Changed

- Updated to ue Android SDK v5.2.5

## [0.3.0] - 2021-06-09

### Changed

- Updated to ue Android SDK v5.2.0

### Added

- `getBlockers` method that returns a list of issues, that must be resolved for the reliable tracking. E.g. you can block user access to the screen, that enables tracking feature, utill all the blockers are resolved using the following approach:
  ```js
  hypertrack.getBlockers(
      function(blockers) {
          let dialogConfig  = [];
          blockers.forEach(blocker =>
              let menuItem = {
                  title: blocker.userActionTitle,
                  buttonName: blocker.userActionCTA,
                  onClick: function() {blocker.resolve(success, error);},
                  actionExplanation: blocker.userActionExplanation
              };
              dialogConfig.push(menuItem);
          );
          if (dialogConfig.length) showErrorDialog(dialogConfig);
      },
      function(error) {
          console.log("Can't get blockers due to the error: " + error);
      }
  );
  ```

## [0.2.1] - 2021-05-25

### Fixed

- plugin import error fixed

## [0.2.0] - 2021-05-23

### Changed

- Updated to use Android SDK v5.0.0

### Added

- Geotag method returns geotag location or the reason, why it can't be determined

### Removed

- Possibility to restrict the geotag.

## [0.1.1] - 2021-05-07

### Changed

- Updated to use Android SDK v4.12.0

## [0.1.0] - 2021-04-05

### Added

- Possibility to restrict a geotag to a certain location.

### Changed

- Updated to use Android SDK v4.11.0

### Fixed

- Start tracking from SDK on Android 11 won't ask for background location access.

## [0.0.6] - 2020-12-24

### Changed

- Updated to use Android SDK v4.9.0
- Firebase messaging service conflict was fixed.

## [0.0.5] - 2020-11-02

### Changed

- Updated to use Android SDK v4.8.0

## [0.0.4] - 2020-10-22

### Fixed

- Android push token updates and messages are forwarded to [FCM Plugin](https://github.com/andrehtissot/cordova-plugin-fcm-with-dependecy-updated) if it's present in project.

## [0.0.3]

### Fixed

- Expected location in geotags not been passed from JS to Java bug.
- Android SDK was updated to v4.5.4

### Added

- Start/Stop tracking from the SDK methods
- iOS platform support

## [0.0.2] - 2020-08-06

### Fixed

- Missing notification properties setter implementation was added at Java layer.
- Device metadata setter bug was fixed.

## [0.0.1] - 2020-07-29

### Added

- Cordova support for HyperTrack Android SDK v4.5.3

[0.0.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.0.1
[0.0.2]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.0.2
[0.0.3]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.0.3
[0.0.4]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.0.4
[0.0.5]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.0.5
[0.0.6]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.0.6
[0.1.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.1.0
[0.1.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.1.1
[0.2.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.2.0
[0.2.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.2.1
[0.3.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.3.0
[0.4.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.4.0
[0.4.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.4.1
[0.4.2]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.4.2
[0.5.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.5.0
[0.6.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.6.0
[0.6.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.6.1
[0.6.2]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.6.2
[0.6.3]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.6.3
[0.6.4]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/0.6.4
[1.0.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/1.0.0
[1.0.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/1.0.1
[1.0.2]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/1.0.2
[1.0.3]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/1.0.3
[1.1.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/1.1.0
[2.0.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/2.0.0
[2.0.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/2.0.1
[2.1.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/tag/2.1.0
[2.1.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/tag/2.1.1
[2.1.2]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/tag/2.1.2
[2.2.0]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/tag/2.2.0
[2.2.1]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/tag/2.2.1
[2.2.2]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/tag/2.2.2
[2.2.3]: https://github.com/hypertrack/cordova-plugin-hypertrack/releases/tag/2.2.3
