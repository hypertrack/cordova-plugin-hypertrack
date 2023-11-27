package com.hypertrack.sdk.cordova.plugin

import com.hypertrack.sdk.android.HyperTrack
import com.hypertrack.sdk.cordova.plugin.common.*
import com.hypertrack.sdk.cordova.plugin.common.HyperTrackSdkWrapper
import com.hypertrack.sdk.cordova.plugin.common.SdkMethod
import com.hypertrack.sdk.cordova.plugin.common.Serialization.serializeErrors
import com.hypertrack.sdk.cordova.plugin.common.Serialization.serializeIsAvailable
import com.hypertrack.sdk.cordova.plugin.common.Serialization.serializeIsTracking
import com.hypertrack.sdk.cordova.plugin.common.Serialization.serializeLocateResult
import com.hypertrack.sdk.cordova.plugin.common.Serialization.serializeLocationResult
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.apache.cordova.PluginResult
import org.json.JSONArray
import org.json.JSONObject
import java.util.*

class HyperTrackCordovaPlugin : CordovaPlugin() {

    private var errorsEventStream: CallbackContext? = null
    private var isAvailableEventStream: CallbackContext? = null
    private var isTrackingEventStream: CallbackContext? = null
    private var locateEventStream: CallbackContext? = null
    private var locationEventStream: CallbackContext? = null

    private var locateSubscription: HyperTrack.Cancellable? = null

    override fun pluginInitialize() {
        initListeners()
    }

    override fun execute(
        action: String,
        args: JSONArray,
        callbackContext: CallbackContext,
    ): Boolean {
        return invokeSdkMethod(action, args, callbackContext).sendAsCallbackResult(callbackContext)
    }

    private fun invokeSdkMethod(
        methodName: String,
        argsJson: JSONArray,
        callbackContext: CallbackContext,
    ): WrapperResult<*> {
        return when (val method = SdkMethod.values().firstOrNull { it.name == methodName }) {
            SdkMethod.addGeotag -> {
                withArgs<Map<String, Any?>, Map<String, Any?>>(argsJson) { args ->
                    HyperTrackSdkWrapper.addGeotag(args)
                }
            }
            SdkMethod.getDeviceID -> {
                HyperTrackSdkWrapper.getDeviceId()
            }
            SdkMethod.getErrors -> {
                HyperTrackSdkWrapper.getErrors()
            }
            SdkMethod.getIsAvailable -> {
                HyperTrackSdkWrapper.getIsAvailable()
            }
            SdkMethod.getIsTracking -> {
                HyperTrackSdkWrapper.getIsTracking()
            }
            SdkMethod.getLocation -> {
                HyperTrackSdkWrapper.getLocation()
            }
            SdkMethod.getMetadata -> {
                HyperTrackSdkWrapper.getMetadata()
            }
            SdkMethod.getName -> {
                HyperTrackSdkWrapper.getName()
            }
            SdkMethod.locate -> {
                locateSubscription?.cancel()
                locateEventStream?.let { disposeCallback(it) }
                locateEventStream = callbackContext
                locateSubscription = HyperTrack.locate {
                    sendEvent(callbackContext, serializeLocateResult(it))
                }
                Success(NoCallback)
            }
            SdkMethod.setIsAvailable -> {
                withArgs<Map<String, Any?>, Unit>(argsJson) { args ->
                    HyperTrackSdkWrapper.setIsAvailable(args)
                }
            }
            SdkMethod.setIsTracking -> {
                withArgs<Map<String, Any?>, Unit>(argsJson) { args ->
                    HyperTrackSdkWrapper.setIsTracking(args)
                }
            }
            SdkMethod.setMetadata -> {
                withArgs<Map<String, Any?>, Unit>(argsJson) { args ->
                    HyperTrackSdkWrapper.setMetadata(args)
                }
            }
            SdkMethod.setName -> {
                withArgs<Map<String, Any?>, Unit>(argsJson) { args ->
                    HyperTrackSdkWrapper.setName(args)
                }
            }
            else -> {
                when (
                    SubscriptionCall.values().firstOrNull {
                        it.name == methodName
                    }
                ) {
                    SubscriptionCall.subscribeToErrors -> {
                        errorsEventStream?.let { disposeCallback(it) }
                        errorsEventStream = callbackContext
                        sendEvent(callbackContext, serializeErrors(HyperTrack.errors))
                        Success(NoCallback)
                    }
                    SubscriptionCall.subscribeToIsAvailable -> {
                        isAvailableEventStream?.let { disposeCallback(it) }
                        isAvailableEventStream = callbackContext
                        sendEvent(callbackContext, serializeIsAvailable(HyperTrack.isAvailable))
                        Success(NoCallback)
                    }
                    SubscriptionCall.subscribeToIsTracking -> {
                        isTrackingEventStream?.let { disposeCallback(it) }
                        isTrackingEventStream = callbackContext
                        sendEvent(callbackContext, serializeIsTracking(HyperTrack.isTracking))
                        Success(NoCallback)
                    }
                    SubscriptionCall.subscribeToLocation -> {
                        locationEventStream?.let { disposeCallback(it) }
                        locationEventStream = callbackContext
                        sendEvent(callbackContext, serializeLocationResult(HyperTrack.location))
                        Success(NoCallback)
                    }
                    SubscriptionCall.unsubscribeFromErrors -> {
                        errorsEventStream?.let { disposeCallback(it) }
                        errorsEventStream = null
                        Success(Unit)
                    }
                    SubscriptionCall.unsubscribeFromIsAvailable -> {
                        isAvailableEventStream?.let { disposeCallback(it) }
                        isAvailableEventStream = null
                        Success(Unit)
                    }
                    SubscriptionCall.unsubscribeFromIsTracking -> {
                        isTrackingEventStream?.let { disposeCallback(it) }
                        isTrackingEventStream = null
                        Success(Unit)
                    }
                    SubscriptionCall.unsubscribeFromLocate -> {
                        locateEventStream?.let { disposeCallback(it) }
                        locateEventStream = null
                        Success(Unit)
                    }
                    SubscriptionCall.unsubscribeFromLocation -> {
                        locationEventStream?.let { disposeCallback(it) }
                        locationEventStream = null
                        Success(Unit)
                    }
                    else -> {
                        Failure(Exception("$method method is not implemented"))
                    }
                }
            }
        }
    }

