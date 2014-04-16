
#import "NSArray+ItemAsDictionary.h"
#import "NSObject+PropertiesAsDictionary.h"

@implementation NSArray (ItemAsDictionary)

- (NSArray*) arrayWithItemsAsDictionaries
{
    NSMutableArray* a = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in self) {
        [a addObject:[obj propertiesAsDictionary]];
    }
    
    return a;
}

@end
