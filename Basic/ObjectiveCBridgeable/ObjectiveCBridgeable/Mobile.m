//
//  Mobile.m
//  ObjectiveCBridgeable
//
//  Created by hanhui on 15/10/21.
//  Copyright © 2015年 Minya Knoka. All rights reserved.
//

#import "Mobile.h"

@implementation Mobile

- (instancetype)initWithBrand:(NSString *)brand system:(NSString *)system {

    self = [super init];
    
    if (self) {
        _brand = brand;
        _system = system;
    }
    
    return self;
}

@end
