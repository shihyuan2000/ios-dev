//
//  DailyReportLogTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/7/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "DailyReportLogTableViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import <PSPDFKit/PSPDFKit.h>
#import "CreateDailyReportViewController.h"
#import "Common.h"
#import "ContactsObject.h"
#import "SaveNoteAFHTTPClient.h"
#import "DailyReportCustomTableViewCell.h"

@interface DailyReportLogTableViewController ()
{
    SWTableViewCell *currentCell;
    DailyReportObject *newDR;
}
@end

@implementation DailyReportLogTableViewController

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

    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    sButton.frame = CGRectMake(0, 0, 40, 40);
    sButton.tintColor = [UIColor blackColor];
    [sButton addTarget:self action:@selector(addDR) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, nil];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
//    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, nil];

    
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

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadDR:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Daily Report Log";
    self.navigationItem.titleView = label;
   
    // Force contacts to be downloaded the first time.
//    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
//    [appD.eSubsDB deleteContactObjects:self.projectId];
    
//    [self startGettingData];

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [self startGettingData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) reloadDR:(UIRefreshControl *)refreshControl
{
    
    [self startGettingData];
    [refreshControl endRefreshing];
    
}

- (void) editAction
{
    
    [self.tableView setEditing:YES];
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editBarButtonItem, nil];
    
}

- (void) doneAction
{
    
    [self.tableView setEditing:NO];
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    sButton.frame = CGRectMake(0, 0, 40, 40);
    sButton.tintColor = [UIColor blackColor];
    [sButton addTarget:self action:@selector(addDR) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    
}

- (void) addDR
{
    
    CreateDailyReportViewController *vc = [[CreateDailyReportViewController alloc] initWithNibName:@"CreateDailyReportViewController" bundle:nil];
    vc.projectId = self.projectId;
    vc.contacts = self.contacts;
    vc.projectObject = self.projectObject;
    vc.dailyReports = self.dailyReports;
    vc.contactID = 0;
    vc.activity = self.activity;
    vc.workType = self.workType;
    vc.employee = self.employee;
    vc.companyPreferences = self.companyPreferences;
    vc.systemPhases = self.systemPhases;
    vc.employeeList = self.employeeList;
    vc.windObjects = self.windObjects;
    vc.weatherObjects = self.weatherObjects;
    vc.projectEquipment = self.projectEquipment;

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) startGettingData
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];


    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.dailyReports = [appD.eSubsDB getDailyReports:appD.userId forProjectId:self.projectId];
        [self.tableView reloadData];
    }
    else
    {
        [self getDailyReports];
    }

}

- (void) getDailyReports
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    [DejalBezelActivityView activityViewForView:self.view];

    [Common getDailyReports:self.projectId
        success:^(NSMutableArray *dailyReports)
        {
            [appD.eSubsDB deleteDailyReports:self.projectId forUserID:appD.userId];
            for (DailyReportObject *dr in dailyReports)
            {
                [appD.eSubsDB insertDailyReports:dr forProjectId:self.projectId userId:appD.userId];
            }
            self.dailyReports = dailyReports;
            [DejalBezelActivityView removeViewAnimated:YES];
            [self.tableView reloadData];
        }
        failure:^(NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            NSLog(@"Network error in download Daily Reports: %@", [error localizedDescription]);
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger code = [httpResponse statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            if (code == 404)
            {
                NSDictionary *data = [JSON objectForKey:@"exception"];
                NSString *message = [data objectForKey:@"message"];
                if ([message isEqualToString:@"No DRs have been found"])
                {
                    [appD.eSubsDB deleteDailyReports:self.projectId forUserID:appD.userId];
                    self.dailyReports = nil;
                    [self.tableView reloadData];
                    [DejalBezelActivityView removeViewAnimated:YES];
                    return;
                }
            }
            [DejalBezelActivityView removeViewAnimated:YES];
        }];

}

