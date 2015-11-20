//
//  CrewEntryTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/8/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "CrewEntryTableViewController.h"
#import "EmployeeObject.h"
#import "ActivityObject.h"
#import "SystemPhase.h"
#import "CompanyPreferencesObject.h"
#import "WorkTypeObject.h"
#import "AppDelegate.h"
#import "SaveNoteAFHTTPClient.h"
#import "DejalActivityView.h"
#import "AddEmployeeTableViewController.h"
#import "Common.h"

@interface CrewEntryTableViewController ()
{
    
    NSInteger workTypeId;
    NSInteger phaseNumberId;
    NSInteger systemId;
    NSString *activityCode;
    NSInteger activityId;
    UIButton *systemPhaseButton;
    UIButton *activityButton;
    UIButton *workTypeButton;
    UIButton *employeeButton;

    NSInteger systemPhaseRowIndex;
    NSInteger activityRowIndex;
    NSInteger workTypeRowIndex;
    NSInteger employeeRowIndex;
    NSInteger timeRowIndex;
    NSInteger unitsRowIndex;
    NSInteger hoursLostRowIndex;
    NSInteger commentsRowIndex;
    
    NSInteger numberOfRows;
}
@end

@implementation CrewEntryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self addButtonSaveEdit];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = [NSString stringWithFormat:@"Crew Log Daily Report %@", self.reportName];
    self.navigationItem.titleView = label;

    self.existingCrews = [Common buildExistingCrewRows:self.crewList];
    
    if (self.newEntry)
    {
        systemId = 0;
        activityCode = @"";
        workTypeId = 1; // Default to Base Contract
    }
    else
    {
        systemId = self.crew.phaseId;
        phaseNumberId = self.crew.phaseId;
        activityCode =  [self getActivity:self.crew.laborActivityId];
        activityId = self.crew.laborActivityId;
        workTypeId = self.crew.workTypeId;
    }
    
    numberOfRows = 8;
    systemPhaseRowIndex = -1;
    activityRowIndex = 1;
    workTypeRowIndex = 2;
    employeeRowIndex = 3;
    timeRowIndex = 4;
    unitsRowIndex = 5;
    hoursLostRowIndex = 6;
    commentsRowIndex = 7;

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if (self.employeeList.count)
    {
        NSString *names;
        int cnt = 0;
        for (NSNumber *employeeNumber in self.employeeList)
        {
            if (cnt)
            {
                names = [names stringByAppendingFormat:@", %@", [self getEmployee:[employeeNumber intValue]]];
            }
            else
            {
                names = [self getEmployee:[employeeNumber intValue]];
            }
            cnt++;
        }
        self.employeeInit = names;
        [self.tableView reloadData];
    }

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear)
//                                                 name:UIKeyboardWillHideNotification object:nil];

    numberOfRows = 8;
    systemPhaseRowIndex = 0;
    activityRowIndex = 1;
    workTypeRowIndex = 2;
    employeeRowIndex = 3;
    timeRowIndex = 4;
    unitsRowIndex = 5;
    hoursLostRowIndex = 6;
    commentsRowIndex = 7;
    
    if (self.systemPhases.count == 1)
    {
        SystemPhase *systemPhase = [self.systemPhases objectAtIndex:0];
        phaseNumberId = systemPhase.phaseId;
        systemId = systemPhase.systemId;
        numberOfRows--;
        systemPhaseRowIndex = -1;
        activityRowIndex = 0;
        workTypeRowIndex = 1;
        employeeRowIndex = 2;
        timeRowIndex = 3;
        unitsRowIndex = 4;
        hoursLostRowIndex = 5;
        commentsRowIndex = 6;
    }
    if (!self.companyPreferences.dailyReportUnitTrackingEnabled)
    {
        numberOfRows--;
        unitsRowIndex = -1;
        hoursLostRowIndex--;
        commentsRowIndex--;
    }
    
    [self.tableView reloadData];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addButtonSaveEdit
{

    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sButton.layer.borderWidth = 1;
//    sButton.layer.borderColor = [UIColor whiteColor].CGColor;
    sButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (self.newEntry)
    {
        [sButton setTitle:@"Save" forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [sButton setTitle:@"Update" forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(updateDetails) forControlEvents:UIControlEventTouchUpInside];
    }

    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    if (self.dr.isEditable)
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:save, nil];
    }

}

