# Changelog

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

##  [0.0.1] - 2020-07-29
### Added
- Cordova support for HyperTrack Android SDK v4.5.3
