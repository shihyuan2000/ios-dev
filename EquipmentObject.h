//
//  EquipmentObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/20/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (nonatomic) NSUInteger                projectId;
@property (nonatomic) NSUInteger                dailyReportId;
@property (nonatomic) NSUInteger                equipmentId;
@property (strong, nonatomic) NSString          *equipment;
@property (strong, nonatomic) NSString          *code;
@property NSUInteger                            asset;
@property float                                 hours;
@property (strong, nonatomic) NSString          *useageDesc;
@property NSUInteger                            site;
@property NSUInteger                            user;
@property (nonatomic) NSUInteger                drEquipmentId;
@end
