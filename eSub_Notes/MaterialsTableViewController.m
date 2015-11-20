//
//  MaterialsTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/21/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "MaterialsTableViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "MaterialsObject.h"
#import "MaterialsEntryTableViewController.h"
#import "Common.h"

@interface MaterialsTableViewController ()

@end

@implementation MaterialsTableViewController

- (void)viewDidLoad {
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
    [sButton addTarget:self action:@selector(addMaterials) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    
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
    label.text = @"Material";
    self.navigationItem.titleView = label;

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [self startGettingData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [sButton addTarget:self action:@selector(addMaterials) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    
}

- (void) addMaterials
{
    
    MaterialsEntryTableViewController *vc = [[MaterialsEntryTableViewController alloc] initWithNibName:@"MaterialsEntryTableViewController" bundle:nil];
    vc.projectMaterials = self.projectMaterials;
    vc.dailyReportId = self.dailyReportId;
    vc.projectId = self.projectId;
    NSMutableArray *perList = [[NSMutableArray alloc] init];
    [perList addObject:@"Barrel"];
    [perList addObject:@"Box"];
    [perList addObject:@"Bunch"];
    [perList addObject:@"Bundle of sticks"];
    [perList addObject:@"Color"];
    [perList addObject:@"Foot"];
    [perList addObject:@"Govenor"];
    [perList addObject:@"Pound"];
    
    vc.newEntry = YES;
    vc.perList = perList;

    
    [self.navigationController pushViewController:vc animated:YES];
    
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

- (void) startGettingData
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.projectMaterials = [appD.eSubsDB getProjectMaterialObjects:self.projectId DailyReportId:self.dailyReportId];
        [self.tableView reloadData];
    }
    else
    {
      // to do add local data to server.
        NSMutableArray *getListUnSaveToServer = [[NSMutableArray alloc] init];
        getListUnSaveToServer = [appD.eSubsDB getFlagMaterialObjects:self.projectId];
        if (getListUnSaveToServer.count<=0) {
            [self getListOfProjectMaterials];
            return;
        }
        
       __block int count=0;
        for (MaterialsObject *obj in getListUnSaveToServer) {
            if (obj.flag==1)
            {
            [Common SaveMaterial:obj dailyReportId:obj.dailyReportId
            success:^(id responseObject)
             {
                 [appD.eSubsDB updateProjectMaterialObjectFlag:obj forProjectId:self.projectId];
                 count++;
                 if (count == getListUnSaveToServer.count) {
                     [self getListOfProjectMaterials];
                 }
                 
             }
             failure:^(NSError *error)
             {
                 count++;
                 if (count == getListUnSaveToServer.count) {
                     [self getListOfProjectMaterials];
                 }
             }];
                
            }
            
            else
            {
                [Common UpdateMaterial:obj dailyReportId:obj.dailyReportId
                success:^(id responseObject)
                 {
                     [appD.eSubsDB updateProjectMaterialObjectFlag:obj forProjectId:self.projectId];
                     count++;
                     if (count == getListUnSaveToServer.count) {
                         [self getListOfProjectMaterials];
                     }
                 }
                failure:^(NSError *error)
                 {
                     count++;
                     if (count == getListUnSaveToServer.count) {
                         [self getListOfProjectMaterials];
                     }
                 }];
            }
        }
    }
}

- (void) getListOfProjectMaterials
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[NSNumber numberWithInt:(int)self.projectId]  forKey:@"projectID"];
        [params setObject:[NSNumber numberWithInt:(int)self.dailyReportId]  forKey:@"dailyReportId"];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Material" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
//            [appD.eSubsDB deleteProjectEquipmentObjects:self.projectId];
            [appD.eSubsDB deleteProjectMaterialObjects:self.projectId];
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                self.projectMaterials = [[NSMutableArray alloc] init];
                for (NSDictionary *mdata in data)
                {
                    MaterialsObject *material = [[MaterialsObject alloc] init];
//                    if ([mdata objectForKey:@"MaterialId"] != [NSNull null])
//                    {
//                        material.id = [[mdata objectForKey:@"MaterialId"] integerValue];
//                    }
                    if ([mdata objectForKey:@"Id"] != [NSNull null])
                    {
                        material.id = [[mdata objectForKey:@"Id"] integerValue];
                    }
                    if ([mdata objectForKey:@"Name"] != [NSNull null])
                    {
                        material.name = [mdata objectForKey:@"Name"];
                    }
                    if ([mdata objectForKey:@"Quantity"] != [NSNull null])
                    {
                        material.quantityValue =[NSString stringWithFormat:@"%@",(NSNumber *)[mdata objectForKey:@"Quantity"]];
                    }
                    if ([mdata objectForKey:@"Per"] != [NSNull null])
                    {
                        material.perValue = [mdata objectForKey:@"Per"];
                    }
                    if ([mdata objectForKey:@"Notes"] != [NSNull null])
                    {
                        material.notesValue = [mdata objectForKey:@"Notes"];
                    }
                    material.flag = 0;
                    [self.projectMaterials addObject:material];
                    
                    [appD.eSubsDB insertProjectMaterialObject:material forProjectId:self.projectId forDailyReportId:self.dailyReportId];
                }
                
                [self.tableView reloadData];
            }

        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            NSLog(@"Network error in materials download %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    
    [operation start];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.projectMaterials.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    MaterialsObject *material = [self.projectMaterials objectAtIndex:indexPath.row];
    
    cell.textLabel.text = material.name;
    
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
        // Delete the row from the data source
        MaterialsObject *material = [self.projectMaterials objectAtIndex:indexPath.row];
        [self.projectMaterials removeObject:material];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //to do delete api.
        //         Delete the row from the data source
//        [DejalBezelActivityView activityViewForView:self.view];
//        
//        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
//        NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setObject:[NSNumber numberWithInteger:self.dailyReportId] forKey:@"dailyReportId"];
//        [params setObject:[NSNumber numberWithInteger:material.id] forKey:@"id"];
//        [params setObject:[NSNumber numberWithInteger:material.id] forKey:@"materialId"];
//        NSURLRequest *request = [client requestWithMethod:@"DELETE" path:@"Material" parameters:params];
//        
//        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//                                             {
//                                                 [DejalBezelActivityView removeViewAnimated:YES];
//                                                 [self.navigationController popViewControllerAnimated:YES];
//                                             }
//                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
//                                             {
//                                                 [DejalBezelActivityView removeViewAnimated:YES];
//                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                                 [alert show];
//                                             }];
//        
//        [operation start];

    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MaterialsEntryTableViewController *vc = [[MaterialsEntryTableViewController alloc] initWithNibName:@"MaterialsEntryTableViewController" bundle:nil];
    NSMutableArray *perList = [[NSMutableArray alloc] init];
    [perList addObject:@"Barrel"];
    [perList addObject:@"Box"];
    [perList addObject:@"Bunch"];
    [perList addObject:@"Bundle of sticks"];
    [perList addObject:@"Color"];
    [perList addObject:@"Foot"];
    [perList addObject:@"Govenor"];
    [perList addObject:@"Pound"];
    vc.perList = perList;
    
    vc.projectMaterials = self.projectMaterials;
    vc.dailyReportId = self.dailyReportId;
    vc.projectId = self.projectId;
    MaterialsObject *material = [self.projectMaterials objectAtIndex:indexPath.row];
    vc.id = material.id;
    vc.name = material.name;
    vc.quantityValue=material.quantityValue;
    vc.perValue=material.perValue;
    vc.notesValue = material.notesValue;
    vc.flag = material.flag;
    vc.newEntry = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
