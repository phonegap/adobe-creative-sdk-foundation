#import <AdobeCreativeSDK/AdobeCreativeSDK.h>
#import "PGAdobeCreativeSDK.h"

@implementation PGAdobeCreativeSDK

- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}

- (void)pluginInitialize
{
}

- (void) echo:(CDVInvokedUrlCommand*)command
{
    NSString* value = [command.arguments objectAtIndex:0];
    if (!([value isKindOfClass:[NSString class]])) {
        value = @"";
    }
	
	NSLog(@"Echo: %@", value);
}

@end
