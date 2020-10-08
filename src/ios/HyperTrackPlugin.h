#import <Cordova/CDV.h>

@interface HyperTrackPlugin : CDVPlugin

  - (void)initialize:(CDVInvokedUrlCommand *)command;
  - (void)isRunning:(CDVInvokedUrlCommand *)command;
  - (void)getDeviceId:(CDVInvokedUrlCommand *)command;
  - (void)syncDeviceSettings:(CDVInvokedUrlCommand *)command;
  - (void)setTrackingNotificationProperties:(CDVInvokedUrlCommand *)command;
  - (void)allowMockLocations:(CDVInvokedUrlCommand *)command;
  - (void)requestPermissionsIfNecessary:(CDVInvokedUrlCommand *)command;
  - (void)addGeoTag:(CDVInvokedUrlCommand *)command;
  - (void)start:(CDVInvokedUrlCommand *)command;
  - (void)stop:(CDVInvokedUrlCommand *)command;
  - (void)setDeviceMetadata:(CDVInvokedUrlCommand *)command;
  - (void)setDeviceName:(CDVInvokedUrlCommand *)command;
  - (void)enableDebugLogging:(CDVInvokedUrlCommand *)command;

@end
