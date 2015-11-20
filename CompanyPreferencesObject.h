//
//  CompanyPreferencesObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 11/26/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyPreferencesObject : NSObject

@property (nonatomic) BOOL                      dailyReportOvertimeEnabled;
@property (nonatomic) BOOL                      dailyReportDoubleTimeEnabled;
@property (nonatomic) BOOL                      dailyReportUnitTrackingEnabled;
@property (nonatomic) BOOL                      dailyReportEquipmentEnabled;
@property (nonatomic) BOOL                      dailyReportMaterialsEnabled;

@end
