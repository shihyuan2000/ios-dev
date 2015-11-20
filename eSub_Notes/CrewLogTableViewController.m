//
//  CrewLogTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/7/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "CrewLogTableViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "CrewObject.h"
#import "SystemPhase.h"
#import "EmployeeObject.h"
#import "ActivityObject.h"
#import "WorkTypeObject.h"
#import "SaveNoteAFHTTPClient.h"
#import "Common.h"
#import "CrewSections.h"
#import "CrewLogTableHeaderCellTableViewCell.h"
#import "CrewLogCustomTableCell.h"

@interface CrewLogTableViewController ()
{
    
    NSMutableArray  *sections;
    
}
@end

@implementation CrewLogTableViewController

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
    [sButton addTarget:self action:@selector(addCrew) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    if (self.dr.isEditable)
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    }

//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, nil];

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
    [refreshControl addTarget:self action:@selector(reloadCrew:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = [NSString stringWithFormat:@"Crew Entry Report %@", self.reportName];
    self.navigationItem.titleView = label;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

    [self loadCrew];

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
    [sButton addTarget:self action:@selector(addCrew) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    
}

- (void) addCrew
{
    
    CrewEntryTableViewController *vc = [[CrewEntryTableViewController alloc] initWithNibName:@"CrewEntryTableViewController" bundle:nil];
    self.employeeList = [[NSMutableArray alloc] init];
    vc.employeeList = self.employeeList;
    vc.reportName = self.reportName;
    vc.dailyReportId = self.dailyReportId;
    vc.drDate = self.drDate;
    vc.projectId = self.projectId;
    vc.activity = self.activity;
    vc.workType = self.workType;
    vc.employee = self.employee;
    vc.crewList = self.crewList;
    vc.companyPreferences = self.companyPreferences;
    vc.systemPhases = self.systemPhases;
    vc.systemPhaseInit = @"System Phase";
    vc.activityInit = @"Labor Activity";
    vc.workTypeInit = @"Base Contract";
    vc.employeeInit = @"Employee";
    vc.newEntry = YES;
    vc.dr = self.dr;

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) loadCrew
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.crewList = [appD.eSubsDB getCrewObjects:self.projectId forDailyReportId:self.dailyReportId];
        for (CrewObject *c in self.crewList)
        {
            c.systemPhase = [self getSystem:c.phaseId];
        }
        [self.crewList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"systemPhase" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"laborActivityId" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"workTypeId" ascending:YES]]];
        [self createSections];
        [self.tableView reloadData];
    }
    else
    {
//        [self getDataFromWebService];
        [self getListOfCrew];
    }

}

- (void) reloadCrew:(UIRefreshControl *)refreshControl
{
    
    [self loadCrew];
    [refreshControl endRefreshing];
    
}

- (void) createSections
{
    
    sections = [[NSMutableArray alloc] init];
    BOOL found;
    for (CrewObject *c in self.crewList)
    {
        found = NO;
        for (CrewSections *s in sections)
        {
            if ([s.systemPhase isEqualToString:c.systemPhase] && s.laborActivityId == c.laborActivityId && s.workTypeId == c.workTypeId)
            {
                found = YES;
                CrewObject *removeCo=[self holdSection:s crewObject:c];
                if (removeCo) {
                     [s.crewObjects addObject:c];
                     [s.crewObjects removeObject:removeCo];
                }
                else
                {
                 [s.crewObjects addObject:c];
                }
            }
        }
        if (!found)
        {
            CrewSections *cs = [[CrewSections alloc] init];
            cs.systemPhase = c.systemPhase;
            cs.laborActivityId = c.laborActivityId;
            cs.workTypeId = c.workTypeId;
            cs.crewObjects = [[NSMutableArray alloc] init];
            [cs.crewObjects addObject:c];
            [sections addObject:cs];
        }
    }
    
}

