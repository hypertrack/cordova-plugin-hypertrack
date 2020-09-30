#import "AppDelegate+HyperTrackPlugin.h"
#import "HyperTrackPlugin.h"
#import <objc/runtime.h>
@import HyperTrack;


@implementation AppDelegate (HyperTrackPlugin)

+ (void)load {
  [AppDelegate swizzle];
}

+ (void)swizzle {

  Method didFinishLaunching_original = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
  Method didFinishLaunching_swizzled = class_getInstanceMethod(self, @selector(application:swizzledDidFinishLaunchingWithOptions:));
  method_exchangeImplementations(didFinishLaunching_original, didFinishLaunching_swizzled);

  SEL didRegisterForRemoteNotificationsWithDeviceToken = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
  SEL didReceiveRemoteNotification = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
  SEL didFailToRegisterForRemoteNotificationsWithError = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);

  Method didRegisterForRemoteNotifications_original = class_getInstanceMethod(self, didRegisterForRemoteNotificationsWithDeviceToken);
  Method didReceiveRemoteNotification_original = class_getInstanceMethod(self, didReceiveRemoteNotification);
  Method didFailToRegisterForRemoteNotifications_original = class_getInstanceMethod(self, didFailToRegisterForRemoteNotificationsWithError);


  if (didRegisterForRemoteNotifications_original) {
    Method didRegisterForRemoteNotifications_swizzled = class_getInstanceMethod(self, @selector(application:swizzledDidRegisterForRemoteNotificationsWithDeviceToken:));
    method_exchangeImplementations(didRegisterForRemoteNotifications_original, didRegisterForRemoteNotifications_swizzled);
  } else {
    Method didRegisterForRemoteNotifications_replaced = class_getInstanceMethod(self, @selector(application:replacedDidRegisterForRemoteNotificationsWithDeviceToken:));
    class_replaceMethod([self class],
                        didRegisterForRemoteNotificationsWithDeviceToken,
                        method_getImplementation(didRegisterForRemoteNotifications_replaced),
                        method_getTypeEncoding(didRegisterForRemoteNotifications_replaced));
  }

  if (didReceiveRemoteNotification_original) {
    Method didReceiveRemoteNotification_swizzled = class_getInstanceMethod(self, @selector(application:swizzledDidReceiveRemoteNotification:fetchCompletionHandler:));
    method_exchangeImplementations(didReceiveRemoteNotification_original, didReceiveRemoteNotification_swizzled);
  } else {
    Method didReceiveRemoteNotification_replaced = class_getInstanceMethod(self, @selector(application:replacedDidReceiveRemoteNotification:fetchCompletionHandler:));
    class_replaceMethod([self class],
                        didReceiveRemoteNotification,
                        method_getImplementation(didReceiveRemoteNotification_replaced),
                        method_getTypeEncoding(didReceiveRemoteNotification_replaced));
  }

  if (didFailToRegisterForRemoteNotifications_original) {
    Method didFailToRegisterForRemoteNotifications_swizzled = class_getInstanceMethod(self, @selector(application:swizzledDidFailToRegisterForRemoteNotificationsWithError:));
    method_exchangeImplementations(didFailToRegisterForRemoteNotifications_original, didFailToRegisterForRemoteNotifications_swizzled);
  } else {
    Method didFailToRegisterForRemoteNotificationsWithError_replaced = class_getInstanceMethod(self, @selector(application:replacedDidFailToRegisterForRemoteNotificationsWithError:));
    class_replaceMethod([self class],
                        didFailToRegisterForRemoteNotificationsWithError,
                        method_getImplementation(didFailToRegisterForRemoteNotificationsWithError_replaced),
                        method_getTypeEncoding(didFailToRegisterForRemoteNotificationsWithError_replaced));
  }
}

#pragma mark - didFinishLaunchingWithOptions:

- (BOOL)application:(UIApplication *)application swizzledDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self application:application swizzledDidFinishLaunchingWithOptions:launchOptions];
  [HTSDK registerForRemoteNotifications];
  return YES;
}

#pragma mark - didRegisterForRemoteNotificationsWithDeviceToken:

- (void)application:(UIApplication *)application swizzledDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"application swizzledDidRegisterForRemoteNotificationsWithDeviceToken: %@", [deviceToken description]);
  [self application:application swizzledDidRegisterForRemoteNotificationsWithDeviceToken: deviceToken];
  [HTSDK didRegisterForRemoteNotificationsWithDeviceToken: deviceToken];
}

- (void)application:(UIApplication *)application replacedDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"application replacedDidRegisterForRemoteNotificationsWithDeviceToken: %@", [deviceToken description]);
  [HTSDK didRegisterForRemoteNotificationsWithDeviceToken: deviceToken];
}

#pragma mark - didReceiveRemoteNotification: fetchCompletionHandler:

- (void)application:(UIApplication *)application swizzledDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"application swizzledDidReceiveRemoteNotification: %@", [userInfo description]);
  if ([[userInfo allKeys] containsObject: @"hypertrack"]) {
    [HTSDK didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  } else {
    [self application:application swizzledDidReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  }
}

- (void)application:(UIApplication *)application replacedDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"application replacedDidReceiveRemoteNotification: %@", [userInfo description]);
  [HTSDK didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

#pragma mark - didFailToRegisterForRemoteNotificationsWithError:

- (void)application:(UIApplication *)application swizzledDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"application swizzledDidFailToRegisterForRemoteNotificationsWithError: %@", [error description]);
  [self application:application swizzledDidFailToRegisterForRemoteNotificationsWithError: error];
  [HTSDK didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application replacedDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"application replacedDidFailToRegisterForRemoteNotificationsWithError: %@", [error description]);
  [HTSDK didFailToRegisterForRemoteNotificationsWithError:error];
}

@end
