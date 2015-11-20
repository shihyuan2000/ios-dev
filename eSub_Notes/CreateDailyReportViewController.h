//
//  CreateDailyReportViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/15/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"
#import "CompanyPreferencesObject.h"
#import "SearchTableViewController.h"

@interface CreateDailyReportViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, SearchProtocolDelegate, UIActionSheetDelegate>

@property (assign, nonatomic) NSInteger                 projectId;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) NSMutableArray            *contacts;
@property (strong, nonatomic) NSMutableArray            *dailyReports;
@property (strong, nonatomic) NSString                  *drDate;
@property (strong, nonatomic) IBOutlet UITextField      *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField      *fromTextField;
@property (strong, nonatomic) SearchTableViewController *searchVC;
@property (strong, nonatomic) IBOutlet UIButton         *fromButton;
@property (weak, nonatomic) IBOutlet UIButton           *drCopyFromButton;
@property NSInteger                                     contactID;
@property NSInteger                                     addressID;
@property (strong, nonatomic) NSMutableArray            *windObjects;
@property (strong, nonatomic) NSMutableArray            *weatherObjects;
@property (strong, nonatomic) NSMutableArray            *activity;
@property (strong, nonatomic) NSMutableArray            *workType;
@property (strong, nonatomic) NSMutableArray            *employee;
@property (strong, nonatomic) CompanyPreferencesObject  *companyPreferences;
@property (strong, nonatomic) NSMutableArray            *systemPhases;
@property (strong, nonatomic) NSMutableArray            *employeeList;
@property (strong, nonatomic) NSMutableArray            *projectEquipment;


- (IBAction)drCopyFromButton:(id)sender;
- (IBAction)createButtonAction:(id)sender;
- (IBAction)fromButtonAction:(id)sender;


@end