-(CrewObject *)holdSection:(CrewSections *)crewSectionList crewObject:(CrewObject *)co
{
    CrewObject *removeObj = nil;
    for (CrewObject *c in crewSectionList.crewObjects) {
        if (co.employeeId == c.employeeId) {
            removeObj = c;
            if ([co.crewName isEqualToString: @"This crew has not been saved"]) {
                removeObj = co;
            }
            else if([c.crewName isEqualToString: @"This crew has not been saved"])
            {
               removeObj = c;
            }
        }
    }
    
    return removeObj;
}
- (void) getListOfCrew
{
    
    [DejalBezelActivityView activityViewForView:self.view];
    [Common getListOfCrew:self.projectId dailyReportId:self.dailyReportId
        success:^(id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            self.crewList = responseObject;
            for (CrewObject *c in self.crewList)
            {
                c.systemPhase = [self getSystem:c.phaseId];
            }
            [self.crewList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"systemPhase" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"laborActivityId" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"workTypeId" ascending:YES]]];
            [self createSections];
            [self.tableView reloadData];
        }
        failure:^(NSHTTPURLResponse *response, NSError *error)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            NSInteger code = [response statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSLog(@"Network error in download Crews: %@", [error localizedDescription]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];

}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return sections.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    CrewSections *cs = [sections objectAtIndex:section];
    return cs.crewObjects.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 65;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    CrewSections *s = [sections objectAtIndex:section];

    [tableView registerNib:[UINib nibWithNibName:@"CrewLogTableHeaderCell" bundle:nil] forCellReuseIdentifier:@"crewLogHeaderCell"];
    CrewLogTableHeaderCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"crewLogHeaderCell"];

    if ([s.systemPhase isEqualToString:@"DEFAULT System/DEFAULT Phase"]) {
        s.systemPhase = @"";
    }
    cell.crewHeaderLabel1.text = s.systemPhase;
    cell.crewHeaderLabel2.text = [NSString stringWithFormat:@"%@", [self getActivity:s.laborActivityId]];
    cell.crewHeaderLabel3.text = [NSString stringWithFormat:@"%@", [self getWorkType:s.workTypeId]];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:cell];
    return headerView;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

/*
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    CrewSections *s = [sections objectAtIndex:indexPath.section];
    CrewObject *crew = [s.crewObjects objectAtIndex:indexPath.row];
    
    float total = crew.hoursST + crew.hoursOT + crew.hoursDT;
    
    if (total)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %.02f hrs %@", [self getEmployee:crew.employeeId], total, [self getActivity:crew.laborActivityId]];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@  0 hrs  %@", [self getEmployee:crew.employeeId], [self getActivity:crew.laborActivityId]];
    }
    if ([crew.crewName isEqualToString:@"This crew has not been saved"])
    {
        cell.detailTextLabel.text = @"This crew has not been saved";
    }
    else if (self.systemPhases.count > 1)
    {
        cell.detailTextLabel.text = [self getSystem:crew.phaseId];
    }
*/

    CrewSections *s = [sections objectAtIndex:indexPath.section];
    CrewObject *crew = [s.crewObjects objectAtIndex:indexPath.row];

    [tableView registerNib:[UINib nibWithNibName:@"CrewLogCustomTableCell" bundle:nil] forCellReuseIdentifier:@"crewLogCustomTableCell"];
    CrewLogCustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"crewLogCustomTableCell"];

    cell.crewLogCustomLabel1.text = [self getEmployee:crew.employeeId];
    
    NSString *str = [NSString stringWithFormat: @"Hours 1x:  %.02f", crew.hoursST];
    if (self.companyPreferences.dailyReportOvertimeEnabled)
    {
        str = [str stringByAppendingFormat:@", 1.5x: %.02f", crew.hoursOT];
    }
    if (self.companyPreferences.dailyReportDoubleTimeEnabled)
    {
        str = [str stringByAppendingFormat:@", 2x: %.02f", crew.hoursDT];
    }
    cell.crewLogCustomLabel2.text = str;
    if ([crew.crewName isEqualToString:@"This crew has not been saved"])
    {
        cell.crewLogCustomLabel3.text = @"This crew has not been saved";
    }
    else
    {
        cell.crewLogCustomLabel3.text = crew.comments;
    }

    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        if ([appD.reachability currentReachabilityStatus] == NotReachable)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Edit Failed You must have an internet connection in order to edit." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        // Delete the row from the data source
