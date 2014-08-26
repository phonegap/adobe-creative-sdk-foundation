#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVInvokedUrlCommand.h>
#import <AdobeCreativeSDKFoundation/AdobeUXAuthManager.h>

@interface PGAdobeCreativeSDKFoundation : CDVPlugin {
    @private
    BOOL isInitialized;
}

- (void) login:(CDVInvokedUrlCommand*)command;
- (void) logout:(CDVInvokedUrlCommand*)command;
- (void) getFileMetadata:(CDVInvokedUrlCommand*)command;
- (void) downloadFiles:(CDVInvokedUrlCommand*)command;

@end
