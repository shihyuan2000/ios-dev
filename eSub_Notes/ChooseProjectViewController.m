//
//  ChooseProjectViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "ChooseProjectViewController.h"
#import "ProjectAFHTTPClient.h"
#import "ProjectObject.h"
#import "DejalActivityView.h"
#import "SettingsViewController.h"
#import "TimeCardViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

SettingsViewController *settingVC;
NSString *ProjectStatus = @"";;

@interface ChooseProjectViewController ()

@end

@implementation ChooseProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    settingVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingVC.refresh = NO;

    [self.navigationController setNavigationBarHidden:NO];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 0.0/255.0 green: 255.0/255.0 blue:255.0/255.0 alpha: 1.0];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    
    [self.navigationItem setHidesBackButton:YES];

    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sButton.layer.borderWidth = 1;
    sButton.layer.borderColor = [UIColor blackColor].CGColor;
//    sButton.layer.backgroundColor = [UIColor colorWithRed: 202.0/255.0 green: 225.0/255.0 blue:255.0/255.0 alpha: 1.0].CGColor;
    sButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(logoff) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithCustomView:sButton];

    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:logout, nil];

    sButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sButton setImage:[UIImage imageNamed:@"Settings.png"] forState:UIControlStateNormal];
//    [sButton setImage:[UIImage imageNamed:@"Punch.png"] forState:UIControlStateNormal];
    sButton.frame = CGRectMake(0, 0, 40, 40);
    [sButton addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
//    [sButton addTarget:self action:@selector(timeCard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
// LTS 7-11-2014 remove from add for release.
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
    
//    self.view.backgroundColor = [UIColor colorWithRed: 202.0/255.0 green: 225.0/255.0 blue:255.0/255.0 alpha: 1.0];
//    self.view.backgroundColor = [UIColor grayColor];

//    self.chooseTableView.backgroundColor = [UIColor colorWithRed: 202.0/255.0 green: 225.0/255.0 blue:255.0/255.0 alpha: 1.0];
//    self.chooseTableView.backgroundColor = [UIColor grayColor];

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadProjects:) forControlEvents:UIControlEventValueChanged];
    [self.chooseTableView addSubview:refreshControl];

/*
    UIImage *image = [UIImage imageNamed: @"eSub_nav.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    self.navigationItem.titleView = imageView;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Select Project";
    self.chooseTableView.tableHeaderView = label;
*/
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Projects";
    self.navigationItem.titleView = label;
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    ProjectStatus = appD.projectFilter;

}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

}

- (void) viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];

    if (self.refresh)
    {
        [self loadProjects];
        self.refresh = NO;
    }
    
    if (settingVC.refresh)
    {
        [self loadProjects];
        settingVC.refresh = NO;
    }
    
}

