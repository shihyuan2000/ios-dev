//
//  CreateDailyReportViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/15/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "CreateDailyReportViewController.h"
#import "AppDelegate.h"
#import "SaveNoteAFHTTPClient.h"
#import "DejalActivityView.h"
#import "WeatherAFHTTPClient.h"
#import "DailyReportObject.h"
#import "Common.h"

@interface CreateDailyReportViewController ()
{
    UIDatePicker *picker1;
    NSString *username;
    NSInteger weather;
    NSInteger wind;
    NSInteger temperature;
    NSString *icon;
    DailyReportObject *copyDR;
    NSString *zipCode;
    DailyReportObject *newDR;
}
@end

@implementation CreateDailyReportViewController

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
    label.text = @"Create Daily";
    self.navigationItem.titleView = label;

    picker1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 210, 320, 216)];
    [picker1 setDatePickerMode:UIDatePickerModeDate];
    picker1.backgroundColor = [UIColor whiteColor];
    [picker1 addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    picker1.tag = 1;
    self.dateTextField.inputView  = picker1;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneDatePicker:)];
    
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, next, nil]];

    self.dateTextField.inputAccessoryView = keyboardToolbar;

//    [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"contactLastname" ascending:YES]]];
    [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"contactCompany" ascending:YES]]];

    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [[NSLocale alloc]
                            initWithLocaleIdentifier:@"en_US"]];
    [FormatDate setDateFormat:@"MM/dd/yyyy"];
    self.drDate = [FormatDate stringFromDate:[NSDate date]];
    self.dateTextField.text = [FormatDate stringFromDate:[NSDate date]];
    
    self.contactID = 0;
    self.addressID = 0;
    
    NSString *name = @"";
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    username = [appD.eSubsDB getUsername:appD.userId];
    for (ContactsObject *contact in self.contacts)
    {
        for (ContactAddressObject *contactAddress in contact.contactAddresses)
        {
            if ([[contactAddress.email lowercaseString] isEqualToString:username])
            {
                self.contactID = contact.id;
                self.addressID = contact.AddressId;
                name = [NSString stringWithFormat:@"%@ -  %@, %@", contact.contactCompany, contact.contactLastname, contact.contactFirstname];
                goto done;
            }
        }
    }
    
done:
    
    [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"contactCompany" ascending:YES]]];
    
    [self.fromButton setTitle:name forState:UIControlStateNormal];
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 7.0, 0.0, 0.0);
    self.fromButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.fromButton.titleEdgeInsets = titleInsets;
    self.fromButton.layer.cornerRadius = 5;
    self.fromButton.layer.borderWidth = .5;
    self.fromButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.drCopyFromButton setTitle:@"Select daily report to copy from" forState:UIControlStateNormal];
    self.drCopyFromButton.titleLabel.font = [UIFont systemFontOfSize:14];
    titleInsets = UIEdgeInsetsMake(0.0, 7.0, 0.0, 0.0);
    self.drCopyFromButton.titleEdgeInsets = titleInsets;
    self.drCopyFromButton.layer.cornerRadius = 5;
    self.drCopyFromButton.layer.borderWidth = .5;
    self.drCopyFromButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

// Get the weather
    NoteLocation *projectLocation = self.projectObject.projectLocation;
    if (projectLocation)
    {
        NoteAddress *address = projectLocation.address;
        zipCode = address.zip;
    }

    if (zipCode)
    {

        [Common GetWeather:zipCode
        success:^(id responseObject)
        {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSArray *mdata = [data objectForKey:@"current_condition"];
            if (mdata)
            {
                NSDictionary *ndata = [mdata objectAtIndex:0];
                weather = [[ndata objectForKey:@"weatherCode"] integerValue];
                NSInteger windSpeed = [[ndata objectForKey:@"windspeedMiles"] integerValue];
                if (windSpeed <= 2)
                {
                    wind = 1;
                }
                else if (windSpeed > 2 && windSpeed <= 15)
                {
                    wind = 2;
                }
                else if (windSpeed > 15 && windSpeed <= 22)
                {
                    wind = 3;
                }
                else if (windSpeed > 22)
                {
                    wind = 4;
                }
                else
                {
                    wind = 0;
                }
                temperature = [[ndata objectForKey:@"temp_F"] integerValue];
                NSArray *weatherIconUrl = [ndata objectForKey:@"weatherIconUrl"];
                if (weatherIconUrl.count)
                {
                    NSDictionary *val = [weatherIconUrl objectAtIndex:0];
                    icon = [val objectForKey:@"value"];
                }
            }
        }
        failure:^(NSError *error)
        {
            NSLog(@"Network error in downloading weather: %@", [error localizedDescription]);
        }];
        
    }

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

}

