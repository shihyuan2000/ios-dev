//
//  CrewLogTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/7/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrewEntryTableViewController.h"
#import "CompanyPreferencesObject.h"

@interface CrewLogTableViewController : UITableViewController

@property (strong, nonatomic) NSString                  *title;
@property (strong, nonatomic) NSString                  *reportName;
@property NSInteger                                     projectId;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) NSString                  *drDate;
@property (strong, nonatomic) NSMutableArray            *activity;
@property (strong, nonatomic) NSMutableArray            *workType;
@property (strong, nonatomic) NSMutableArray            *employee;
@property (strong, nonatomic) CompanyPreferencesObject  *companyPreferences;
@property (strong, nonatomic) NSMutableArray            *systemPhases;
@property (strong, nonatomic) NSMutableArray            *crewList;
@property (strong, nonatomic) NSMutableArray            *employeeList;
@property (strong, nonatomic) DailyReportObject         *dr;

@end
