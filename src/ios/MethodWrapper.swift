func addGeotagMethod(_ args: [String: Any]) -> Result<SuccessResult, FailureResult> {
    return addGeotag(args)
}

func getDeviceIDMethod() -> Result<SuccessResult, FailureResult> {
    return getDeviceID()
}

func getErrorsMethod() -> Result<SuccessResult, FailureResult> {
    return getErrors()
}

func getIsAvailableMethod() -> Result<SuccessResult, FailureResult> {
    return getIsAvailable()
}

func getIsTrackingMethod() -> Result<SuccessResult, FailureResult> {
    return getIsTracking()
}

func getLocationMethod() -> Result<SuccessResult, FailureResult> {
    return getLocation()
}

func getMetadataMethod() -> Result<SuccessResult, FailureResult> {
    return getMetadata()
}

func getNameMethod() -> Result<SuccessResult, FailureResult> {
    return getName()
}

func setIsAvailableMethod(_ args: [String: Any]) -> Result<SuccessResult, FailureResult> {
    return setIsAvailable(args)
}

func setIsTrackingMethod(_ args: [String: Any]) -> Result<SuccessResult, FailureResult> {
    return setIsTracking(args)
}

func setMetadataMethod(_ args: [String: Any]) -> Result<SuccessResult, FailureResult> {
    return setMetadata(args)
}

func setNameMethod(_ args: [String: Any]) -> Result<SuccessResult, FailureResult> {
    return setName(args)
}
