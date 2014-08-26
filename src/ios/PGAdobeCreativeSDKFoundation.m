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

- (void) downloadFiles:(CDVInvokedUrlCommand*)command
{
    __weak CDVPlugin* weakSelf = self;
    
    NSDictionary* options = [command.arguments firstObject];
    CGSize renditionSize = FULL_SIZE_RENDITION;
    AdobeAssetFileRenditionType renditionType = AdobeAssetFileRenditionTypeJPEG;
    
    if (options != nil && [options isKindOfClass:[NSDictionary class]]) {
        NSNumber* rWidth = [options objectForKey:@"width"];
        NSNumber* rHeight = [options objectForKey:@"height"];
        NSNumber* rType = [options objectForKey:@"type"];
        
        if (rType != nil) {
            renditionType = [rType integerValue];
        }
        
        if (rWidth != nil && rHeight != nil) {
            renditionSize = CGSizeMake([rWidth floatValue], [rHeight floatValue]);
        }
    }
    
    void(^downloadFailure)(NSString*, NSString*)= ^(NSString* href, NSString* errorMessage) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@ (%@)", errorMessage, href]];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    
    void(^downloadInit)(NSString*, AdobeAssetFile*)= ^(NSString* href, AdobeAssetFile* assetFile) {
        NSDictionary* dict = @{
            @"href" : href,
            @"metadata" : [assetFile propertiesAsDictionary]
        };
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                           messageAsDictionary:dict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    
    void(^downloadProgress)(NSString*, double)= ^(NSString* href, double fractionCompleted) {
        NSDictionary* dict = @{
            @"href" : href,
            @"fractionCompleted" : [NSNumber numberWithDouble:fractionCompleted]
        };
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:dict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };

    void(^downloadCompleted)(NSString*, NSData*, BOOL)= ^(NSString* href, NSData* data, BOOL fromCache) {
        // Save the file to NSTemporaryDirectory() location, with uuid filename
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [NSTemporaryDirectory() stringByStandardizingPath], uuidString];
        CFRelease(uuidString);
        CFRelease(uuidRef);
        
        [data writeToFile:filePath atomically:YES];
        NSURL* fileURL = [NSURL fileURLWithPath:filePath];
        
        NSDictionary* dict = @{
            @"href" : href,
            @"result" : [fileURL absoluteString],
            @"cached" : [NSNumber numberWithBool:fromCache]
        };
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:dict];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };

    [[AdobeUXAssetBrowser sharedBrowser]
        popupFileBrowserWithParent:self.viewController withExclusionList:nil
        onSuccess: ^(NSArray* itemSelections) {
            AdobeSelectionAsset* itemSelection = [itemSelections lastObject];
            AdobeAsset* item = (AdobeAsset*)itemSelection.selectedItem;
           
            if (IsAdobeAssetFile(item)) {
                AdobeAssetFile* file = (AdobeAssetFile*)item;
                downloadInit(file.href, file);
               
                [file getRenditionWithType: renditionType
                               withSize: renditionSize
                           withPriority: NSOperationQueuePriorityNormal
                        onProgress: ^(double fractionCompleted) {
                            downloadProgress(file.href, fractionCompleted);
                        }
                        onCompletion: ^(NSData* data, BOOL fromCache) {
                            downloadCompleted(file.href, data, fromCache);
                        }
                        onCancellation:^ {
                            downloadFailure(file.href, @"Cancelled");
                        }
                        onError:^(NSError* error) {
                            downloadFailure(file.href, [error localizedDescription]);
                        }
                ];
            }
        }
        onError:^(NSError* error) {
            downloadFailure(nil, [error localizedDescription]);
        }
    ];
}

@end
