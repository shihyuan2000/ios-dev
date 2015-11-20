//
//  CommentsTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 3/9/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "CommentsEntryViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import "DejalActivityView.h"

@interface CommentsTableViewController ()

@end

@implementation CommentsTableViewController

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
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadComments:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Comments";
    self.navigationItem.titleView = label;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];

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

- (void) reloadComments:(UIRefreshControl *)refreshControl
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    [DejalBezelActivityView activityViewForView:self.view];
    [Common getDailyReports:self.projectId
        success:^(NSMutableArray *dailyReports)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [appD.eSubsDB deleteDailyReports:self.projectId forUserID:appD.userId];
            for (DailyReportObject *dr in dailyReports)
            {
                if (dr.id == self.dr.id)
                {
                    self.dr = dr;
                }
                [appD.eSubsDB insertDailyReports:dr forProjectId:self.projectId userId:appD.userId];
            }
            self.dailyReports = dailyReports;
            [self.tableView reloadData];
        }
        failure:^(NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            NSLog(@"Network error in download Daily Reports: %@", [error localizedDescription]);
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger code = [httpResponse statusCode];
            if (code == 404)
            {
                NSDictionary *data = [JSON objectForKey:@"exception"];
                NSString *message = [data objectForKey:@"message"];
                if ([message isEqualToString:@"No DRs have been found"])
                {
                    [appD.eSubsDB deleteDailyReports:self.projectId forUserID:appD.userId];
                    self.dailyReports = nil;
                    [self.tableView reloadData];
                }
            }
        }];
    
    [refreshControl endRefreshing];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 8;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Communication with others";
            break;
        case 1:
            sectionName =@"Schedule/Coordination Issues";
            break;
        case 2:
            sectionName =@"Extra Work/Favors";
            break;
        case 3:
            sectionName =@"Accident Report";
            break;
        case 4:
            sectionName =@"Subcontractors Worked";
            break;
        case 5:
            sectionName =@"Other Visitors";
            break;
        case 6:
            sectionName =@"Comments/Problems";
            break;
        case 7:
            sectionName =@"Internal Comments";
            break;

        default:
            sectionName = @"";
            break;
    }
    
    return sectionName;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

// communicationWithOthers, scheduleCoordination, extraWork, extraWorkIsInternal, accidentReport, accidentReportIsInternal, subcontractors, subcontractorsIsInternal, otherVisitors, otherVisitorsIsInternal, problems, problemsIsInternal, internal
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.dr.communicationWithOthers;
    }
    if (indexPath.section == 1)
    {
        cell.textLabel.text = self.dr.scheduleCoordination;
    }
    if (indexPath.section == 2)
    {
        cell.textLabel.text = self.dr.extraWork;
        if (self.dr.extraWorkIsInternal)
        {
            cell.detailTextLabel.text = @"Internal: Yes";
        }
        else
        {
            cell.detailTextLabel.text = @"Internal: No";
        }
    }
    if (indexPath.section == 3)
    {
        cell.textLabel.text = self.dr.accidentReport;
        if (self.dr.accidentReportIsInternal)
        {
            cell.detailTextLabel.text = @"Internal: Yes";
        }
        else
        {
            cell.detailTextLabel.text = @"Internal: No";
        }
    }
    if (indexPath.section == 4)
    {
        cell.textLabel.text = self.dr.subcontractors;
        if (self.dr.subcontractorsIsInternal)
        {
            cell.detailTextLabel.text = @"Internal: Yes";
        }
        else
        {
            cell.detailTextLabel.text = @"Internal: No";
        }
    }
    if (indexPath.section == 5)
    {
        cell.textLabel.text = self.dr.otherVisitors;
        if (self.dr.otherVisitorsIsInternal)
        {
            cell.detailTextLabel.text = @"Internal: Yes";
        }
        else
        {
            cell.detailTextLabel.text = @"Internal: No";
        }
    }
    if (indexPath.section == 6)
    {
        cell.textLabel.text = self.dr.problems;
        if (self.dr.problemsIsInternal)
        {
            cell.detailTextLabel.text = @"Internal: Yes";
        }
        else
        {
            cell.detailTextLabel.text = @"Internal: No";
        }
    }
    if (indexPath.section == 7)
    {
        cell.textLabel.text = self.dr.internal;
    }
    
    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentsEntryViewController *vc = [[CommentsEntryViewController alloc] initWithNibName:@"CommentsEntryViewController" bundle:nil];

    if (indexPath.section == 0)
    {
        vc.comment = self.dr.communicationWithOthers;
        vc.headerTitle = @"Communication with others";
        vc.showInternal = NO;
    }
    if (indexPath.section == 1)
    {
        vc.comment = self.dr.scheduleCoordination;
        vc.headerTitle = @"Schedule/Coordination Issues";
        vc.showInternal = NO;
    }
    if (indexPath.section == 2)
    {
        vc.comment = self.dr.extraWork;
        vc.headerTitle = @"Extra Work/Favors";
        vc.showInternal = YES;
        if (self.dr.extraWorkIsInternal)
        {
            vc.internal = YES;
        }
        else
        {
            vc.internal = NO;
        }
    }
    if (indexPath.section == 3)
    {
        vc.comment = self.dr.accidentReport;
        vc.headerTitle = @"Accident Report";
        vc.showInternal = YES;
        if (self.dr.accidentReportIsInternal)
        {
            vc.internal = YES;
        }
        else
        {
            vc.internal = NO;
        }
    }
    if (indexPath.section == 4)
    {
        vc.comment = self.dr.subcontractors;
        vc.headerTitle = @"Subcontractors Worked";
        vc.showInternal = YES;
        if (self.dr.subcontractorsIsInternal)
        {
            vc.internal = YES;
        }
        else
        {
            vc.internal = NO;
        }
    }
    if (indexPath.section == 5)
    {
        vc.comment = self.dr.otherVisitors;
        vc.headerTitle = @"Other Visitors";
        vc.showInternal = YES;
        if (self.dr.otherVisitorsIsInternal)
        {
            vc.internal = YES;
        }
        else
        {
            vc.internal = NO;
        }
    }
    if (indexPath.section == 6)
    {
        vc.comment = self.dr.problems;
        vc.headerTitle = @"Comments/Problems";
        vc.showInternal = YES;
        if (self.dr.problemsIsInternal)
        {
            vc.internal = YES;
        }
        else
        {
            vc.internal = NO;
        }
    }
    if (indexPath.section == 7)
    {
        vc.comment = self.dr.internal;
        vc.headerTitle = @"Internal Comments";
        vc.showInternal = NO;
    }

    vc.dr = self.dr;
    vc.projectId = self.projectId;
    vc.section = indexPath.section;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
