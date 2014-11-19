//
//  CustomAnnotation.m
//  MapTest2
//
//  Created by 秦智博 on 14-9-20.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate, title, subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init]) {
        coordinate = coords;
    }
    return self;
}

@end
