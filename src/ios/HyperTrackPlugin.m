/********* HyperTrackPlugin.m Cordova Plugin Implementation *******/


#import "HyperTrackPlugin.h"
#import <WebKit/WebKit.h>
@import HyperTrack;

@interface Info: NSObject

@property(strong, nonatomic) NSString *eventType;
@property(strong, nonatomic) NSString *data;

- (instancetype)initWithEventType:(NSString*)type data:(NSString*)data;

@end

@implementation Info

- (instancetype)initWithEventType:(NSString*)type data:(NSString*)data;
{
  self = [super init];
  if (self) {
    self.eventType = type;
    self.data = data;
  }
  return self;
}

@end

@interface HyperTrackPlugin ()

@property(strong, nonatomic, nullable) HTResult *htResult;
@property(strong, nonatomic, nullable) CDVInvokedUrlCommand *statusUpdateCallback;

@end

@implementation HyperTrackPlugin

- (void)pluginInitialize {
  [self startEventDispatching];
}

- (void)dealloc {
  [self stopEventDispatching];
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

- (void)startEventDispatching {
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
}

- (void)stopEventDispatching {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateStatus:(Info *)info {
  [self sendEventWithJSON:@{@"eventType": [info eventType], @"data": [info data]}];
}

- (void)sendTrackingStateToRNWith:(NSNotification*)notification {
  NSString *data = @"";
  if ([notification.name isEqualToString: @"HyperTrackStartedTracking"]) {
    data = @"start";
  } else if ([notification.name isEqualToString: @"HyperTrackStoppedTracking"]) {
    data = @"stop";
  } else {
    return;
  }
  [self updateStatus: [[Info alloc] initWithEventType:@"onHyperTrackStatusChanged" data:data]];
}

- (void)sendCriticalErrorToRNWith:(NSNotification*)notification {
  [self updateStatus: [[Info alloc] initWithEventType:@"onHyperTrackError" data:[notification hyperTrackTrackingError].description]];
}

- (BOOL)sendEventWithJSON:(id)JSON {
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        JSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:JSON options:0 error:NULL] encoding:NSUTF8StringEncoding];
    }
    NSString *script = [NSString stringWithFormat:@"HyperTrackPlugin.dispatchEvent(%@)", JSON];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:script];
    return [result length]? [result boolValue]: YES;
}

void runOnMainQueueWithoutDeadlocking(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script {
    __block NSString *result;
#if WK_WEB_VIEW_ONLY
    if ([self.webView isKindOfClass:WKWebView.class]) {
        runOnMainQueueWithoutDeadlocking(^{
            [((WKWebView *)self.webView) evaluateJavaScript:script completionHandler:^(id resultID, NSError *error) {
                result = [resultID description];
            }];
        });
    }
#else
    if ([self.webView isKindOfClass:UIWebView.class]) {
        result = [(UIWebView *)self.webView stringByEvaluatingJavaScriptFromString:script];
    } else if ([self.webView isKindOfClass:WKWebView.class]) {
        runOnMainQueueWithoutDeadlocking(^{
            [((WKWebView *)self.webView) evaluateJavaScript:script completionHandler:^(id resultID, NSError *error) {
                result = [resultID description];
            }];
        });
    }
#endif
    return result;
}

@end