//        CrewObject *c = [self.crewList objectAtIndex:indexPath.row];
        CrewSections *s = [sections objectAtIndex:indexPath.section];
        CrewObject *c = [s.crewObjects objectAtIndex:indexPath.row];
        [self.crewList removeObject:c];
        [s.crewObjects removeObject:c];
        [DejalBezelActivityView activityViewForView:self.view];
        
//        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];

        NSMutableArray *crews = [Common buildExistingCrewRows:self.crewList];

        [data setObject:[NSNumber numberWithInteger:self.projectId] forKey:@"ProjectId"];
        [data setObject:[NSNumber numberWithInteger:self.dailyReportId] forKey:@"dailyReportId"];
        [data setObject:self.drDate forKey:@"drDate"];
        [data setObject:crews forKey:@"crews"];
        
        [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
        NSURLRequest *request = [client requestWithMethod:@"POST" path:@"Crew" parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
            {
                [DejalBezelActivityView removeViewAnimated:YES];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                [self.navigationController popViewControllerAnimated:YES];
                if (s.crewObjects.count == 0) {
                    [sections removeObject:s];
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
                    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
            {
                [DejalBezelActivityView removeViewAnimated:YES];
                [self.crewList addObject:c];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Failed" message:@"You must have an internet connection in order to delete" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
        
        [operation start];

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    CrewObject *crew = [self.crewList objectAtIndex:indexPath.row];
    CrewSections *s = [sections objectAtIndex:indexPath.section];
    CrewObject *crew = [s.crewObjects objectAtIndex:indexPath.row];

    CrewEntryTableViewController *vc = [[CrewEntryTableViewController alloc] initWithNibName:@"CrewEntryTableViewController" bundle:nil];
    
    vc.reportName = self.reportName;
    vc.dailyReportId = self.dailyReportId;
    vc.projectId = self.projectId;
    vc.activity = self.activity;
    vc.workType = self.workType;
    vc.employee = self.employee;
    vc.crewList = self.crewList;
    vc.companyPreferences = self.companyPreferences;
    vc.drDate = self.drDate;
    vc.systemPhases = self.systemPhases;
    vc.dr = self.dr;

    vc.systemPhaseInit = [self getSystem:crew.phaseId];
    if (vc.systemPhaseInit.length == 0)
    {
        vc.systemPhaseInit = @"System Phase";
    }
    vc.activityInit = [self getActivity:crew.laborActivityId];
    if (vc.activityInit.length == 0)
    {
        vc.activityInit = @"Labor Activity";
    }
    vc.workTypeInit = [self getWorkType:crew.workTypeId];
    if (vc.workTypeInit.length == 0)
    {
        vc.workTypeInit = @"Base Contract";
    }
    vc.crew = crew;
    vc.crewId = crew.id;
    vc.crewHours1x = crew.hoursST;
    vc.crewHours1_5x = crew.hoursOT;
    vc.crewHours2x = crew.hoursDT;
    vc.crewUnits = crew.units;
    vc.crewHoursLost = crew.hoursLost;
    vc.crewComments = crew.comments;

    self.employeeList = [[NSMutableArray alloc] init];
//    EmployeeObject *employee = [self.employee objectAtIndex:indexPath.row];
    [self.employeeList addObject:[NSNumber numberWithInteger:crew.employeeId]];
    vc.employeeList = self.employeeList;
    vc.employeeInit = [self getEmployee:crew.employeeId];
    
    vc.newEntry = NO;

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSString *) getSystem: (NSUInteger) id
{
    
    for (SystemPhase *system in self.systemPhases)
    {
        if (system.phaseId == id)
        {
            return [NSString stringWithFormat:@"%@/%@", system.systemName, system.phaseName];
        }
    }
    
    return nil;
    
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
    
    return @"";
    
}

- (NSString *) getWorkType: (NSInteger) id
{
    
    for (WorkTypeObject *workType in self.workType)
    {
        if (workType.id == id && workType.show)
        {
            return workType.type;
        }
    }
    
    return nil;
    
}

@end