- (void) doneDatePicker: (id) sender
{
    
     [self.dateTextField resignFirstResponder];
    
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) dateSelected:(UIDatePicker *)datePicker
{
    
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [[NSLocale alloc]
                            initWithLocaleIdentifier:@"en_US"]];
    [FormatDate setDateFormat:@"MM-dd-yyyy"];
    self.dateTextField.text = [FormatDate stringFromDate:datePicker.date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [formatter dateFromString:self.dateTextField.text];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    [self checkDate:[formatter stringFromDate:date]];

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.contacts.count;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;

}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    ContactsObject *contacts = [self.contacts objectAtIndex:row];
    return [NSString stringWithFormat:@"%@ - %@, %@", contacts.contactCompany,  contacts.contactLastname, contacts.contactFirstname];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{

    ContactsObject *contacts = [self.contacts objectAtIndex:row];
    self.fromTextField.text = [NSString stringWithFormat:@"%@ - %@, %@", contacts.contactCompany,  contacts.contactLastname, contacts.contactFirstname];
    self.contactID = contacts.id;
    self.addressID = contacts.AddressId;
    
}

- (IBAction)createButtonAction:(id)sender
{

    if (self.contactID == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"You must select a contact (From)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NSInteger drId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewDRCount] intValue];
    drId--;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)drId] forKey:kNewDRCount];
    [[NSUserDefaults standardUserDefaults] synchronize];

    newDR = [[DailyReportObject alloc] init];
    newDR.id = drId;
    newDR.projectId = self.projectId;

