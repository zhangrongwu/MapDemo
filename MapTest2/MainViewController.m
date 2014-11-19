//
//  MainViewController.m
//  MapTest2
//
//  Created by 秦智博 on 14-9-20.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "MainViewController.h"
#import "CustomAnnotation.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        self.inforClick = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建地图
    map = [[MKMapView alloc] initWithFrame:[self.view bounds]];
    map.showsUserLocation = YES;
    map.mapType = MKMapTypeStandard;
    [self.view addSubview:map];
    
    
    // 定位到指定纬度
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(38.8834344641,121.5447431659);
    
    float zoomLevel = 0.02;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [map setRegion:[map regionThatFits:region] animated:YES];
    
    // 调用创建大头针方法
    [self createAnnotationWithCoords:coords];
    
    
    // 定位到当前位置并获取经纬度
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//定位精度 设置为最优
    locationManager.distanceFilter=1000.0f;// 距离过滤器 至少移动1000米再次定位
    [locationManager startUpdatingLocation];// 启动位置更新
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(270, 360, 40, 40);
    [button setTitle:@"定位" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    NSMutableArray *typeArr = [NSMutableArray arrayWithObjects:@"卫星", @"标准", @"混合", nil];
    for (int i = 0; i < 3; i++) {
        UIButton *buttonType1 = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonType1.frame = CGRectMake(260, 40 + 40 * i, 40, 30);
        [buttonType1 setTitle:[typeArr objectAtIndex:i] forState:UIControlStateNormal];
        [buttonType1 addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventTouchUpInside];
        buttonType1.backgroundColor = [UIColor redColor];
        [buttonType1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonType1.tag = 10000 + i;
        [self.view addSubview:buttonType1];

    }
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(40, 40, 30, 30);
    button1.backgroundColor = [UIColor whiteColor];
    [button1 setTitle:@"+" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(bigger:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(40, 80, 30, 30);
    button2.backgroundColor = [UIColor whiteColor];
    [button2 setTitle:@"-" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(smaller:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(240, 390, 100, 40);
    [button3 setTitle:@"查看位置" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(information:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    ///  长按，出现大头针
    [self longPressGestureRecognizerAddAnnotation];
    
    
    // 显示当前信息
    self.inforView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 230, 150)];
    self.inforView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"当前国家", @"当前省份", @"当前城市", @"当前区/县", @"当前街道", nil];
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30 * i, 80, 30)];
        label.text = [arr objectAtIndex:i];
        [self.inforView addSubview:label];
        
        if (i != 0) {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 29 * i, 210, 0.5)];
            lineLabel.backgroundColor = [UIColor lightGrayColor];
            [self.inforView addSubview:lineLabel];
        }
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 30 * i, 130, 30)];
        label1.tag = 10000 + i;
        label1.textAlignment = NSTextAlignmentCenter;
        [self.inforView addSubview:label1];
        
    }
    
    [map addSubview:self.inforView];
}

- (void)changeMapType:(UIButton *)button
{
    switch (button.tag) {
        case 10000:
            map.mapType = MKMapTypeSatellite;// 卫星
            break;
        case 10001:
            map.mapType = MKMapTypeStandard;// 标准
            break;
        case 10002:
            map.mapType = MKMapTypeHybrid;// 混合
            break;
        default:
            break;
    }
}

#pragma mark - 添加大头针

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords {
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:
                                    coords];
    
    annotation.title = @"标题";
    annotation.subtitle = @"子标题";
    [map addAnnotation:annotation];
}

#pragma mark - 定位的协议方法

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [locationManager stopUpdatingLocation];
    
    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@  Lng: %@", strLat, strLng);
    
    //海拔
    NSString *  horizontalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    
    NSLog(@"hh : %@",horizontalAccuracyString);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];// 当前位置的地理信息
    
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *placemarks,NSError *error) {
        
        if (!error) {
            for (CLPlacemark *placemark in placemarks)
            {
                NSMutableArray *arr1= [NSMutableArray array];
                NSString *str1 = @"";
                NSString *str2 = @"";
                NSString *str3 = @"";
                NSString *str4 = @"";
                NSString *str5 = @"";
                if ([placemark country] != nil) {
                    str1 = [placemark country];
                }
                if ([placemark administrativeArea] != nil) {
                    str2 = [placemark administrativeArea];
                }
                if ([placemark locality] != nil) {
                    str3 = [placemark locality];
                }
                if ([placemark subAdministrativeArea] != nil) {
                    str4 = [placemark subAdministrativeArea];
                }
                if ([placemark thoroughfare] != nil) {
                    str5 = [placemark thoroughfare];
                }
                [arr1 addObject:str1];
                [arr1 addObject:str2];
                [arr1 addObject:str3];
                [arr1 addObject:str4];
                [arr1 addObject:str5];
                for (int i = 0; i < 5; i++) {
                    UILabel *label = (UILabel *)[self.inforView viewWithTag: 10000 + i];
                    label.text = [arr1 objectAtIndex:i];
                }
                
                NSLog(@"%@", [[placemark addressDictionary]description]);
            }
        }
        else
        {
            NSLog(@"There was a reverse geocoding error\n%@",
                  [error localizedDescription]);
        }
    }
     ];
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    float zoomLevel = 0.02;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [map setRegion:[map regionThatFits:region] animated:YES];
    
}

#pragma mark - 查看详细信息

- (void)information:(UIButton *)button
{
    if (self.inforClick == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.inforView.frame = CGRectMake(0, self.view.frame.size.height - 150, 230, 150);
        }];
        self.inforClick = 1;
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.inforView.frame = CGRectMake(0, self.view.frame.size.height, 230, 150);
        }];
        self.inforClick = 0;
    }
}

#pragma mark - 打印错误日志

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locError:%@", error);
    
}

#pragma mark - 放大方法

- (void)bigger:(UIButton *)button
{
    MKCoordinateRegion region = map.region;
    region.span.latitudeDelta=region.span.latitudeDelta * 0.4;
    region.span.longitudeDelta=region.span.longitudeDelta * 0.4;
    [map setRegion:region animated:YES];
}

#pragma mark - 缩小方法

- (void)smaller:(UIButton *)button
{
    MKCoordinateRegion region = map.region;
    region.span.latitudeDelta=region.span.latitudeDelta * 1.3;
    region.span.longitudeDelta=region.span.longitudeDelta * 1.3;
    [map setRegion:region animated:YES];
}


#pragma mark--  手势添加大头针
-(void)longPressGestureRecognizerAddAnnotation
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration =0.5 ;//0.5响应时间
    longPress.allowableMovement = 10.0;
    [map addGestureRecognizer:longPress];
    
}

#pragma mark - 长按屏幕

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    CGPoint touchPoint = [longPress locationInView:map];
    CLLocationCoordinate2D touchMapCottdinate  = [map convertPoint:touchPoint toCoordinateFromView:map];
    
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:
                                    touchMapCottdinate];
    
    annotation.title = @"标题";
    annotation.subtitle = @"子标题";
    [map addAnnotation:annotation];
    
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"手势开始");
    }
}

#pragma mark - 定位按钮
- (void)location:(UIButton *)button
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