- (void) keyboardDidAppear
{
    
    //self.navigationItem.rightBarButtonItem = nil;

}

- (void) keyboardWillDisappear
{
    
//    [self addButtonSaveEdit];

}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (NSString *) getEmployee: (NSInteger) id
{
    
    for (EmployeeObject *employee in self.employee)
    {
        if (employee.id == id)
        {
            return [NSString stringWithFormat:@"%@ %@", employee.firstName, employee.lastName];
        }
    }
    
    return nil;
    
}

- (NSString *) getActivity: (NSInteger) id
{
    
    for (ActivityObject *activity in self.activity)
    {
        if (activity.id == id)
        {
            return activity.name;
        }
    }
    
    return nil;
    
}

- (void) updateDetails
{
    self.existingCrews = nil;
    [self.crewList removeObject:self.crew];
    self.existingCrews = [Common buildExistingCrewRows:self.crewList];
    [self saveDetails];

}

- (void) saveDetails
{
    [self.view endEditing:YES];
    if (systemId == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"You must select a System/Phase" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (activityCode.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"You must select an Activity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.employeeList.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"You must select at least 1 crew member" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.crewHoursLost != 0 && self.crewComments.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"If you have a Hours Lost value you must have a comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    for (NSDictionary *crew in self.existingCrews)
    {
        if ([[crew objectForKey:@"systemPhase"] integerValue] == phaseNumberId &&
            [[crew objectForKey:@"laborActivity"] integerValue] == activityId &&
            [[crew objectForKey:@"workType"] integerValue] == workTypeId)
        {
            NSMutableArray *rows = [crew objectForKey:@"rows"];
            for (NSDictionary *row in rows)
            {
                NSArray *crewMembers = [row objectForKey:@"crewMembers"];
                if (crewMembers.count > 0)
                {
                    NSUInteger crewMemeberId = [[crewMembers objectAtIndex:0] integerValue];
                    for (NSNumber *id in self.employeeList)
                    {
                        if ([id integerValue] == crewMemeberId)
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"You can not add an existing crew member to an existing crew." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            return;
                        }
                    }
                }
            }
        }
    }

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    [DejalBezelActivityView activityViewForView:self.view];

    NSMutableDictionary *row = [NSMutableDictionary dictionary];
    
    if (!self.existingCrews)
    {
        self.existingCrews = [[NSMutableArray alloc] init];
    }

    [row setObject:[NSNumber numberWithFloat:self.crewHours1x] forKey:@"hoursST"];
    [row setObject:[NSNumber numberWithFloat:self.crewHours1_5x] forKey:@"hoursOT"];
    [row setObject:[NSNumber numberWithFloat:self.crewHours2x] forKey:@"hoursDT"];
    [row setObject:[NSNumber numberWithFloat:self.crewHoursLost] forKey:@"hoursLost"];
    [row setObject:[NSNumber numberWithInteger:self.crewUnits] forKey:@"units"];
    if (self.crewComments)
    {
        [row setObject:(self.crewComments.length>500?[self.crewComments substringToIndex:500]:self.crewComments) forKey:@"comments"];
    }
    else
    {
        [row setObject:@"" forKey:@"comments"];
    }
    [row setObject:[NSNumber numberWithInteger:self.employeeList.count] forKey:@"crewNumber"];
    [row setObject:self.employeeList forKey:@"crewMembers"];

    NSInteger saveId = [self addRow:row toCrew:self.existingCrews];

    [Common saveCrewsToWebService:self.existingCrews forProjectId:self.projectId forDRId:self.dailyReportId forDate:self.drDate forId: (NSInteger) saveId
        success:^(id responseObject)
        {
            [appD.eSubsDB deleteCrewObject:self.projectId forDailyReportId:(NSInteger)responseObject];
            [DejalBezelActivityView removeViewAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        failure:^(NSError *error)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to local store" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
//            [self.navigationController popViewControllerAnimated:YES];
        }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == commentsRowIndex)
    {
        return 200;
    }
    else
    {
        return 60;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.companyPreferences.dailyReportUnitTrackingEnabled)
    {
        return 8;
    }
    else
    {
        return 7;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    float cellWidth;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleBlackOpaque;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resetView)];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    
    if (indexPath.row == 4)
    {
        cellWidth = 100;
    }
    else
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            if (orientation == UIInterfaceOrientationPortrait)
            {
                cellWidth = 650;
            }
            else
            {
                cellWidth = 900;
            }
        }
        else
        {
            if (orientation == UIInterfaceOrientationPortrait)
            {
                cellWidth = 250;
            }
            else
            {
                cellWidth = 480;
            }
        }
    }
    
    UILabel *titleLabel;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 4, cellWidth, 43)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.row == systemPhaseRowIndex)
    {
        titleLabel.text = self.systemPhaseInit;
        if (self.newEntry)
        {
            systemPhaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            systemPhaseButton.tag = 1;
            systemPhaseButton.frame = CGRectMake(cellWidth, 5, 40, 40);
            UIImage *btnImage = [UIImage imageNamed:@"arrow_down.png"];
            [systemPhaseButton setImage:btnImage forState:UIControlStateNormal];
            [systemPhaseButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:systemPhaseButton];
        }
    }
    if (indexPath.row == activityRowIndex)
    {
        titleLabel.text = self.activityInit;
        if (self.newEntry)
        {
            activityButton = [UIButton buttonWithType:UIButtonTypeCustom];
            activityButton.tag = 2;
            activityButton.frame = CGRectMake(cellWidth, 5, 40, 40);
            UIImage *btnImage = [UIImage imageNamed:@"arrow_down.png"];
            [activityButton setImage:btnImage forState:UIControlStateNormal];
            [activityButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:activityButton];
        }
    }
    if (indexPath.row == workTypeRowIndex)
    {
        titleLabel.text = self.workTypeInit;
        if (self.newEntry)
        {
            workTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            workTypeButton.tag = 3;
            workTypeButton.frame = CGRectMake(cellWidth, 5, 40, 40);
            UIImage *btnImage = [UIImage imageNamed:@"arrow_down.png"];
            [workTypeButton setImage:btnImage forState:UIControlStateNormal];
            [workTypeButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:workTypeButton];
        }
        
    }
    if (indexPath.row == employeeRowIndex)
    {
        titleLabel.text = self.employeeInit;
        if (self.newEntry)
        {
            employeeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            employeeButton.tag = 4;
            employeeButton.frame = CGRectMake(cellWidth, 5, 40, 40);
            UIImage *btnImage = [UIImage imageNamed:@"arrow_down.png"];
            [employeeButton setImage:btnImage forState:UIControlStateNormal];
            [employeeButton addTarget:self action:@selector(addEmployee) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:employeeButton];
        }
    }
    if (indexPath.row == timeRowIndex)
    {
        titleLabel.text = @"Time";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 4, 15, 15)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = @"1x";
        [cell.contentView addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 20, 50, 30)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.font = [UIFont systemFontOfSize:17];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tag = 1;
        textField.delegate = self;
        if (self.crewHours1x)
        {
            textField.text = [NSString stringWithFormat:@"%.2f", self.crewHours1x];
        }
        textField.inputAccessoryView = toolbar;
        [cell.contentView addSubview:textField];
        
        if (self.companyPreferences.dailyReportOvertimeEnabled)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170, 4, 30, 15)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:12];
            label.text = @"1.5x";
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 20, 50, 30)];
            textField.borderStyle = UITextBorderStyleLine;
            textField.font = [UIFont systemFontOfSize:17];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.tag = 2;
            textField.delegate = self;
            if (self.crewHours1_5x)
            {
                textField.text = [NSString stringWithFormat:@"%.2f", self.crewHours1_5x];
            }
            textField.inputAccessoryView = toolbar;
            [cell.contentView addSubview:textField];
        }
        if (self.companyPreferences.dailyReportDoubleTimeEnabled)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(240, 4, 30, 15)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:12];
            label.text = @"2x";
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(220, 20, 50, 30)];
            textField.borderStyle = UITextBorderStyleLine;
            textField.font = [UIFont systemFontOfSize:17];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.tag = 3;
            textField.delegate = self;
            if (self.crewHours2x)
            {
                textField.text = [NSString stringWithFormat:@"%.2f", self.crewHours2x];
            }
            textField.inputAccessoryView = toolbar;
            [cell.contentView addSubview:textField];
        }
        
    }
    if (indexPath.row == unitsRowIndex)
    {
        titleLabel.text = @"Units";
        if (self.companyPreferences.dailyReportOvertimeEnabled)
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 50, 30)];
            textField.borderStyle = UITextBorderStyleLine;
            textField.font = [UIFont systemFontOfSize:17];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.tag = 4;
            textField.delegate = self;
            if (self.crewUnits)
            {
                textField.text = [NSString stringWithFormat:@"%.2f", self.crewUnits];
            }
            textField.inputAccessoryView = toolbar;
            [cell.contentView addSubview:textField];
        }
    }
    if (indexPath.row == hoursLostRowIndex)
    {
        titleLabel.text = @"Hours Lost";
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 50, 30)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.font = [UIFont systemFontOfSize:17];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tag = 5;
        textField.delegate = self;
        if (self.crewHoursLost)
        {
            textField.text = [NSString stringWithFormat:@"%.2f", self.crewHoursLost];
        }
        
        textField.inputAccessoryView = toolbar;
        [cell.contentView addSubview:textField];
    }
    if (indexPath.row == commentsRowIndex)
    {
        titleLabel.text = @"Comments:";
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 50, cellWidth, 150)];
        [[textView layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[textView layer] setBorderWidth:2];
        textView.font = [UIFont systemFontOfSize:17];
        textView.keyboardType = UIKeyboardTypeDefault;
        textView.textAlignment = NSTextAlignmentLeft;
        textView.tag = 6;
        textView.delegate = self;
        if (self.crewComments)
        {
            textView.text = self.crewComments;
        }
        
        textView.inputAccessoryView = toolbar;
        [cell.contentView addSubview:textView];
        
    }

    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == systemPhaseRowIndex)
    {
        if (self.newEntry)
        {
            [self showPopover:systemPhaseButton];
        }
    }
    else if (indexPath.row == activityRowIndex)
    {
        if (self.newEntry)
        {
            [self showPopover:activityButton];
        }
    }
    else if (indexPath.row == workTypeRowIndex)
    {
        if (self.newEntry)
        {
            [self showPopover:workTypeButton];
        }
    }
    else if (indexPath.row == employeeRowIndex)
    {
        [self addEmployee];
    }
    
}

