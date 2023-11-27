import HyperTrack

@objc final class HyperTrackCordovaPlugin: CDVPlugin {
    private var errorsSubscriptionCallbackID: String? = nil
    private var isAvailableSubscriptionCallbackID: String? = nil
    private var isTrackingSubscriptionCallbackID: String? = nil
    private var locationSubscriptionCallbackID: String? = nil

    private var errorsSubscription: HyperTrack.Cancellable!
    private var isAvailableSubscription: HyperTrack.Cancellable!
    private var isTrackingSubscription: HyperTrack.Cancellable!
    private var locationSubscription: HyperTrack.Cancellable!

    private var locateSubscriptionCallbackID: String? = nil
    private var locateSubscription: HyperTrack.Cancellable!

    override func pluginInitialize() {
        initListeners()
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

    @objc func getDeviceID(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getDeviceIDMethod(),
            self,
            command
        )
    }

    @objc func getErrors(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getErrorsMethod(),
            self,
            command
        )
    }

    @objc func getIsAvailable(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getIsAvailableMethod(),
            self,
            command
        )
    }

    @objc func getIsTracking(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getIsTrackingMethod(),
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

    @objc func getMetadata(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getMetadataMethod(),
            self,
            command
        )
    }

    @objc func getName(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            getNameMethod(),
            self,
            command
        )
    }

    @objc func locate(_ command: CDVInvokedUrlCommand) {
        locateSubscription?.cancel()
        locateSubscriptionCallbackID = command.callbackId
        locateSubscription = HyperTrack.locate { location in
            self.sendLocateEvent(location)
        }
        sendNoResult(self, command)
    }

    @objc func setIsAvailable(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            setIsAvailableMethod(command.arguments[0] as! [String: Any]),
            self,
            command
        )
    }

    @objc func setIsTracking(_ command: CDVInvokedUrlCommand) {
        sendAsResult(
            setIsTrackingMethod(command.arguments[0] as! [String: Any]),
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

    @objc func subscribeToErrors(_ command: CDVInvokedUrlCommand) {
        errorsSubscriptionCallbackID = command.callbackId
        sendErrorsEvent(serializeErrors(HyperTrack.errors))
        sendNoResult(self, command)
    }

    @objc func subscribeToIsAvailable(_ command: CDVInvokedUrlCommand) {
        isAvailableSubscriptionCallbackID = command.callbackId
        sendIsAvailableEvent(isAvailable: HyperTrack.isAvailable)
        sendNoResult(self, command)
    }

    @objc func subscribeToIsTracking(_ command: CDVInvokedUrlCommand) {
        isTrackingSubscriptionCallbackID = command.callbackId
        sendIsTrackingEvent(isTracking: HyperTrack.isTracking)
        sendNoResult(self, command)
    }

    @objc func subscribeToLocation(_ command: CDVInvokedUrlCommand) {
        locationSubscriptionCallbackID = command.callbackId
        sendLocationEvent(HyperTrack.location)
        sendNoResult(self, command)
    }

    @objc func unsubscribeFromErrors(_ command: CDVInvokedUrlCommand) {
        errorsSubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    @objc func unsubscribeFromIsAvailable(_ command: CDVInvokedUrlCommand) {
        isAvailableSubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    @objc func unsubscribeFromIsTracking(_ command: CDVInvokedUrlCommand) {
        isTrackingSubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    @objc func unsubscribeFromLocate(_ command: CDVInvokedUrlCommand) {
        locateSubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    @objc func unsubscribeFromLocation(_ command: CDVInvokedUrlCommand) {
        locationSubscriptionCallbackID = nil
        sendAsResult(.success(.void), self, command)
    }

    private func initListeners() {
        errorsSubscription = HyperTrack.subscribeToErrors { errors in
            self.sendErrorsEvent(serializeErrors(errors))
        }
        isAvailableSubscription = HyperTrack.subscribeToIsAvailable { isAvailable in
            self.sendIsAvailableEvent(isAvailable: isAvailable)
        }
        isTrackingSubscription = HyperTrack.subscribeToIsTracking { isTracking in
            self.sendIsTrackingEvent(isTracking: isTracking)
        }
        locationSubscription = HyperTrack.subscribeToLocation { location in
            self.sendLocationEvent(location)
        }
    }

    private func sendIsAvailableEvent(isAvailable: Bool) {
        guard let isAvailableSubscriptionCallbackID = isAvailableSubscriptionCallbackID else {
            return
        }
        let result = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: serializeIsAvailable(isAvailable)
        )
        result!.keepCallback = true
        commandDelegate!.send(
            result,
            callbackId: isAvailableSubscriptionCallbackID
        )
    }

    private func sendIsTrackingEvent(isTracking: Bool) {
        guard let isTrackingSubscriptionCallbackID = isTrackingSubscriptionCallbackID else {
            return
        }
        let result = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: serializeIsTracking(isTracking)
        )
        result!.keepCallback = true
        commandDelegate!.send(
            result,
            callbackId: isTrackingSubscriptionCallbackID
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

    private func sendLocateEvent(_ locateResult: Result<HyperTrack.Location, Set<HyperTrack.Error>>) {
        guard let locateSubscriptionCallbackID = locateSubscriptionCallbackID else {
            return
        }
        let result = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: serializeLocateResult(locateResult)
        )
        result!.keepCallback = true
        commandDelegate!.send(
            result,
            callbackId: locateSubscriptionCallbackID
        )
    }

    private func sendLocationEvent(_ location: Result<HyperTrack.Location, HyperTrack.Location.Error>) {
        guard let locationSubscriptionCallbackID = locationSubscriptionCallbackID else {
            return
        }
        let result = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: serializeLocationResult(location)
        )
        result!.keepCallback = true
        commandDelegate!.send(
            result,
            callbackId: locationSubscriptionCallbackID
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
        case let .array(array):
            plugin.commandDelegate!.send(
                CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: array
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