- (void) settings
{
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

- (void) timeCard
{

    TimeCardViewController *timeCardVC = [[TimeCardViewController alloc] initWithNibName:@"TimeCardViewController" bundle:nil];
    timeCardVC.projects = self.projects;
    [self.navigationController pushViewController:timeCardVC animated:YES];
    
}


- (void) loadProjects
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.projects = [appD.eSubsDB getProjectObjects:appD.userId];

        int i = 0;
        while (i < self.projects.count)
        {
            ProjectObject *project = [self.projects objectAtIndex:i];
            NSLog(@"Project Name : %@ status : %@", project.projectName, project.projectStatus);
            if (![project.projectStatus isEqualToString:ProjectStatus])
            {
                [self.projects removeObject:project];
                i = 0;
            }
            else
            {
                i++;
            }
        }
 
        [self.chooseTableView reloadData];
        return;
    }

    [DejalBezelActivityView activityViewForView:self.view];
    
    ProjectAFHTTPClient *client = [ProjectAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];

    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Projects" parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSMutableArray *projectObjects = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            
            NSMutableArray *status = [[NSMutableArray alloc] init];

            for (NSDictionary *project in data)
            {
                ProjectObject *projectObject = [[ProjectObject alloc] init];
                if ([project objectForKey:@"Id"])
                {
                    projectObject.id = (NSUInteger )[[project objectForKey:@"Id"] intValue];
                }
                if ([project objectForKey:@"Number"])
                {
                    projectObject.projectNumber = [project objectForKey:@"Number"];
                }
                if ([project objectForKey:@"Name"])
                {
                    projectObject.projectName = [project objectForKey:@"Name"];
                }
                if ([project objectForKey:@"Status"])
                {
                    projectObject.projectStatus = [project objectForKey:@"Status"];
                    if ([status indexOfObject:projectObject.projectStatus] == NSNotFound)
                    {
                        [status addObject:projectObject.projectStatus];
                    }
                }
                if ([project objectForKey:@"StartDate"])
                {
                    projectObject.projectStartDate = [project objectForKey:@"StartDate"];
                }
                if ([project objectForKey:@"FinishDate"])
                {
                    projectObject.projectEndDate = [project objectForKey:@"FinishDate"];
                }
                if ([project objectForKey:@"ProjectManager"])
                {
                    projectObject.projectManager = [project objectForKey:@"ProjectManager"];
                }
                if ([project objectForKey:@"Location"] != [NSNull null])
                {
                    NoteLocation *noteLocation = [[NoteLocation alloc] init];
                    NSDictionary *location = [project objectForKey:@"Location"];
                    NSDictionary *address = [location objectForKey:@"Address"];
                    if ([address count])
                    {
                        if ([address objectForKey:@"Address1"])
                        {
                            noteLocation.address.address1 = [address objectForKey:@"Address1"];
                        }
                        if ([address objectForKey:@"Address2"])
                        {
                            noteLocation.address.address2 = [address objectForKey:@"Address2"];
                        }
                        if ([address objectForKey:@"City"])
                        {
                            noteLocation.address.city = [address objectForKey:@"City"];
                        }
                        if ([address objectForKey:@"State"])
                        {
                            noteLocation.address.state = [address objectForKey:@"State"];
                        }
                        if ([address objectForKey:@"Zip"])
                        {
                            noteLocation.address.zip = [address objectForKey:@"Zip"];
                        }
                        if ([address objectForKey:@"Country"])
                        {
                            noteLocation.address.country = [address objectForKey:@"Country"];
                        }
                    }
                    if ([location objectForKey:@"Geolocation"] != [NSNull null])
                    {
                        NSDictionary *geolocation = [location objectForKey:@"Geolocation"];
                        if ([geolocation objectForKey:@"Longitude"])
                        {
                            noteLocation.location.longitude = [[address objectForKey:@"Longitude"] doubleValue];
                        }
                        if ([geolocation objectForKey:@"Latitude"])
                        {
                            noteLocation.location.latitude = [[address objectForKey:@"Latitude"] doubleValue];
                        }
                    }
                    projectObject.projectLocation = noteLocation;
                }
                if ([project objectForKey:@"Comments"])
                {
                    projectObject.projectComments = [project objectForKey:@"Comments"];
                }
                if ([project objectForKey:@"Status"])
                {
                    if ([[project objectForKey:@"Status"] isEqualToString:ProjectStatus])
                    {
                        [projectObjects addObject:projectObject];
                    }
                }

                [appD.eSubsDB insertProjectObject:projectObject forUserID:appD.userId];
            }
            self.projects = projectObjects;

            UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:status];
            segmentedControl.frame = CGRectMake(10, 0, status.count * 75, 30);
            segmentedControl.selectedSegmentIndex = 0;
            for (int i = 0; i < segmentedControl.numberOfSegments; i++)
            {
                NSString *title = [segmentedControl titleForSegmentAtIndex:i];
                if ([title isEqualToString:ProjectStatus])
                {
                    segmentedControl.selectedSegmentIndex = i;
                    break;
                }
            }
            
            [statusView addSubview:segmentedControl];
            self.chooseTableView.tableHeaderView = statusView;
            [segmentedControl addTarget:self
                                 action:@selector(pickOne:)
                       forControlEvents:UIControlEventValueChanged];

            [self.chooseTableView reloadData];
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger code = [httpResponse statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    
    [operation start];
    
}

- (void) reloadProjects:(UIRefreshControl *)refreshControl
{
    
    [self loadProjects];
    [refreshControl endRefreshing];
    
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

- (void) pickOne:(id)sender
{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    ProjectStatus = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    [self loadProjects];
    
}


- (void) logoff
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    appD.tokenAccess = @"";
    appD.tokenExpires = @"";
    appD.tokenType = @"";

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.projects.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;

}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
//    cell.backgroundColor = [UIColor colorWithRed: 202.0/255.0 green: 225.0/255.0 blue:255.0/255.0 alpha: 1.0];
//    cell.backgroundColor = [UIColor grayColor];

    ProjectObject *projectObject = [self.projects objectAtIndex:indexPath.row];
/*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 480, 25)];
    label.font = [UIFont boldSystemFontOfSize:16.0f];

    label.text = [NSString stringWithFormat:@"%@", projectObject.projectName];
    [cell.contentView addSubview:label];

    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 480, 25)];
    label.text = [NSString stringWithFormat:@"%@", projectObject.projectComments];
    [cell.contentView addSubview:label];
*/
    
    
    NSString *manager = @"Not assigned";
//    if (projectObject.projectManager)
    if (![projectObject.projectManager isKindOfClass:[NSNull class]])
    {
//        manager = [NSString stringWithFormat:@"%@ %@", projectObject.projectManager.firstName, projectObject.projectManager.lastName];
        manager = projectObject.projectManager;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", projectObject.projectNumber, projectObject.projectName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Status: %@ Project Manager: %@", projectObject.projectStatus, manager];

    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ProjectObject *projectObject = [self.projects objectAtIndex:indexPath.row];
    ProjectMainViewController *projectMainVC = [[ProjectMainViewController alloc] initWithNibName:@"ProjectMainViewController" bundle:nil];
    
    projectMainVC.projectObject = projectObject;
    [self.navigationController pushViewController:projectMainVC animated:YES];

}

@end
