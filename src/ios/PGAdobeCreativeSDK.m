#import <AdobeCreativeSDK/AdobeCreativeSDK.h>
#import "PGAdobeCreativeSDK.h"
#import "NSObject+PropertiesAsDictionary.h"


@implementation PGAdobeCreativeSDK

#define DEVICE_NAME     @"PGAdobeCreativeSDK"
#define CLIENT_ID       @""
#define CLIENT_SECRET   @""


- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}

- (void)pluginInitialize
{
    // TODO: this can be grabbed as part of the plugin installation process, for now to make it easy, we
    // hard-code this. We do NOT want to expose the CLIENT_SECRET in JavaScript, it has to be in native code.
    // This could be a post-build hook
    
    if ([@"" isEqualToString:CLIENT_ID]) {
        NSLog(@"WARNING - PGAdobeCreativeSDK - CLIENT_ID is not set");
    }
    if ([@"" isEqualToString:CLIENT_SECRET]) {
        NSLog(@"WARNING - PGAdobeCreativeSDK - CLIENT_SECRET is not set");
    }
    
	[[AdobeAuthManager sharedManager] setAuthenticationEndpoint:AdobeAuthEndpointStageUS
                                                 withDeviceName:DEVICE_NAME
                                                   withClientID:CLIENT_ID
                                               withClientSecret:CLIENT_SECRET];
}

- (void) login:(CDVInvokedUrlCommand*)command
{
    __weak CDVPlugin* weakSelf = self;
    
	[[AdobeAuthManager sharedManager] login:self.viewController
     onSuccess:^(AdobeAuthUserProfile* profile) {
         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                       messageAsDictionary:[profile propertiesAsDictionary]];
         [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     } onError:^(NSError *error) {
         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
         [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
     }];
}

- (void) logout:(CDVInvokedUrlCommand*)command
{
    __weak CDVPlugin* weakSelf = self;
 
	[[AdobeAuthManager sharedManager] logout:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } onError:^(NSError *error) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
