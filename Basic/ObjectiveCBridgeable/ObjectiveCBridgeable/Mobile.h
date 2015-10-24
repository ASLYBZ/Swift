//
//  Mobile.h
//  ObjectiveCBridgeable
//
//  Created by hanhui on 15/10/21.
//  Copyright © 2015年 Minya Knoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mobile : NSObject

@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *system;

- (instancetype)initWithBrand:(NSString *)brand system:(NSString *)system;

@end
