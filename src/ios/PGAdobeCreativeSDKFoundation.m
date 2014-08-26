#import <AdobeCreativeSDKFoundation/AdobeCreativeSDKFoundation.h>
#import "PGAdobeCreativeSDKFoundation.h"
#import "NSObject+PropertiesAsDictionary.h"
#import "NSArray+ItemAsDictionary.h"

@implementation PGAdobeCreativeSDKFoundation

#define ADOBE_CSDK_CLIENT_ID       @""
#define ADOBE_CSDK_CLIENT_SECRET   @""


- (void)pluginInitialize
{
    // TODO: this can be grabbed as part of the plugin installation process, for now to make it easy, we
    // hard-code this. We do NOT want to expose the CLIENT_SECRET in JavaScript, it has to be in native code.
    // This could be a post-build hook
    
    if ([@"" isEqualToString:ADOBE_CSDK_CLIENT_ID]) {
        NSLog(@"WARNING - PGAdobeCreativeSDKFoundation - ADOBE_CSDK_CLIENT_ID is not set");
    }
    if ([@"" isEqualToString:ADOBE_CSDK_CLIENT_SECRET]) {
        NSLog(@"WARNING - PGAdobeCreativeSDKFoundation - ADOBE_CSDK_CLIENT_SECRET is not set");
    }
    
    [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:ADOBE_CSDK_CLIENT_ID withClientSecret:ADOBE_CSDK_CLIENT_SECRET];
}

- (void) login:(CDVInvokedUrlCommand*)command
{
    __weak CDVPlugin* weakSelf = self;
    
    void(^loginSuccess)(AdobeAuthUserProfile*)= ^(AdobeAuthUserProfile* profile) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:[profile propertiesAsDictionary]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    
    void(^loginFailure)(NSString*)= ^(NSString* errorMessage) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    
    if([AdobeUXAuthManager sharedManager].authenticated) {
        loginSuccess([AdobeUXAuthManager sharedManager].userProfile);
    } else {
        [[AdobeUXAuthManager sharedManager] login:self.viewController
         onSuccess:^(AdobeAuthUserProfile* profile) {
             loginSuccess(profile);
         } onError:^(NSError *error) {
             loginFailure([error localizedDescription]);
         }];
    }
}

- (void) logout:(CDVInvokedUrlCommand*)command
{
    __weak CDVPlugin* weakSelf = self;
 
	[[AdobeUXAuthManager sharedManager] logout:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } onError:^(NSError *error) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) getFileMetadata:(CDVInvokedUrlCommand*)command
{
    __weak CDVPlugin* weakSelf = self;
    
    void(^getSuccess)(AdobeSelectionAssetArray*)= ^(AdobeSelectionAssetArray* items) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsArray:[items arrayWithItemsAsDictionaries]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    
    void(^getFailure)(NSString*)= ^(NSString* errorMessage) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    
    [[AdobeUXAssetBrowser sharedBrowser]
         popupFileBrowser:^(AdobeSelectionAssetArray* itemSelections) {
             NSMutableArray* m = [NSMutableArray arrayWithCapacity:[itemSelections count]];
             for(id item in itemSelections) {
                 AdobeAsset* it = ((AdobeSelectionAsset*)item).selectedItem;
                 [m addObject:it];
             }
             getSuccess(m);
         }
         onError:^(NSError *error) {
             getFailure([error localizedDescription]);
         }
    ];
}

@end
