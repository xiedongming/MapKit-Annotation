//
//  ViewController.m
//  MKmapView
//
//  Created by Admin on 2017/4/20.
//  Copyright © 2017年 xiedongming. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyPoint.h"
#import "CustomPinAnnotationView.h"
#import "KCAnnotation.h"
@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    
    MKMapView *_mapView;
}
@property (nonatomic,retain) NSMutableArray *locationArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //    定位授权
    
    _locationManager = [[CLLocationManager alloc]init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate=self;
    //设置定位精度
    _locationManager.desiredAccuracy=kCLLocationAccuracyKilometer;
    CLLocationDistance distance=1000.0;//十米定位一次
    _locationManager.distanceFilter=distance;
    
    //    地图视图
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.mapType=MKMapTypeStandard;
    _mapView.userTrackingMode = MKUserTrackingModeNone;


    [self.view addSubview:_mapView];
//    [self addAnnotation];
    
    [self loadData];
    

}
- (void)loadData{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"PinData" ofType:@"plist"];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:filePath];
    
    //    把plist数据转换成大头针model
    for (NSDictionary *dict in tempArray) {
        MyPoint *Model = [[MyPoint alloc]initWithAnnotationModelWithDict:dict];
        [self.locationArray addObject:Model];
    }
    //    核心代码
    [_mapView addAnnotations:self.locationArray];
    
    //    _mapView.centerCoordinate = userLocation.coordinate;
    MyPoint *Model =self.locationArray[0];
    [_mapView setRegion:MKCoordinateRegionMake(Model.coordinate, MKCoordinateSpanMake(0.1, 0.1)) animated:YES];
//    [_locationManager stopUpdatingLocation];
//    [self loadData];

    
}
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

//    userLocation.title  =@"你好";
    // 反地理编码；根据经纬度查找地名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0 || error) {
            NSLog(@"找不到该位置");
            return;
        }
        // 当前地标
        CLPlacemark *pm = [placemarks firstObject];
        
        // 区域名称
        userLocation.title = pm.locality;
        // 详细名称
        userLocation.subtitle = pm.name;
          }];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    /*
     
     * 大头针分两种
     
     * 1. MKPinAnnotationView：他是系统自带的大头针，继承于MKAnnotationView，形状跟棒棒糖类似，可以设置糖的颜色，和显示的时候是否有动画效果
     
     * 2. MKAnnotationView：可以用指定的图片作为大头针的样式，但显示的时候没有动画效果，如果没有给图片的话会什么都不显示
     
     * 3. mapview有个代理方法，当大头针显示在试图上时会调用，可以实现这个方法来自定义大头针的动画效果，我下面写有可以参考一下
     
     * 4. 在这里我为了自定义大头针的样式，使用的是MKAnnotationView
     
     */
    
    
    // 判断是不是用户的大头针数据模型
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"redPin"];
        //        是否允许显示插入视图*********
        annotationView.canShowCallout = YES;
        
        
        
        
        return nil; //返回nil 显示系统默认的大头针
    }
/**
 //这是自定义的大头针视图, 可以用任意图片替换掉大头针
 CustomPinAnnotationView *annotationView = (CustomPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"otherAnnotationView"];
 if (annotationView == nil) {
 annotationView = [[CustomPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"otherAnnotationView"];
 }
 annotationView.image = [UIImage imageNamed:@"super"];
 annotationView.label.text = @"超市";

 **/
    
    //设置重用标示符
    static NSString *annotationID = @"annotation";
    //先从重用的队列中找
    MKPinAnnotationView *view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
    //没找到就创建
    if (!view)
    {
        view = [[ MKPinAnnotationView alloc]init];
    }
    //设置属性
    view.annotation = annotation;
//    view.image = [UIImage imageNamed:@"1.png"];  //MKAnnotationView 是这个可以替换大头针

    view.canShowCallout = YES;//显示气泡
    view.pinTintColor = [UIColor redColor];//大头针颜色
//    view.animatesDrop = YES; //是否有动画掉落动画
    view.rightCalloutAccessoryView = [self yesButton];
    
    //在气泡视图中显示图片
    view.rightCalloutAccessoryView = [self yesButton];
    return view;
    
    
   
}

- (UIButton *)yesButton {
    
//    UIImage *image = [self yesButtonImage];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25 , 25); // don't use auto layout
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitle:@"详情" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    return button;
    
}
-(void)didTapButton:(UIButton *)btn{
    
    
}

#pragma mark 选中了标注的处理事件

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, -30, 100, 30)];
    //    view2.backgroundColor = [UIColor orangeColor];
    //    [view addSubview:view2];
    //    [view setSelected:NO];
    //    // 获得所有MKAnnotationView
    //    NSArray *arr = mapView.annotations;
    //
    //    // 被点击的MKAnnotationView的标题和副标题
    //    NSString *titleStr = view.annotation.title;
    //    NSString *subtitleStr = view.annotation.subtitle;
    
    //    []
     NSLog(@"选中了标注");
}



#pragma mark 取消选中标注的处理事件
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"取消了标注");
}


#pragma mark lazy load

- (NSMutableArray *)locationArray{
    
    if (_locationArray == nil) {
        
        _locationArray = [NSMutableArray new];
        
    }
    return _locationArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
