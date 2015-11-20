//
//  EquipmentTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/19/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "EquipmentTableViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "EquipmentObject.h"
#import "EquipmentEntryTableViewController.h"
#import "Common.h"

@interface EquipmentTableViewController ()

@end

@implementation EquipmentTableViewController

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
    [sButton addTarget:self action:@selector(addEquipment) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    if (self.dr.isEditable)
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    }
    
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
    [refreshControl addTarget:self action:@selector(reloadEquipment:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Equipment";
    self.navigationItem.titleView = label;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [self startGettingData];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];

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
    [sButton addTarget:self action:@selector(addEquipment) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];

}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) reloadEquipment:(UIRefreshControl *)refreshControl
{
    
    [self startGettingData];
    [refreshControl endRefreshing];
    
}

- (void) addEquipment
{

    EquipmentEntryTableViewController *vc = [[EquipmentEntryTableViewController alloc] initWithNibName:@"EquipmentEntryTableViewController" bundle:nil];
    vc.projectEquipment = self.projectEquipment;
    vc.dailyReportId = self.dailyReportId;
    vc.projectId = self.projectId;
    vc.newEntry = YES;
    vc.dr = self.dr;

    [self.navigationController pushViewController:vc animated:YES];

}

- (void) startGettingData
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.listOfEquipment = [appD.eSubsDB getEquipmentObjects:appD.userId forProjectId:self.projectId andDailyReportId:self.dailyReportId];
        [self.tableView reloadData];
    }
    else
    {
        __block int count=0;
        NSMutableArray *SavedequipmentList = [appD.eSubsDB getSavedEquipmentObjects:appD.userId];
        if (SavedequipmentList.count<=0) {
            [self getListOfEquipment];
            return;
        }
        
        for (EquipmentObject *equipmentObject in SavedequipmentList)
        {
            [Common saveUnsavedEquipmentToWebService:equipmentObject
             success:^(id responseObject)
             {
                 count++;
                 if (count == SavedequipmentList.count) {
                     [self getListOfEquipment];
                 }

             }
            failure:^(NSError *error){
                count++;
                if (count == SavedequipmentList.count) {
                    [self getListOfEquipment];
                }
            }];
        }
//        [self getListOfEquipment];
    }
    
}

- (void) getListOfEquipment
{
    
    [DejalBezelActivityView activityViewForView:self.view];

    [Common getListOfEquipment:self.projectId dailyReportId:self.dailyReportId
        success:^(id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            self.listOfEquipment = responseObject;
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

            NSLog(@"Network error in equipment download %@", [error localizedDescription]);
        }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.listOfEquipment.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    EquipmentObject *equipment = [self.listOfEquipment objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@" %@ %.02f hrs", equipment.equipment, equipment.hours];
    if ([equipment.code isEqualToString:@"This equipment has not been saved"])
    {
        cell.detailTextLabel.text = @"This equipment has not been saved";
    }
    else
    {
        cell.detailTextLabel.text = equipment.useageDesc;
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

//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete not working" message:@"Bug ESUBAPI-68" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];

//         Delete the row from the data source
        EquipmentObject *projectEquipment = [self.listOfEquipment objectAtIndex:indexPath.row];
        [self.listOfEquipment removeObject:projectEquipment];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [DejalBezelActivityView activityViewForView:self.view];
        
        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        NSMutableDictionary *data = [NSMutableDictionary dictionary];
//        
//        [data setObject:[NSNumber numberWithInteger:self.projectId] forKey:@"ProjectId"];
//        [data setObject:[NSNumber numberWithInteger:self.dailyReportId] forKey:@"dailyReportId"];
//        [data setObject:[NSNumber numberWithInteger:projectEquipment.equipmentId] forKey:@"equipmentId"];
//        
//        [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
        [params setObject:[NSNumber numberWithInteger:self.dailyReportId] forKey:@"dailyReportId"];
        [params setObject:[NSNumber numberWithInteger:projectEquipment.drEquipmentId] forKey:@"drEquipmentId"];
        NSURLRequest *request = [client requestWithMethod:@"DELETE" path:@"Equipment" parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
            {
                [DejalBezelActivityView removeViewAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
            {
                [DejalBezelActivityView removeViewAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
        
        [operation start];

    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    EquipmentObject *equipment = [self.listOfEquipment objectAtIndex:indexPath.row];
    EquipmentEntryTableViewController *vc = [[EquipmentEntryTableViewController alloc] initWithNibName:@"EquipmentEntryTableViewController" bundle:nil];
    vc.projectEquipment = self.projectEquipment;
    vc.projectId = self.projectId;
    vc.dailyReportId = self.dailyReportId;
    vc.listOfEquipment = self.listOfEquipment;
    vc.equipmentObject = equipment;

    [self.navigationController pushViewController:vc animated:YES];

}

@end