//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MM-dd-yyyy"];
//    NSDate *date = [formatter dateFromString:self.dateTextField.text];
//    [formatter setDateFormat:@"MM/dd/yyyy"];
//    newDR.date = [formatter stringFromDate:date];

    newDR.date = self.dateTextField.text;
    //newDR.employeeFromId = self.contactID;
    newDR.employeeFromId = self.addressID;
    newDR.weatherId = weather;
    newDR.weatherIcon = icon;
    newDR.windId = wind;
    newDR.temperature = temperature;
    newDR.isEditable = YES;
    if (copyDR)
    {
        newDR.drCopyId = copyDR.id;
        if (copyDR.communicationWithOthers)
        {
            newDR.communicationWithOthers = copyDR.communicationWithOthers;
        }
        else
        {
            newDR.communicationWithOthers = @"";
        }
        
        if (copyDR.scheduleCoordination)
        {
            newDR.scheduleCoordination = copyDR.scheduleCoordination;
        }
        else
        {
            newDR.scheduleCoordination = @"";
        }
        
        if (copyDR.extraWork)
        {
            newDR.extraWork = copyDR.extraWork;
            newDR.extraWorkIsInternal = copyDR.extraWorkIsInternal;
        }
        else
        {
            newDR.extraWork = @"";
            newDR.extraWorkIsInternal = 0;
        }

        if (copyDR.accidentReport)
        {
            newDR.accidentReport = copyDR.accidentReport;
            newDR.accidentReportIsInternal = copyDR.accidentReportIsInternal;
        }
        else
        {
            newDR.accidentReport = @"";
            newDR.accidentReportIsInternal = 0;
        }

        if (copyDR.subcontractors)
        {
            newDR.subcontractors = copyDR.subcontractors;
            newDR.subcontractorsIsInternal = copyDR.subcontractorsIsInternal;
        }
        else
        {
            newDR.subcontractors = copyDR.subcontractors;
            newDR.subcontractorsIsInternal = 0;
        }

        if (copyDR.otherVisitors)
        {
            newDR.otherVisitors = copyDR.otherVisitors;
            newDR.otherVisitorsIsInternal = copyDR.otherVisitorsIsInternal;
        }
        else
        {
            newDR.otherVisitors = copyDR.otherVisitors;
            newDR.otherVisitorsIsInternal = 0;
        }

        if (copyDR.problems)
        {
            newDR.problems = copyDR.problems;
            newDR.problemsIsInternal = copyDR.problemsIsInternal;
        }
        else
        {
            newDR.problems = copyDR.problems;
            newDR.problemsIsInternal = 0;
        }

        if (copyDR.internal)
        {
            newDR.internal = copyDR.internal;
        }
        else
        {
            newDR.internal = @"";
        }
    }
    
    newDR.number = @"This DR has not been saved";
    if([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        newDR.weatherIcon = zipCode;
    }
    [appD.eSubsDB insertDailyReports:newDR forProjectId:self.projectId userId:appD.userId];

    [DejalBezelActivityView activityViewForView:self.view];

    [Common saveDailyReportToWebService:newDR
        success:^(id responseObject)
        {
            if (copyDR)
            {
                [Common CopyCrewEquipmentMatieralsForDailyReport:self.projectId
                                                   dailyReportId:[[responseObject objectForKey:@"Id"] integerValue]
                                                 dailyReportDate:self.drDate
                                               copyDailyReportId:copyDR.id
                                                        complete:^{
                                                            NSInteger old = newDR.id;
                                                            newDR.id = [[responseObject objectForKey:@"Id"] integerValue];
                                                            newDR.number = [responseObject objectForKey:@"Number"];
                                                            newDR.subject = [responseObject objectForKey:@"Subject"];
                                                            [appD.eSubsDB updateDailyReport:old forDR:newDR];
                                                            [self showReportTableViewController];
                                                        }];
            }
            else
            {
                [DejalBezelActivityView removeViewAnimated:YES];
                NSInteger old = newDR.id;
                newDR.id = [[responseObject objectForKey:@"Id"] integerValue];
                newDR.number = [responseObject objectForKey:@"Number"];
                newDR.subject = [responseObject objectForKey:@"Subject"];
                [appD.eSubsDB updateDailyReport:old forDR:newDR];
                [self showReportTableViewController];
            }
        }
        failure:^(NSError *error)
        {
            [DejalBezelActivityView removeViewAnimated:YES];

            if (copyDR)
            {
                [appD.eSubsDB deleteDailyReport:self.projectId forUserID:appD.userId forDRId:newDR.id];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline saving of copy DR not supported." message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                [Common CopyCrewEquipmentMatieralsForDailyReport:self.projectId
                                                   dailyReportId:newDR.id
                                                 dailyReportDate:self.drDate
                                               copyDailyReportId:copyDR.id
                                                        complete:^{
                                                            [self showReportTableViewController];
                }];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to local store" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];

}

- (void) showReportTableViewController
{
    DailyReportTableViewController *vc = [[DailyReportTableViewController alloc] initWithNibName:@"DailyReportTableViewController" bundle:nil];
    
    vc.title = [NSString stringWithFormat:@"%@ - %@", newDR.number, self.dateTextField.text];
    vc.reportName = [NSString stringWithFormat:@"%@", newDR.number];
    vc.dailyReportId = newDR.id;
    
    vc.drDate = self.dateTextField.text;
    vc.projectId = self.projectId;
    vc.dr = newDR;
    vc.activity = self.activity;
    vc.workType = self.workType;
    vc.employee = self.employee;
    vc.companyPreferences = self.companyPreferences;
    vc.systemPhases = self.systemPhases;
    vc.employeeList = self.employeeList;
    vc.windObjects = self.windObjects;
    vc.weatherObjects = self.weatherObjects;
    vc.projectEquipment = self.projectEquipment;

    newDR = nil;
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)fromButtonAction:(id)sender
{
    
    SearchTableViewController *vc = [[SearchTableViewController alloc] initWithNibName:@"SearchTableViewController" bundle:nil];
    vc.contacts = self.contacts;
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) searchCompleted: (NSUInteger) id
{

    self.contactID = id;
    for (ContactsObject *contact in self.contacts)
    {
        if (contact.id == id)
        {
            self.addressID = contact.AddressId;
            [self.fromButton setTitle:[NSString stringWithFormat:@"%@ - %@, %@", contact.contactCompany, contact.contactLastname, contact.contactFirstname] forState:UIControlStateNormal];
            break;
        }
    }
    
}

- (IBAction)drCopyFromButton:(id)sender
{
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAction;
    for (DailyReportObject *dr in self.dailyReports)
    {
/*
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [formatter dateFromString:dr.date];
        [formatter setDateFormat:@"MM/dd/yy"];
*/
        alertAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ - %@", dr.number, dr.date]
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action)
                       {
                           copyDR = dr;
                           //self.contactID = copyDR.employeeFromId;
                           self.addressID = copyDR.employeeFromId;
                           for (ContactsObject *contact in self.contacts)
                           {
                               if (contact.id == self.contactID)
                               {
                                   [self.fromButton setTitle:[NSString stringWithFormat:@"%@ - %@, %@", contact.contactCompany,  contact.contactLastname, contact.contactFirstname] forState:UIControlStateNormal];
                                   break;
                               }
                           }

//                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                           [formatter setDateFormat:@"MM-dd-yyyy"];
//                           NSDate *date = [formatter dateFromString:self.dateTextField.text];
//                           [formatter setDateFormat:@"MM/dd/yyyy"];

                           [self checkDate:self.dateTextField.text];
                           
                           [self.drCopyFromButton setTitle:[NSString stringWithFormat:@"%@ - %@", copyDR.number, dr.date] forState:UIControlStateNormal];

                       }];
        [controller addAction:alertAction];
    }
    alertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                   {
                   }];
    
    [controller addAction:alertAction];
    
    UIPopoverPresentationController *popPresenter = [controller popoverPresentationController];
    popPresenter.sourceView = (UIButton *)sender;
    popPresenter.sourceRect = [(UIButton *)sender bounds];
    
    [self presentViewController:controller animated:YES completion:^{[DejalBezelActivityView removeViewAnimated:YES];}];
    
}

