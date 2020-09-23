/********* HyperTrackPlugin.m Cordova Plugin Implementation *******/


#import "HyperTrackPlugin.h"
@import HyperTrack;

@interface HyperTrackPlugin ()

@property(strong, nonatomic, nullable) HTResult *htResult;
@property(strong, nonatomic, nullable) CDVInvokedUrlCommand *statusUpdateCallback;

@end

@implementation HyperTrackPlugin

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

#pragma mark NSNotification

- (void)subscribe:(CDVInvokedUrlCommand *)command {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(sendTrackingStateToRNWith:)
                                               name:HTSDK.startedTrackingNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(sendTrackingStateToRNWith:)
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
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
  [pluginResult setKeepCallbackAsBool:YES];
  self.statusUpdateCallback = command;
  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)unsubscribe:(CDVInvokedUrlCommand *)command {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.statusUpdateCallback = NULL;
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
  [pluginResult setKeepCallbackAsBool:NO];
  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)updateStatus:(NSString *)update {
  if (self.statusUpdateCallback != NULL) {
    [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:update]
                                callbackId:self.statusUpdateCallback.callbackId];
  }
}

- (void)sendTrackingStateToRNWith:(NSNotification*)notification {
  NSString *eventName = @"";
  if ([notification.name isEqualToString: @"HyperTrackStartedTracking"]) {
    eventName = @"start";
  } else if ([notification.name isEqualToString: @"HyperTrackStoppedTracking"]) {
    eventName = @"stop";
  } else {
    return;
  }
  [self updateStatus: eventName];
}

- (void)sendCriticalErrorToRNWith:(NSNotification*)notification {
  [self updateStatus: [notification hyperTrackTrackingError].description];
}

@end
