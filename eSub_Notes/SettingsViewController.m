//
//  SettingsViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/17/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "SettingTableCellTableViewCell.h"
@interface SettingsViewController ()
@property (nonatomic,strong) NSArray *settingArr;
@property (nonatomic,strong) NSArray *settingImage;
@property (nonatomic,strong) NSArray *settingInfo;
@end

@implementation SettingsViewController

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
//    self.settingArr = @[kDailyReportWeb,kProjectSummary,kLaborActivity,kChangeOrderLog,kRFILog,kSubmittalLog,kPurchaseOrderLog,kMeetingLog,kCorrespondence,kLaborSummary,kCostReport];
//    self.settingImage = @[@"DailyReports.png",@"ProjectSummary.png",@"PercentForecast.png",@"DailyReports.png",@"RFILog.png",@"SubmittalLog.png",@"PurchaseOrderLog.png",@"Meeting Minutes.png",@"CorrespondanceToolbox.png",@"LaborActivitySummary.png",@"CosttoComplete.png"];
//    self.settingInfo = @[@"Daily Report (Web)",@"Project Summary(Web)",@"Percent Complete Forecast(Web)",@"Change Order log(Web)",@"RFI Log(Web)",@"Submittal Log(Web)",@"Purchase order log(Web)",@"Meeting minutes log(Web)",@"Correspondence toolbox(Web)",@"Labor Activity Summary(Web)",@"Cost to Complete report(Web)"];
    self.settingArr = @[kDailyReportWeb,kProjectSummary,kLaborActivity,kSubmittalLog,kMeetingLog,kCorrespondence,kEquipmentRental];
    self.settingImage = @[@"DailyReports.png",@"ProjectSummary.png",@"PercentForecast.png",@"SubmittalLog.png",@"MeetingMinutes.png",@"CorrespondanceToolbox.png",@"EquipmentRental.png"];
    
    self.settingInfo = @[@"Daily Report (Web)",@"Project Summary(Web)",@"Percent Complete Forecast(Web)",@"Submittal Log(Web)",@"Meeting minutes log(Web)",@"Correspondence toolbox(Web)",@"Equipment Rental(Web)"];

    [self.navigationController setNavigationBarHidden:NO];
    //    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 0.0/255.0 green: 255.0/255.0 blue:255.0/255.0 alpha: 1.0];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];

    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    self.view.backgroundColor = [UIColor grayColor];

/*
    UIImage *image = [UIImage imageNamed: @"eSub_nav.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    self.navigationItem.titleView = imageView;
*/

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Settings";
    self.navigationItem.titleView = label;

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


}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

//    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
}

- (void) viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    
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
    
    return 7;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SettingTableCellTableViewCell *cell = (SettingTableCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[SettingTableCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell.checkBox addTarget:self action:@selector(myCustomFunction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.checkBox.tag = indexPath.row;
    cell.infoImage.image = [UIImage imageNamed:self.settingImage[indexPath.row]];
    cell.checkBox.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:self.settingArr[indexPath.row]] boolValue];
    cell.infoLabel.text = self.settingInfo[indexPath.row];
    
    return cell;


    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)myCustomFunction:(id)sender
{
    
    UIButton *button = (id)sender;

    button.selected = !button.selected;
    
    switch (button.tag)
    {
        case 0:
            NSLog(@"Value : %@", [[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb]);
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", button.selected] forKey:kDailyReportWeb];
            break;
        case 1:
            NSLog(@"Value : %@", [[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary]);
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", button.selected] forKey:kProjectSummary];
            break;
        case 2:
            NSLog(@"Value : %@", [[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity]);
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", button.selected] forKey:kLaborActivity];
            break;
        case 3:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", button.selected] forKey:kSubmittalLog];
            break;
        case 4:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", button.selected] forKey:kMeetingLog];
            break;
        case 5:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", button.selected] forKey:kCorrespondence];
            break;
        case 6:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", button.selected] forKey:kEquipmentRental];
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
