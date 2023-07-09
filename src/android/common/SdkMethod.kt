package com.hypertrack.sdk.cordova.plugin.common

/**
 * The list of available methods in the SDK API.
 * Enum naming convention is ignored to make datatype sync across platforms easier.
 * Using Swift naming convention.
 */
internal enum class SdkMethod {
    initialize,
    getDeviceID,
    getLocation,
    startTracking,
    stopTracking,
    setAvailability,
    setName,
    setMetadata,
    isTracking,
    isAvailable,
    addGeotag,
    sync,
}