- (NSString *) getContactName:(NSInteger) id
{

    for (ContactsObject *contact in self.contacts)
    {
        if (contact.AddressId == id)
        {
            return [NSString stringWithFormat:@" %@ %@", contact.contactFirstname, contact.contactLastname];
        }
    }
    
    return @"";

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dailyReports.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

/*
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.leftUtilityButtons = [self leftButtons];
        cell.delegate = self;
    }
 
    DailyReportObject *dr = [self.dailyReports objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", dr.number, dr.date];

    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Submitted by: %@", [self getContactName:dr.employeeFromId]];
    
    if (dr.isEditable)
    {
        cell.imageView.image = [UIImage imageNamed:@"pencil.png"];
    }
*/
    
    DailyReportCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    if (cell == nil)
    {
        
        [tableView registerNib:[UINib nibWithNibName:@"DailyReportLogCustomCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
        
    }

    DailyReportObject *dr = [self.dailyReports objectAtIndex:indexPath.row];

    cell.customTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.customTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", dr.number, dr.date];
    cell.customSubtitleLabel.font = [UIFont systemFontOfSize:15];
    cell.customSubtitleLabel.text = [NSString stringWithFormat:@"From: %@", [self getContactName:dr.employeeFromId]];
    if (dr.isEditable)
    {
        cell.customImageView.image = [UIImage imageNamed:@"pencil.png"];
    }

    return cell;

}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0] title:@"Copy"];
    return leftUtilityButtons;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DailyReportTableViewController *vc = [[DailyReportTableViewController alloc] initWithNibName:@"DailyReportTableViewController" bundle:nil];

    DailyReportObject *dr = [self.dailyReports objectAtIndex:indexPath.row];
    vc.dr = dr;
    vc.dailyReports = self.dailyReports;
    
