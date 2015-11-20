//
//  DailyReportLogTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/7/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyReportTableViewController.h"
#import "DailyReportObject.h"
#import "ActivityObject.h"
#import "WorkTypeObject.h"
#import "EmployeeObject.h"
#import "CompanyPreferencesObject.h"
#import "ProjectObject.h"
#import "SWTableViewCell.h"

@interface DailyReportLogTableViewController : UITableViewController <SWTableViewCellDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) NSInteger                 projectId;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) NSMutableArray            *dailyReports;
@property (strong, nonatomic) NSMutableArray            *contacts;
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
