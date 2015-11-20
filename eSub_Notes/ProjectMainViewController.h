//
//  ProjectMainViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/3/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"
#import "MapViewController.h"
#import "ProjectDetailsViewController.h"
#import "UploadsViewController.h"
#import "ContactsViewController.h"
#import "RFIViewController.h"
#import "DailyReportLogTableViewController.h"
#import "WebViewViewController.h"
#import "MBProgressHUD.h"
@interface ProjectMainViewController : UIViewController<MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UITableView      *projectMainTableView;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) NSMutableArray            *contacts;
@property (strong, nonatomic) NSMutableArray            *activity;
@property (strong, nonatomic) NSMutableArray            *workType;
@property (strong, nonatomic) NSMutableArray            *employee;
@property (strong, nonatomic) CompanyPreferencesObject  *companyPreferences;
@property (strong, nonatomic) NSMutableArray            *systemPhases;
@property (strong, nonatomic) NSMutableArray            *employeeList;
@property (strong, nonatomic) NSMutableArray            *windObjects;
@property (strong, nonatomic) NSMutableArray            *weatherObjects;
@property (strong, nonatomic) NSMutableArray            *projectEquipment;
@property (strong, nonatomic) MBProgressHUD           *HUD;
@end
