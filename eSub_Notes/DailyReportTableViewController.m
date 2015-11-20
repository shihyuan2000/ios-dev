//
//  DailyReportTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 8/7/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "DailyReportTableViewController.h"
#import "CrewLogTableViewController.h"
#import "EquipmentTableViewController.h"
#import "MaterialsTableViewController.h"
#import "WeatherViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "AttachmentsPhotosTableViewController.h"
#import "CommentsTableViewController.h"

@interface DailyReportTableViewController ()

@property (nonatomic,strong) NSArray *dailyReportItem;

@end

@implementation DailyReportTableViewController

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
    label.text = [NSString stringWithFormat:@"Daily Report %@", self.title];
    self.navigationItem.titleView = label;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    
    if (self.companyPreferences.dailyReportEquipmentEnabled && self.companyPreferences.dailyReportMaterialsEnabled) {
        count = 0;
        self.dailyReportItem = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    }
    else if(self.companyPreferences.dailyReportEquipmentEnabled && !self.companyPreferences.dailyReportMaterialsEnabled){
        count = 1;
        self.dailyReportItem = @[@"0",@"1",@"2",@"4",@"5"];
    }
    else if(!self.companyPreferences.dailyReportEquipmentEnabled && self.companyPreferences.dailyReportMaterialsEnabled){
        count = 1;
        self.dailyReportItem = @[@"0",@"1",@"3",@"4",@"5"];
    }
    else
    {
        count = 2;
       self.dailyReportItem = @[@"0",@"1",@"4",@"5"];
    }
    
    return 6-count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    int item = [self.dailyReportItem[indexPath.row] intValue];

    if (item == 0)
    {
        cell.textLabel.text = @"Comments";
        cell.imageView.image = [UIImage imageNamed:@"commentsIcon.png"];
    }
    else if (item == 1)
    {
        cell.textLabel.text = @"Crews";
        cell.imageView.image = [UIImage imageNamed:@"crewIcon.png"];
    }
    else if (item == 2)
    {
        cell.textLabel.text = @"Equipment";
        cell.imageView.image = [UIImage imageNamed:@"equipmentIcon.png"];
    }
    else if (item == 3)
    {
        cell.textLabel.text = @"Materials";
        cell.imageView.image = [UIImage imageNamed:@"materialsIcon.png"];
    }
    else if (item == 4)
    {
        cell.textLabel.text = @"Attachments / Photos";
        cell.imageView.image = [UIImage imageNamed:@"attachmentIcon.png"];
    }
    else if (item == 5)
    {
        NSString *weatherStr = @" ";
        NSString *str = [self getWeather:self.dr.weatherId];
        if (str)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Weather : %@", str];
        }
        else
        {
            cell.textLabel.text = @"Weather";
        }
        str = [self getWind:self.dr.windId];
        if (str)
        {
            cell.detailTextLabel.text = [weatherStr stringByAppendingFormat:@"Wind : %@ Temperature : %lu", str, (unsigned long)self.dr.temperature];
        }
        else
        {
            cell.detailTextLabel.text = @"Wind:";
        }

        if (self.dr.weatherIcon)
        {
            NSString *filename = [self.dr.weatherIcon lastPathComponent];
            NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[pathArray objectAtIndex:0] stringByAppendingPathComponent:filename];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            }
            else
            {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                NSError *error = nil;
                NSLog(@"Get URL for image : %@", self.dr.weatherIcon);
                NSString *encodedText = [self.dr.weatherIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if ([NSURL URLWithString:encodedText])
                {
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
                    if (imageData.length)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                             NSError *error;
                            if (![imageData writeToFile:filePath options:NSDataWritingAtomic error:&error])
                            {
                                NSLog(@"WriteToFile failed DailyReportTableViewController: %@", error);
                            }
                            cell.imageView.image = [UIImage imageWithData:imageData];
                            [self.tableView reloadData];
                        });
                    }
                    else
                    {
                        NSLog(@"No image data for weatherIcon : %@ error : %@", self.dr.weatherIcon, [error localizedDescription]);
                    }
                }
                else
                {
                    NSLog(@"NSURL returned nil");
                }
            });
            }
        }
    }

    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int item = [self.dailyReportItem[indexPath.row] intValue];

    if (item == 0)
    {
        CommentsTableViewController *vc = [[CommentsTableViewController alloc] initWithNibName:@"CommentsTableViewController" bundle:nil];
        vc.projectId = self.projectId;
        vc.dailyReports = self.dailyReports;
        vc.dailyReportId = self.dailyReportId;
        vc.dr = self.dr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (item == 1)
    {
        CrewLogTableViewController *vc = [[CrewLogTableViewController alloc] initWithNibName:@"CrewLogTableViewController" bundle:nil];
        vc.title = self.title;
        vc.reportName = self.reportName;
        vc.dailyReportId = self.dailyReportId;
        vc.drDate = self.drDate;
        vc.projectId = self.projectId;
        vc.activity = self.activity;
        vc.workType = self.workType;
        vc.employee = self.employee;
        vc.companyPreferences = self.companyPreferences;
        vc.systemPhases = self.systemPhases;
        vc.employeeList = self.employeeList;
        vc.dr = self.dr;

        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (item == 2)
    {
        EquipmentTableViewController *vc = [[EquipmentTableViewController alloc] initWithNibName:@"EquipmentTableViewController" bundle:nil];
        vc.dailyReportId = self.dailyReportId;
        vc.drDate = self.drDate;
        vc.projectId = self.projectId;
        vc.projectEquipment = self.projectEquipment;
        vc.dr = self.dr;

        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (item == 3)
    {
        MaterialsTableViewController *vc = [[MaterialsTableViewController alloc] initWithNibName:@"MaterialsTableViewController" bundle:nil];
        vc.dailyReportId = self.dailyReportId;
        vc.projectId = self.projectId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (item == 4)
    {
        AttachmentsPhotosTableViewController *vc = [[AttachmentsPhotosTableViewController alloc] initWithNibName:@"AttachmentsPhotosTableViewController" bundle:nil];
        
        vc.projectId = self.projectId;
        vc.projectObject = self.projectObject;
        vc.dailyReportId = self.dailyReportId;
        vc.dr = self.dr;
    
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (NSString *) getWeather:(NSInteger) id
{
    
    for (WeatherObject *w in self.weatherObjects)
    {
        if (id == w.code)
        {
            return w.weather;
        }
    }
    return nil;
}

- (NSString *) getWind:(NSInteger) id
{
    
    for (WindObject *w in self.windObjects)
    {
        if (id == w.windId)
        {
            return w.name;
        }
    }
    return nil;
}

@end