- (void) checkDate: (NSString *) date
{
    
    if (zipCode)
    {

        [Common GetPastWeather:zipCode forDate:date
         success:^(id responseObject)
         {
             NSDictionary *data = [responseObject objectForKey:@"data"];
             NSArray *w = [data objectForKey:@"weather"];
             if (w.count > 0)
             {
                 NSDictionary *ndata = [w objectAtIndex:0];
                 NSArray *h = [ndata objectForKey:@"hourly"];
                 if (h.count > 4)
                 {
                     NSDictionary *hourly = [h objectAtIndex:4];
                     weather = [[hourly objectForKey:@"weatherCode"] integerValue];
                     NSInteger windSpeed = [[hourly objectForKey:@"windspeedMiles"] integerValue];
                     if (windSpeed <= 2)
                     {
                         wind = 1;
                     }
                     else if (windSpeed > 2 && windSpeed <= 15)
                     {
                         wind = 2;
                     }
                     else if (windSpeed > 15 && windSpeed <= 22)
                     {
                         wind = 3;
                     }
                     else if (windSpeed > 22)
                     {
                         wind = 4;
                     }
                     else
                     {
                         wind = 0;
                     }
                     temperature = [[hourly objectForKey:@"tempF"] integerValue];
                     NSArray *weatherIconUrl = [hourly objectForKey:@"weatherIconUrl"];
                     if (weatherIconUrl.count)
                     {
                         NSDictionary *val = [weatherIconUrl objectAtIndex:0];
                         icon = [val objectForKey:@"value"];
                     }

                 }
             }
             NSLog(@"weather : %ld", (long)weather);
             NSLog(@"wind : %ld", (long)wind);
             NSLog(@"temperature : %ld", (long)temperature);
             NSLog(@"icon :%@", icon);
         }
         failure:^(NSError *error)
         {
             NSLog(@"Network error in downloading weather: %@", [error localizedDescription]);
         }];
        
    }

}

@end
