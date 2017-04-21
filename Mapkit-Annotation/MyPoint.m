//
//  MyPoint.m
//  MKmapView
//
//  Created by Admin on 2017/4/20.
//  Copyright © 2017年 xiedongming. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
//        CGFloat latitute =[dict[@"coordinate"][@"latitute"] doubleValue];
//        CGFloat longitude =[dict[@"coordinate"][@"longitude"] doubleValue];
//    self.coordinate = CLLocationCoordinate2DMake(latitute, longitude);
        self.coordinate = CLLocationCoordinate2DMake([dict[@"coordinate"][@"latitute"] doubleValue], [dict[@"coordinate"][@"longitude"] doubleValue]);

        self.title = dict[@"title"];
        self.subtitle = dict[@"subtitle"];
        
    }
    return self;
}

@end
