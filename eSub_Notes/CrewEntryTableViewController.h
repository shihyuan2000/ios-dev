//
//  CrewEntryTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/8/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrewObject.h"
#import "CompanyPreferencesObject.h"
#import "DailyReportObject.h"

@interface CrewEntryTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString                  *reportName;
@property (strong, nonatomic) UIButton                  *button;
@property NSInteger                                     projectId;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) NSString                  *drDate;
@property (strong, nonatomic) DailyReportObject         *dr;

@property (strong, nonatomic) NSMutableArray            *activity;
@property (strong, nonatomic) NSMutableArray            *workType;
@property (strong, nonatomic) NSMutableArray            *employee;
@property (strong, nonatomic) CompanyPreferencesObject  *companyPreferences;
@property (strong, nonatomic) NSMutableArray            *systemPhases;
@property (strong, nonatomic) NSMutableArray            *employeeList;
@property (strong, nonatomic) NSMutableArray            *crewList;

@property (strong, nonatomic) CrewObject                *crew;
@property NSInteger                                     crewId;
@property float                                         crewHours1x;
@property float                                         crewHours1_5x;
@property float                                         crewHours2x;
@property float                                         crewUnits;
@property float                                         crewHoursLost;
@property (strong, nonatomic) NSString                  *crewComments;

@property (strong, nonatomic) NSString                  *systemPhaseInit;
@property (strong, nonatomic) NSString                  *activityInit;
@property (strong, nonatomic) NSString                  *workTypeInit;
@property (strong, nonatomic) NSString                  *employeeInit;

@property BOOL                                          newEntry;

@property (strong, nonatomic) NSMutableArray            *existingCrews;

@end
