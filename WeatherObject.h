//
//  WeatherObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/2/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject

@property NSInteger                                     weatherId;
@property (strong, nonatomic) NSString                  *weather;
@property (strong, nonatomic) NSString                  *conditionGroup;
@property NSInteger                                     code;

@end