- (NSInteger) addRow:(NSMutableDictionary *) row toCrew: (NSMutableArray *) crews
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    NSInteger crewId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewCrewCount] intValue];
    crewId--;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)crewId] forKey:kNewCrewCount];
    [[NSUserDefaults standardUserDefaults] synchronize];

    for (NSDictionary *crew in crews)
    {
        if ([[crew objectForKey:@"systemPhase"] integerValue] == phaseNumberId &&
            [[crew objectForKey:@"laborActivity"] integerValue] == activityId &&
            [[crew objectForKey:@"workType"] integerValue] == workTypeId)
        {
            NSMutableArray *rows = [crew objectForKey:@"rows"];
            [rows addObject:row];
            
            NSArray *r = [row objectForKey:@"crewMembers"];
            for (int i = 0; i < r.count; i++)
            {
                CrewObject *c = [[CrewObject alloc] init];
                c.employeeId = [[r objectAtIndex:i] integerValue];
                c.id = crewId;
                c.crewId = [[crew objectForKey:@"crewId"] integerValue];
                c.dailyReportId = self.dailyReportId;
                c.hoursST = [[row objectForKey:@"hoursST"] doubleValue];
                c.hoursOT = [[row objectForKey:@"hoursOT"] doubleValue];
                c.hoursDT = [[row objectForKey:@"hoursDT"] doubleValue];
                c.hoursLost = [[row objectForKey:@"hoursLost"] doubleValue];
                c.units = [[crew objectForKey:@"totalUnits"] integerValue];
                c.comments = [row objectForKey:@"comments"];
                //            c.crewName = [crew objectForKey:@"CrewName"];
                c.laborActivityId = activityId;
                c.workTypeId = workTypeId;
                c.phaseId = phaseNumberId;
                c.totalUnits = [[crew objectForKey:@"TotalUnits"] integerValue];
                c.projectId = self.projectId;
                c.drDate = self.drDate;
                c.crewName = @"This crew has not been saved";
                [appD.eSubsDB insertCrewObject:c forProjectId:self.projectId userId:appD.userId];
            }
            return crewId;
        }
    }
    
    NSMutableDictionary *crew = [NSMutableDictionary dictionary];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    [rows addObject:row];
    
    if (self.crewId)
    {
        [crew setObject:[NSNumber numberWithInteger:self.crewId] forKey:@"crewId"];
    }
    if (systemId)
    {
        [crew setObject:[NSNumber numberWithInteger:phaseNumberId] forKey:@"systemPhase"];
    }
    if (activityCode.length > 0)
    {
        [crew setObject:[NSNumber numberWithInteger:activityId] forKey:@"laborActivity"];
    }
    if (workTypeId)
    {
        [crew setObject:[NSNumber numberWithInteger:workTypeId] forKey:@"workType"];
    }
    [crew setObject:[NSNumber numberWithInteger:self.crewUnits] forKey:@"totalUnits"];
    [crew setObject:rows forKey:@"rows"];
    
    [crews addObject:crew];

    NSArray *r = [row objectForKey:@"crewMembers"];
    for (int i = 0; i < r.count; i++)
    {
        CrewObject *c = [[CrewObject alloc] init];
        c.employeeId = [[r objectAtIndex:i] integerValue];
        c.id = crewId;
        c.crewId = [[crew objectForKey:@"crewId"] integerValue];
        c.dailyReportId = self.dailyReportId;
        c.hoursST = [[row objectForKey:@"hoursST"] doubleValue];
        c.hoursOT = [[row objectForKey:@"hoursOT"] doubleValue];
        c.hoursDT = [[row objectForKey:@"hoursDT"] doubleValue];
        c.hoursLost = [[row objectForKey:@"hoursLost"] doubleValue];
        c.units = [[crew objectForKey:@"totalUnits"] integerValue];
        c.comments = [row objectForKey:@"comments"];
        c.laborActivityId = activityId;
        c.workTypeId = workTypeId;
        c.phaseId = phaseNumberId;
        c.totalUnits = [[crew objectForKey:@"TotalUnits"] integerValue];
        c.drDate = self.drDate;
        c.crewName = @"This crew has not been saved";
        [appD.eSubsDB insertCrewObject:c forProjectId:self.projectId userId:appD.userId];
    }

    return crewId;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag == 1)
    {
        self.crewHours1x = [textField.text floatValue];
    }
    if (textField.tag == 2)
    {
        self.crewHours1_5x = [textField.text floatValue];
    }
    if (textField.tag == 3)
    {
        self.crewHours2x = [textField.text floatValue];
    }
    if (textField.tag == 4)
    {
        self.crewUnits = [textField.text floatValue];
    }
    if (textField.tag == 5)
    {
        self.crewHoursLost = [textField.text floatValue];
    }

}

