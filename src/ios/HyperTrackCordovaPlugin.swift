import HyperTrack

@objc final class HyperTrackCordovaPlugin: CDVPlugin {
    private var trackingSubscriptionCallbackID: String? = nil
    private var availabilitySubscriptionCallbackID: String? = nil
    private var errorsSubscriptionCallbackID: String? = nil

    private var errorsSubscription: HyperTrack.Cancellable!

    @objc func initialize(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            initializeSDK(command.arguments[0] as! [String: Any]).map { _ in
                initListeners()
                return .void
            },
            self,
            command
        )
    }

    @objc func getDeviceID(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getDeviceIDMethod(),
            self,
            command
        )
    }

    @objc func sync(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            syncMethod(),
            self,
            command
        )
    }

    @objc func addGeotag(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            addGeotagMethod(command.arguments[0] as! [String: Any]),
            self,
            command
        )
    }

    @objc func addGeotagWithExpectedLocation(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            addGeotagMethod(command.arguments[0] as! [String: Any]),
            self,
            command
        )
    }

    @objc func startTracking(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            startTrackingMethod(),
            self,
            command
        )
    }

    @objc func stopTracking(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            stopTrackingMethod(),
            self,
            command
        )
    }

    @objc func setMetadata(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            setMetadataMethod(command.arguments[0] as! [String: Any]),
            self,
            command
        )
    }

    @objc func setName(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            setNameMethod(command.arguments[0] as! [String: Any]),
            self,
            command
        )
    }

    @objc func setAvailability(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            setAvailabilityMethod(command.arguments[0] as! [String: Any]),
            self,
            command
        )
    }

    @objc func isAvailable(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            isAvailableMethod(),
            self,
            command
        )
    }

    @objc func isTracking(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            isTrackingMethod(),
            self,
            command
        )
    }

    @objc func getLocation(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getLocationMethod(),
            self,
            command
        )
    }

    @objc func subscribeToTracking(_ command: CDVInvokedUrlCommand) {
        trackingSubscriptionCallbackID = command.callbackId
        sendTrackingEvent(isTracking: sdkInstance.isTracking)
        sendNoResult(self, command)
    }

    @objc func subscribeToAvailability(_ command: CDVInvokedUrlCommand) {
        availabilitySubscriptionCallbackID = command.callbackId
        sendAvailabilityEvent(isAvailable: sdkInstance.availability)
        sendNoResult(self, command)
    }

    @objc func subscribeToErrors(_ command: CDVInvokedUrlCommand) {
        errorsSubscriptionCallbackID = command.callbackId
        sendErrorsEvent(serializeErrors(sdkInstance.errors))
        sendNoResult(self, command)
    }

    @objc func unsubscribeFromTracking(_ command: CDVInvokedUrlCommand) {
        trackingSubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    @objc func unsubscribeFromAvailability(_ command: CDVInvokedUrlCommand) {
        availabilitySubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    @objc func unsubscribeFromErrors(_ command: CDVInvokedUrlCommand) {
        errorsSubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    private func initListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(onTrackingStarted), name: HyperTrack.startedTrackingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTrackingStopped), name: HyperTrack.stoppedTrackingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAvailable), name: HyperTrack.becameAvailableNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUnavailable), name: HyperTrack.becameUnavailableNotification, object: nil)
        errorsSubscription = sdkInstance.subscribeToErrors { errors in
            self.sendErrorsEvent(serializeErrors(errors))
        }
    }

    @objc
    private func onTrackingStarted() {
        sendTrackingEvent(isTracking: true)
    }

    @objc
    private func onTrackingStopped() {
        sendTrackingEvent(isTracking: false)
    }

    @objc
    private func onAvailable() {
        sendAvailabilityEvent(isAvailable: .available)
    }

    @objc
    private func onUnavailable() {
        sendAvailabilityEvent(isAvailable: .unavailable)
    }

    private func sendTrackingEvent(isTracking: Bool) {
        guard let trackingSubscriptionCallbackID = trackingSubscriptionCallbackID else {
            return
        }
        let result = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: serializeIsTracking(isTracking)
        )
        result!.keepCallback = true
        commandDelegate!.send(
            result,
            callbackId: trackingSubscriptionCallbackID
        )
    }

    private func sendAvailabilityEvent(isAvailable: HyperTrack.Availability) {
        guard let availabilitySubscriptionCallbackID = availabilitySubscriptionCallbackID else {
            return
        }
        let result = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: serializeIsAvailable(isAvailable)
        )
        result!.keepCallback = true
        commandDelegate!.send(
            result,
            callbackId: availabilitySubscriptionCallbackID
        )
    }

    private func sendErrorsEvent(_ errors: [[String: Any]]) {
        guard let errorsSubscriptionCallbackID = errorsSubscriptionCallbackID else {
            return
        }
        let result = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: errors
        )
        result!.keepCallback = true
        commandDelegate!.send(
            result,
            callbackId: errorsSubscriptionCallbackID
        )
    }
}

func sendAsResult(
    _ result: Result<SuccessResult, FailureResult>,
    _ plugin: CDVPlugin,
    _ command: CDVInvokedUrlCommand
) {
    switch result {
    case let .success(success):
        switch success {
        case let .dict(dict):
            plugin.commandDelegate!.send(
                CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: dict
                ),
                callbackId: command.callbackId
            )
            return
        case .void:
            plugin.commandDelegate!.send(
                CDVPluginResult(status: CDVCommandStatus_OK),
                callbackId: command.callbackId
            )
            return
        }

    case let .failure(failure):
        switch failure {
        case let .fatalError(message):
            preconditionFailure(message)
        case let .error(message):
            plugin.commandDelegate!.send(
                CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: message
                ),
                callbackId: command.callbackId
            )
            return
        }
    }
}

func sendNoResult(
    _ plugin: CDVPlugin,
    _ command: CDVInvokedUrlCommand
) {
    let result = CDVPluginResult(
        status: CDVCommandStatus_NO_RESULT
    )
    result!.keepCallback = true
    plugin.commandDelegate!.send(
        result,
        callbackId: command.callbackId
    )
}
