//
//  DailyReportTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/7/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"
#import "DailyReportObject.h"
#import "WeatherObject.h"
#import "WindObject.h"
#import "CompanyPreferencesObject.h"

@interface DailyReportTableViewController : UITableViewController

@property (strong, nonatomic) NSString                  *title;
@property (strong, nonatomic) NSString                  *reportName;
@property NSInteger                                     projectId;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) NSMutableArray            *dailyReports;
@property (strong, nonatomic) NSString                  *drDate;
@property (strong, nonatomic) DailyReportObject         *dr;

@property (strong, nonatomic) NSMutableArray            *windObjects;
@property (strong, nonatomic) NSMutableArray            *weatherObjects;
@property (strong, nonatomic) NSMutableArray            *activity;
@property (strong, nonatomic) NSMutableArray            *workType;
@property (strong, nonatomic) NSMutableArray            *employee;
@property (strong, nonatomic) CompanyPreferencesObject  *companyPreferences;
@property (strong, nonatomic) NSMutableArray            *systemPhases;
@property (strong, nonatomic) NSMutableArray            *employeeList;
@property (strong, nonatomic) NSMutableArray            *projectEquipment;

@end