- (void)resetView
{
    
    [self.view endEditing:YES];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    self.crewComments = textView.text;
    
}


-(void) showPopover:(id)sender
{

    self.button = sender;
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if (self.button.tag == 1)
    {
        UIAlertAction *alertAction;
        for (SystemPhase *systemPhase in self.systemPhases)
        {
            alertAction = [UIAlertAction actionWithTitle:
                              [NSString stringWithFormat:@"%@/%@", systemPhase.systemName, systemPhase.phaseName]
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action)
                                                {
                                                    self.systemPhaseInit = [NSString stringWithFormat:@"%@/%@", systemPhase.systemName, systemPhase.phaseName ];
                                                    phaseNumberId = systemPhase.phaseId;
                                                    systemId = systemPhase.systemId;
                                                    [self.tableView reloadData];
                                                }];
            [controller addAction:alertAction];
        }
        alertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                       {
                       }];
        [controller addAction:alertAction];
    }
    else if (self.button.tag == 2)
    {
        UIAlertAction *alertAction;
        for (ActivityObject *activity in self.activity)
        {
            alertAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@--%@", activity.code, activity.name] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
            {
                self.activityInit = [NSString stringWithFormat:@"%@--%@", activity.code, activity.name];
                activityCode = activity.code;
                activityId = activity.id;
                [self.tableView reloadData];
            }];
            [controller addAction:alertAction];
        }
        alertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                       {
                       }];
        [controller addAction:alertAction];
    }
    else if (self.button.tag == 3)
    {
        UIAlertAction *alertAction;
        for (WorkTypeObject *work in self.workType)
        {
            alertAction = [UIAlertAction actionWithTitle:work.type style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
            {
                self.workTypeInit = work.type;
                workTypeId = work.id;
                [self.tableView reloadData];
            }];
            [controller addAction:alertAction];
        }
        alertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                       {
                       }];
        [controller addAction:alertAction];
    }

    UIPopoverPresentationController *popPresenter = [controller popoverPresentationController];
    popPresenter.sourceView = (UIButton *)sender;
    popPresenter.sourceRect = [(UIButton *)sender bounds];
    
    [self presentViewController:controller animated:YES completion:^{[DejalBezelActivityView removeViewAnimated:YES];}];

}

