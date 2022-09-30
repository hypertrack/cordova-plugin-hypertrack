func getDeviceIDMethod() -> Result<SuccessResult, FailureResult> {
    return getDeviceID()
}

func startTrackingMethod() -> Result<SuccessResult, FailureResult> {
    return startTracking()
}

func stopTrackingMethod() -> Result<SuccessResult, FailureResult> {
    return stopTracking()
}

func syncMethod() -> Result<SuccessResult, FailureResult> {
    return sync()
}

func addGeotagMethod(_ args: Dictionary<String, Any>) -> Result<SuccessResult, FailureResult> {
    return addGeotag(args)
}

func setMetadataMethod(_ args: Dictionary<String, Any>) -> Result<SuccessResult, FailureResult> {
    return setMetadata(args)
}

func setNameMethod(_ args: Dictionary<String, Any>) -> Result<SuccessResult, FailureResult> {
    return setName(args)
}

func setAvailabilityMethod(_ args: Dictionary<String, Any>) -> Result<SuccessResult, FailureResult> {
    return setAvailability(args)
}
func isAvailableMethod() -> Result<SuccessResult, FailureResult> {
    return isAvailable()
}


func isTrackingMethod() -> Result<SuccessResult, FailureResult> {
    return isTracking()
}

func getLocationMethod() -> Result<SuccessResult, FailureResult> {
    return getLocation()
}