// LTS - 2/9/2014 This is for a bug in the API which will only handle dates in the format MM/dd/yy needs to be able to excpet the data in GMT format.
/*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:dr.date];
    [formatter setDateFormat:@"MM/dd/yy"];

    vc.title = [NSString stringWithFormat:@"%@ - %@", dr.number, [formatter stringFromDate:date]];
    vc.drDate = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
*/
    vc.title = [NSString stringWithFormat:@"%@ - %@", dr.number, dr.date];
    vc.drDate = [NSString stringWithFormat:@"%@", dr.date];
    vc.reportName = [NSString stringWithFormat:@"%@", dr.number];
    vc.dailyReportId = dr.id;
    vc.projectId = self.projectId;
    vc.projectObject = self.projectObject;
    vc.activity = self.activity;
    vc.workType = self.workType;
    vc.employee = self.employee;
    vc.companyPreferences = self.companyPreferences;
    vc.systemPhases = self.systemPhases;
    vc.employeeList = self.employeeList;
    vc.windObjects = self.windObjects;
    vc.weatherObjects = self.weatherObjects;
    vc.projectEquipment = self.projectEquipment;

    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    
    currentCell = cell;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Copy Daily Report" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {

        NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
        DailyReportObject *dr = [self.dailyReports objectAtIndex:indexPath.row];
        
        [DejalBezelActivityView activityViewForView:self.view];
        
        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        
        [data setObject:[NSNumber numberWithInteger:self.projectId] forKey:@"ProjectId"];
        NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setLocale: [[NSLocale alloc]
                                initWithLocaleIdentifier:@"en_US"]];
        [FormatDate setDateFormat:@"MM-dd-yyyy"];
        NSString *d = [FormatDate stringFromDate:[NSDate date]];
        [data setObject:d forKey:@"drDate"];
        
        [data setObject:[NSNumber numberWithInteger:dr.employeeFromId] forKey:@"drFrom"];
        [data setObject:[NSNumber numberWithInteger:dr.weatherId] forKey:@"Weather"];
        [data setObject:[NSNumber numberWithInteger:dr.windId] forKey:@"Wind"];
        [data setObject:[NSNumber numberWithInteger:dr.temperature ] forKey:@"Temperature"];
        if (dr.weatherIcon)
        {
            [data setObject:dr.weatherIcon forKey:@"WeatherIconValue"];
        }
        else
        {
            [data setObject:@"" forKey:@"WeatherIconValue"];
        }

        NSMutableDictionary *comments = [NSMutableDictionary dictionary];
        
        if (dr.communicationWithOthers)
        {
            [comments setObject:dr.communicationWithOthers forKey:@"CommunicationWithOthers"];
        }
        else
        {
            [comments setObject:@"" forKey:@"CommunicationWithOthers"];
        }
        
        if (dr.scheduleCoordination)
        {
            [comments setObject:dr.scheduleCoordination forKey:@"ScheduleCoordination"];
        }
        else
        {
            [comments setObject:@"" forKey:@"ScheduleCoordination"];
        }
        
        NSMutableDictionary *extraWork = [NSMutableDictionary dictionary];
        if (dr.extraWork)
        {
            [extraWork setObject:dr.extraWork forKey:@"Comment"];
            [extraWork setObject:[NSNumber numberWithInteger:dr.extraWorkIsInternal] forKey:@"isInternal"];
        }
        else
        {
            [extraWork setObject:@""forKey:@"Comment"];
            [extraWork setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
        }
        [comments setObject:extraWork forKey:@"ExtraWork"];
        
        NSMutableDictionary *accidentReport = [NSMutableDictionary dictionary];
        if (dr.accidentReport)
        {
            [accidentReport setObject:dr.accidentReport forKey:@"Comment"];
            [accidentReport setObject:[NSNumber numberWithInteger:dr.accidentReportIsInternal] forKey:@"isInternal"];
        }
        else
        {
            [accidentReport setObject:@"" forKey:@"Comment"];
            [accidentReport setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
        }
        [comments setObject:accidentReport forKey:@"AccidentReport"];
        
        NSMutableDictionary *subcontractors = [NSMutableDictionary dictionary];
        if (dr.subcontractors)
        {
            [subcontractors setObject:dr.subcontractors forKey:@"Comment"];
            [subcontractors setObject:[NSNumber numberWithInteger:dr.subcontractorsIsInternal] forKey:@"isInternal"];
        }
        else
        {
            [subcontractors setObject:@"" forKey:@"Comment"];
            [subcontractors setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
        }
        [comments setObject:subcontractors forKey:@"Subcontractors"];
        
        NSMutableDictionary *otherVisitors = [NSMutableDictionary dictionary];
        if (dr.otherVisitors)
        {
            [otherVisitors setObject:dr.otherVisitors forKey:@"Comment"];
            [otherVisitors setObject:[NSNumber numberWithInteger:dr.otherVisitorsIsInternal] forKey:@"isInternal"];
        }
        else
        {
            [otherVisitors setObject:@"" forKey:@"Comment"];
            [otherVisitors setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
        }
        [comments setObject:otherVisitors forKey:@"OtherVisitors"];
        
        NSMutableDictionary *problems = [NSMutableDictionary dictionary];
        if (dr.problems)
        {
            [problems setObject:dr.problems forKey:@"Comment"];
            [problems setObject:[NSNumber numberWithInteger:dr.problemsIsInternal] forKey:@"isInternal"];
        }
        else
        {
            [problems setObject:@"" forKey:@"Comment"];
            [problems setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
        }
        [comments setObject:problems forKey:@"Problems"];
        
        if (dr.internal)
        {
            [comments setObject:dr.internal forKey:@"Internal"];
        }
        else
        {
            [comments setObject:@"" forKey:@"Internal"];
        }
        
        [data setObject:comments forKey:@"Comments"];
        
        [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
        NSURLRequest *request = [client requestWithMethod:@"POST" path:@"DR" parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
            {
                newDR = [[DailyReportObject alloc] init];
                newDR.id = [[JSON objectForKey:@"Id"] integerValue];
                newDR.number = [JSON objectForKey:@"Number"];
                newDR.revision = [JSON objectForKey:@"Revision"];
                newDR.subject = [JSON objectForKey:@"Subject"];
                newDR.date = [JSON objectForKey:@"Date"];
                newDR.enteredBy = [[JSON objectForKey:@"EnteredBy"] integerValue];
                newDR.weatherId = [[JSON objectForKey:@"Weather"] integerValue];
                newDR.weatherIcon = [JSON objectForKey:@"WeatherIconValue"];;
                newDR.windId = [[JSON objectForKey:@"Wind"] integerValue];
                newDR.temperature = [[JSON objectForKey:@"Temperature"] integerValue];
                newDR.employeeFromId = [[JSON objectForKey:@"EmployeeFrimId"] integerValue];
                newDR.isEditable = [[JSON objectForKey:@"AllowEdit"] boolValue];

                if ([JSON objectForKey:@"Comments"] != [NSNull null])
                {
                    NSDictionary *cdata = [JSON objectForKey:@"Comments"];
                    if ([cdata objectForKey:@"CommunicationWithOthers"] != [NSNull null])
                    {
                        newDR.communicationWithOthers = [cdata objectForKey:@"CommunicationWithOthers"];
                    }
                    if ([cdata objectForKey:@"ScheduleCoordination"] != [NSNull null])
                    {
                        newDR.scheduleCoordination = [cdata objectForKey:@"ScheduleCoordination"];
                    }
                    if ([cdata objectForKey:@"ExtraWork"] != [NSNull null])
                    {
                        NSDictionary *ndata = [cdata objectForKey:@"ExtraWork"];
                        if ([ndata objectForKey:@"Comment"] != [NSNull null])
                        {
                            newDR.extraWork = [ndata objectForKey:@"Comment"];
                        }
                        if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                        {
                            newDR.extraWorkIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                        }
                    }
                    if ([cdata objectForKey:@"AccidentReport"] != [NSNull null])
                    {
                        NSDictionary *ndata = [cdata objectForKey:@"AccidentReport"];
                        if ([ndata objectForKey:@"Comment"] != [NSNull null])
                        {
                            newDR.accidentReport = [ndata objectForKey:@"Comment"];
                        }
                        if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                        {
                            newDR.accidentReportIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                        }
                    }
                    if ([cdata objectForKey:@"Subcontractors"] != [NSNull null])
                    {
                        NSDictionary *ndata = [cdata objectForKey:@"Subcontractors"];
                        if ([ndata objectForKey:@"Comment"] != [NSNull null])
                        {
                            newDR.subcontractors = [ndata objectForKey:@"Comment"];
                        }
                        if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                        {
                            newDR.subcontractorsIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                        }
                    }
                    if ([cdata objectForKey:@"OtherVisitors"] != [NSNull null])
                    {
                        NSDictionary *ndata = [cdata objectForKey:@"OtherVisitors"];
                        if ([ndata objectForKey:@"Comment"] != [NSNull null])
                        {
                            newDR.otherVisitors = [ndata objectForKey:@"Comment"];
                        }
                        if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                        {
                            newDR.otherVisitorsIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                        }
                    }
                    if ([cdata objectForKey:@"Problems"] != [NSNull null])
                    {
                        NSDictionary *ndata = [cdata objectForKey:@"Problems"];
                        if ([ndata objectForKey:@"Comment"] != [NSNull null])
                        {
                            newDR.problems = [ndata objectForKey:@"Comment"];
                        }
                        if ([ndata objectForKey:@"isInternal"] != [NSNull null])
                        {
                            newDR.problemsIsInternal = [[ndata objectForKey:@"isInternal"] boolValue];
                        }
                    }
                    if ([cdata objectForKey:@"Internal"] != [NSNull null])
                    {
                        newDR.internal = [cdata objectForKey:@"Internal"];
                    }
                }

                DailyReportTableViewController *vc = [[DailyReportTableViewController alloc] initWithNibName:@"DailyReportTableViewController" bundle:nil];

                NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
                [FormatDate setLocale: [[NSLocale alloc]
                                        initWithLocaleIdentifier:@"en_US"]];
                [FormatDate setDateFormat:@"MM-dd-yyyy"];
                NSString *d = [FormatDate stringFromDate:[NSDate date]];

                vc.title = [NSString stringWithFormat:@"%@ - %@", newDR.number, d];
                vc.reportName = [NSString stringWithFormat:@"%@", newDR.number];
                vc.dailyReportId = newDR.id;
                
                vc.drDate = d;
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

                [Common CopyCrewEquipmentMatieralsForDailyReport:self.projectId dailyReportId:[[JSON objectForKey:@"Id"] integerValue] dailyReportDate:d copyDailyReportId:dr.id
                    complete:^{
                     [DejalBezelActivityView removeViewAnimated:YES];
                     [self.navigationController pushViewController:vc animated:YES];
                    }];

            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
            {
                [DejalBezelActivityView removeViewAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline saving of copy DR not supported" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
        
        [operation start];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

@end
