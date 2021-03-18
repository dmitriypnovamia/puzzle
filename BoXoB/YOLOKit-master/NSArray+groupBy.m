#import "YOLO.ph"
#import <Foundation/Foundation.h>
@implementation NSArray (YOLOGroupBy)

- (NSDictionary *(^)(id (^)(id o)))groupBy {
    return ^id(id (^block)(id)) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        for (id o in self) {
            id key = block(o);
            if (!dict[key])
                dict[key] = [NSMutableArray arrayWithObject:o];
            else
                [dict[key] addObject:o];
        }
        return dict;
    };
}

@end
