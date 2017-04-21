//
//  MyPoint.h
//  MKmapView
//
//  Created by Admin on 2017/4/20.
//  Copyright © 2017年 xiedongming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyPoint : NSObject <MKAnnotation>

//实现MKAnnotation协议必须要定义这个属性
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
//标题
@property (nonatomic, copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
//初始化方法
- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict;

@end
