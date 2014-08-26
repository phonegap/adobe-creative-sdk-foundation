
#import "NSObject+PropertiesAsDictionary.h"
#import <objc/runtime.h>

@implementation NSObject (PropertiesAsDictionary)

- (BOOL) isValidJSONValue:(id)value
{
    return (
        [value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]] ||
        [value isKindOfClass:[NSArray class]] ||
        [value isKindOfClass:[NSDictionary class]] ||
        [value isKindOfClass:[NSNull class]]
    );
}

- (NSDictionary*) propertiesAsDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t* properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString* key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        
        if ([self isValidJSONValue:value]) {
            [dict setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