- (void) addEmployee
{
    
    AddEmployeeTableViewController *vc = [[AddEmployeeTableViewController alloc] initWithNibName:@"AddEmployeeTableViewController" bundle:nil];
    
    if (!self.newEntry)
    {
        vc.employee = self.employee;
    }
    else
    {
        vc.employee = [NSMutableArray arrayWithArray:self.employee];
        for (NSDictionary *crew in self.existingCrews)
        {
            if ([[crew objectForKey:@"systemPhase"] integerValue] == phaseNumberId &&
                [[crew objectForKey:@"laborActivity"] integerValue] == activityId &&
                [[crew objectForKey:@"workType"] integerValue] == workTypeId)
            {
                NSMutableArray *rows = [crew objectForKey:@"rows"];
                for (NSDictionary *row in rows)
                {
                    NSArray *crewMembers = [row objectForKey:@"crewMembers"];
                    if (crewMembers.count > 0)
                    {
                        NSUInteger crewMemeberId = [[crewMembers objectAtIndex:0] integerValue];
                        for (EmployeeObject *employee in vc.employee)
                        {
                            if (employee.id == crewMemeberId)
                            {
                                NSLog(@"Removing employee %@ %@", employee.firstName, employee.lastName);
                                [vc.employee removeObject:employee];
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    vc.employeeList = self.employeeList;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
 
    [self.tableView reloadData];

}

@end
