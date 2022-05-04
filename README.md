# HyperTrack Cordova Plugin

![GitHub](https://img.shields.io/github/license/hypertrack/sdk-react-native.svg)
![npm](https://img.shields.io/npm/v/hypertrack-sdk-react-native.svg)
[![iOS SDK](https://img.shields.io/badge/iOS%20SDK-4.8.0-brightgreen.svg)](https://cocoapods.org/pods/HyperTrack)
![Android SDK](https://img.shields.io/badge/Android%20SDK-6.0.4-brightgreen.svg)

HyperTrack lets you add live location tracking to your mobile app. Live location is made available along with ongoing activity, tracking controls and tracking outage with reasons.

Plugin for Cordova is a wrapper around native iOS and Android SDKs that allows to integrate them into Cordova apps.

For information about how to get started, please visit this HyperTrack Guide.

## Installation

```Bash
cordova plugin add cordova-plugin-hypertrack-v3

```

### Publishable Key
Get your publishable key from the [hypertrack dashboard](https://dashboard.hypertrack.com/setup).

## Usage

Check out our [Quickstart](https://github.com/hypertrack/quickstart-cordova/) for details.

## How to update Hypertrack SDK Version?

1. Update SDK version constant
    - Android 
        - src/android/HypertrackPlugin.gradle
            - HYPERTRACK_SDK_VERSION
    - iOS
        - plugin.xml
            - `<platform name="ios">`
                - `<pod name="HyperTrack/Objective-C" version="**version**"/>`

2. Update wrapper version
    - package.json
        - version
    - plugin.xml
        - version

3. Update CHANGELOG
4. Update README badge
5. Create a version tag
6. Commit and push
7. Create a release
    - Release title - version
8. npm publish


## License

The MIT License

Copyright (c) 2020 HyperTrack Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