    private fun sendEvent(callbackContext: CallbackContext, data: Any) {
        try {
            when (data) {
                is String -> {
                    PluginResult(PluginResult.Status.OK, data)
                }
                is Map<*, *> -> {
                    PluginResult(PluginResult.Status.OK, JSONObject(data))
                }
                is List<*> -> {
                    PluginResult(PluginResult.Status.OK, JSONArray(data))
                }
                else -> {
                    PluginResult(
                        PluginResult.Status.ERROR,
                        IllegalArgumentException("Invalid event data: $data").toString(),
                    )
                }
            }
        } catch (e: Exception) {
            PluginResult(PluginResult.Status.ERROR, e.toString())
        }.let {
            it.keepCallback = true
            callbackContext.sendPluginResult(it)
        }
    }

    private fun disposeCallback(callbackContext: CallbackContext) {
        val result = PluginResult(PluginResult.Status.NO_RESULT, "").also {
            it.keepCallback = false
        }
        callbackContext.sendPluginResult(result)
    }

    private inline fun <reified T, N> withArgs(
        args: JSONArray,
        crossinline sdkMethodCall: (T) -> WrapperResult<N>,
    ): WrapperResult<N> {
        return when (T::class) {
            Map::class -> {
                try {
                    Success(args.getJSONObject(0))
                } catch (e: Exception) {
                    Failure(IllegalArgumentException(args.toString(), e))
                }.flatMapSuccess {
                    sdkMethodCall.invoke(it.toMap() as T)
                }
            }
            String::class -> {
                try {
                    Success(args.getString(0))
                } catch (e: Exception) {
                    Failure(IllegalArgumentException(args.toString(), e))
                }.flatMapSuccess {
                    sdkMethodCall.invoke(it as T)
                }
            }
            else -> {
                Failure(IllegalArgumentException(args.toString()))
            }
        }
    }

    private fun initListeners() {
        HyperTrack.subscribeToErrors { errors ->
            errorsEventStream?.let {
                sendEvent(it, serializeErrors(errors))
            }
        }
        HyperTrack.subscribeToIsAvailable { isAvailable ->
            isAvailableEventStream?.let {
                sendEvent(it, serializeIsAvailable(isAvailable))
            }
        }
        HyperTrack.subscribeToIsTracking { isTracking ->
            isTrackingEventStream?.let {
                sendEvent(it, serializeIsTracking(isTracking))
            }
        }
        HyperTrack.subscribeToLocation { location ->
            locationEventStream?.let {
                sendEvent(it, serializeLocationResult(location))
            }
        }
    }
}

private fun <S> WrapperResult<S>.sendAsCallbackResult(callbackContext: CallbackContext): Boolean {
    return when (this) {
        is Success -> {
            when (val success = this.success) {
                is Map<*, *> -> {
                    callbackContext.success(JSONObject(success))
                    true
                }
                is List<*> -> {
                    callbackContext.success(JSONArray(success))
                    true
                }
                is String -> {
                    callbackContext.success(success)
                    true
                }
                is Unit -> {
                    callbackContext.success()
                    true
                }
                is NoCallback -> {
                    true
                }
                else -> {
                    callbackContext.failure(
                        IllegalArgumentException("Invalid response ${this.success}"),
                    )
                    false
                }
            }
        }
        is Failure -> {
            callbackContext.failure(this.failure)
            false
        }
    }
}

private fun JSONObject.toMap(): Map<String, Any?> {
    return keys().asSequence().associateWith { key ->
        when (val value = this.get(key)) {
            is Boolean,
            is String,
            is Double,
            is Int,
            -> {
                value
            }
            is JSONArray -> {
                value.toList()
            }
            is JSONObject -> {
                value.toMap()
            }
            else -> {
                null
            }
        }
    }
}

private fun JSONArray.toList(): List<Any> {
    return (0..length()).mapNotNull { index ->
        when (val value = this.get(index)) {
            is Boolean,
            is String,
            is Double,
            is Int,
            -> {
                value
            }
            is JSONArray -> {
                value.toList()
            }
            is JSONObject -> {
                value.toMap()
            }
            else -> {
                null
            }
        }
    }
}

internal fun CallbackContext.failure(exception: Throwable) {
    this.error(exception.toString())
}
