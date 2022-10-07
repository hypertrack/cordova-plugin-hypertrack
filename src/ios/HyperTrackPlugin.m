/********* HyperTrackPlugin.m Cordova Plugin Implementation *******/


#import "HyperTrackPlugin.h"
#import <WebKit/WebKit.h>
@import HyperTrack;

@interface HyperTrackPlugin ()

@property(strong, nonatomic, nullable) HTResult *htResult;
@property(strong, nonatomic, nullable) CDVInvokedUrlCommand *statusUpdateCallback;
@property (strong, nonatomic, nullable) NSString *trackingStateCallbackId;
@property (strong, nonatomic, nullable) NSString *availabilityStateCallbackId;
@end

@implementation HyperTrackPlugin

- (void)trackingStateChange: (CDVInvokedUrlCommand *)command{

  self.trackingStateCallbackId = command.callbackId;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(sendTrackingStartState)
                                              name:HTSDK.startedTrackingNotification
                                            object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(sendTrackingStopState)
                                              name:HTSDK.stoppedTrackingNotification
                                            object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(sendCriticalErrorToRNWith:)
                                              name:HTSDK.didEncounterRestorableErrorNotification
                                            object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(sendCriticalErrorToRNWith:)
                                              name:HTSDK.didEncounterUnrestorableErrorNotification
                                            object:nil];
}

- (void)disposeTrackingState:(CDVInvokedUrlCommand *)command {

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                        name:HTSDK.startedTrackingNotification
                                        object:nil ];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                        name:HTSDK.stoppedTrackingNotification
                                        object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                        name:HTSDK.didEncounterRestorableErrorNotification
                                        object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                        name:HTSDK.didEncounterUnrestorableErrorNotification
                                        object:nil];

  [self.commandDelegate sendPluginResult:nil callbackId:command.callbackId];
}

- (void)availabilityStateChange:(CDVInvokedUrlCommand *)command {

  self.availabilityStateCallbackId = command.callbackId;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(sendAvailableState)
                                        name:HTSDK.becameAvailableNotification
                                        object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(sendUnavailableState)
                                        name:HTSDK.becameUnavailableNotification
                                        object:nil];
}

- (void)disposeAvailabilityState:(CDVInvokedUrlCommand *)command {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                        name:HTSDK.becameAvailableNotification
                                        object:nil ];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                        name:HTSDK.becameUnavailableNotification
                                        object:nil];
                                        
  [self.commandDelegate sendPluginResult:nil callbackId:command.callbackId];
}

- (void)initialize:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* publishableKey = [command.arguments objectAtIndex:0];

  if (publishableKey == NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Publishable Key cannot be an empty string."];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
  }

  self.htResult = [HTSDK makeSDKWithPublishableKey:publishableKey];

  if (self.htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setDeviceName:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* deviceName = [command.arguments objectAtIndex:0];

  if (self.htResult.hyperTrack != NULL) {
    if (deviceName != NULL) {
      [self.htResult.hyperTrack setDeviceName: deviceName];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Device name can't be NULL."];
    }
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setAvailability:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* available = [command.arguments objectAtIndex:0];

  if (self.htResult.hyperTrack != NULL) {
    if (available != NULL) {
      [self.htResult.hyperTrack setAvailability:(available.boolValue ? HTAvailabilityAvailable : HTAvailabilityUnavailable)];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Param can't be NULL."];
    }
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getAvailability:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
  if([self.htResult.hyperTrack availability] == HTAvailabilityAvailable) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"available"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"unavailable"];
    }
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}


- (void)setDeviceMetadata:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* deviceMetadata = [command.arguments objectAtIndex:0];
  HTMetadata *htMetadata = [[HTMetadata alloc] initWithJsonString:deviceMetadata];

  if (self.htResult.hyperTrack != NULL) {
    if (htMetadata != NULL) {
      [self.htResult.hyperTrack setDeviceMetadata: htMetadata];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Metadata can't be NULL."];
    }
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addGeoTag:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* geotag = [command.arguments objectAtIndex:0];
  HTMetadata *htGeotag = [[HTMetadata alloc] initWithJsonString:geotag];

  if (self.htResult.hyperTrack != NULL) {
    if (htGeotag != NULL) {
      [self.htResult.hyperTrack addGeotag:htGeotag];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Geotag can't be NULL."];
    }
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)start:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    [self.htResult.hyperTrack start];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stop:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    [self.htResult.hyperTrack stop];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)requestPermissionsIfNecessary:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)allowMockLocations:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)enableDebugLogging:(CDVInvokedUrlCommand *)command {
  [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)setTrackingNotificationProperties:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)getDeviceId:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self.htResult.hyperTrack deviceID]];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)syncDeviceSettings:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    [self.htResult.hyperTrack syncDeviceSettings];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)isRunning:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[self.htResult.hyperTrack isRunning] ? 1 : 0 ];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)isTracking:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[self.htResult.hyperTrack isTracking] ? 1 : 0 ];
  } else if (self.htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: self.htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)sendTrackingStartState {

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"start"];
  [pluginResult setKeepCallbackAsBool:YES];
    
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.trackingStateCallbackId];
}

- (void)sendTrackingStopState {

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"stop"];
  [pluginResult setKeepCallbackAsBool:YES];
    
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.trackingStateCallbackId];
}

- (void)sendCriticalErrorToRNWith:(NSNotification*)notification {

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[notification hyperTrackTrackingError].description];
  [pluginResult setKeepCallbackAsBool:YES];
    
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.trackingStateCallbackId];
}

- (void)sendAvailableState {

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"available"];
  [pluginResult setKeepCallbackAsBool:YES];
    
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.availabilityStateCallbackId];
}

- (void)sendUnavailableState {

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"unavailable"];
  [pluginResult setKeepCallbackAsBool:YES];
  
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.availabilityStateCallbackId];
}

@end
