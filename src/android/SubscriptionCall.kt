package com.hypertrack.sdk.cordova.plugin

/**
 * Method calls that init event subscriptions
 * Enum naming convention is ignored to make datatype sync across platforms easier
 */
@Suppress("EnumEntryName")
enum class SubscriptionCall {
    subscribeToErrors,
    subscribeToIsAvailable,
    subscribeToIsTracking,
    subscribeToLocation,
    unsubscribeFromErrors,
    unsubscribeFromIsAvailable,
    unsubscribeFromIsTracking,
    unsubscribeFromLocate,
    unsubscribeFromLocation,
}
