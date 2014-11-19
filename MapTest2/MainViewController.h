//
//  MainViewController.h
//  MapTest2
//
//  Created by 秦智博 on 14-9-20.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *map;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain)UIView *inforView;

@property (nonatomic, assign)NSInteger inforClick;// 详情页面是否弹出


@end
