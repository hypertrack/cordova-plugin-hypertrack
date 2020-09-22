/********* HyperTrackPlugin.m Cordova Plugin Implementation *******/


#import "HyperTrackPlugin.h"
@import HyperTrack;

@interface HyperTrackPlugin ()

@property(strong, nonatomic, nullable) HTSDK *hypertrack;

@end

@implementation HyperTrackPlugin

- (void)initialize:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* publishableKey = [command.arguments objectAtIndex:0];

  if (publishableKey == NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"Publishable Key cannot be an empty string."];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
  }

  HTResult* htResult = [HTSDK makeSDKWithPublishableKey:publishableKey];

  if (htResult.hyperTrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else if (htResult.error != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:htResult.error.description];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setDeviceName:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* deviceName = [command.arguments objectAtIndex:0];

  if (self.hypertrack != NULL && deviceName != NULL) {
    [self.hypertrack setDeviceName: deviceName];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setDeviceMetadata:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* deviceMetadata = [command.arguments objectAtIndex:0];
  HTMetadata *htMetadata = [[HTMetadata alloc] initWithJsonString:deviceMetadata];

  if (self.hypertrack != NULL) {
    if (htMetadata != NULL) {
      [self.hypertrack setDeviceMetadata: htMetadata];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Metadata can't be NULL."];
    }
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addGeoTag:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;
  NSString* geotag = [command.arguments objectAtIndex:0];
  HTMetadata *htGeotag = [[HTMetadata alloc] initWithJsonString:geotag];

  if (self.hypertrack != NULL) {
    if (htGeotag != NULL) {
      [self.hypertrack addGeotag:htGeotag];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Geotag can't be NULL."];
    }
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)requestPermissionsIfNecessary:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.hypertrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)allowMockLocations:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.hypertrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)setTrackingNotificationProperties:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.hypertrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)syncDeviceSettings:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.hypertrack != NULL) {
    [self.hypertrack syncDeviceSettings];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self.hypertrack deviceID]];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}

- (void)isRunning:(CDVInvokedUrlCommand *)command {

  CDVPluginResult* pluginResult = nil;

  if (self.hypertrack != NULL) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }

  [self.commandDelegate sendPluginResult: pluginResult callbackId:command.callbackId];
}


//subscribe
//
//unsubscribe


@end
