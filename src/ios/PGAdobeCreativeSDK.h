#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVInvokedUrlCommand.h>
#import <AdobeCreativeSDK/AdobeAuthManager.h>

@interface PGAdobeCreativeSDK : CDVPlugin {
    @private
    BOOL isInitialized;
}

- (void) login:(CDVInvokedUrlCommand*)command;
- (void) logout:(CDVInvokedUrlCommand*)command;

@end
