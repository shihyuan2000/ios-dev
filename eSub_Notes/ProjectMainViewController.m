//
//  ProjectMainViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/3/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "ProjectMainViewController.h"
#import "Common.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"

@interface ProjectMainViewController ()

@property (nonatomic,assign) NSInteger finishCount;
@property (nonatomic,strong) NSArray *settingArr;
@property (nonatomic,strong) NSArray *settingImage;
@property (nonatomic,strong) NSArray *settingInfo;

@end

@implementation ProjectMainViewController

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
//    self.settingArr = @[kDailyReportWeb,kProjectSummary,kLaborActivity,kChangeOrderLog,kRFILog,kSubmittalLog,kPurchaseOrderLog,kMeetingLog,kCorrespondence,kLaborSummary,kCostReport];
//    self.settingImage = @[@"DailyReports.png",@"ProjectSummary.png",@"PercentForecast.png",@"DailyReports.png",@"RFILog.png",@"SubmittalLog.png",@"PurchaseOrderLog.png",@"Meeting Minutes.png",@"CorrespondanceToolbox.png",@"LaborActivitySummary.png",@"CosttoComplete.png"];
//    
//    self.settingInfo = @[@"Daily Report (Web)",@"Project Summary(Web)",@"Percent Complete Forecast(Web)",@"Change Order log(Web)",@"RFI Log(Web)",@"Submittal Log(Web)",@"Purchase order log(Web)",@"Meeting minutes log(Web)",@"Correspondence toolbox(Web)",@"Labor Activity Summary(Web)",@"Cost to Complete report(Web)"];
    self.settingArr = @[kDailyReportWeb,kProjectSummary,kLaborActivity,kSubmittalLog,kMeetingLog,kCorrespondence,kEquipmentRental];

    self.settingImage = @[@"DailyReports.png",@"ProjectSummary.png",@"PercentForecast.png",@"SubmittalLog.png",@"MeetingMinutes.png",@"CorrespondanceToolbox.png",@"EquipmentRental.png"];
    
    self.settingInfo = @[@"Daily Report (Web)",@"Project Summary(Web)",@"Percent Complete Forecast(Web)",@"Submittal Log(Web)",@"Meeting minutes log(Web)",@"Correspondence toolbox(Web)",@"Equipment Rental(Web)"];
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

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 140)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 480, 18)];
    NSString *txt1;
    NSString *txt2;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    txt1 = @"";
    if (self.projectObject.projectName != (id)[NSNull null] && self.projectObject.projectName.length > 0)
    {
        txt1 = self.projectObject.projectName;
    }
    txt2 = @"";
    if (self.projectObject.projectNumber != (id)[NSNull null] && self.projectObject.projectNumber.length > 0)
    {
        txt2 = self.projectObject.projectNumber;
    }
    label.text = [NSString stringWithFormat:@"%@ - %@", txt2, txt1];
    [headerView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 480, 18)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    txt1 = @"";
    if (self.projectObject.projectStartDate != (id)[NSNull null] && self.projectObject.projectStartDate.length > 0)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [formatter dateFromString:self.projectObject.projectStartDate];
        [formatter setDateFormat:@"MM/dd/yy"];
        txt1 = [formatter stringFromDate:date];
    }
    label.text = [NSString stringWithFormat:@"Start date: %@", txt1];
    [headerView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 480, 18)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    txt1 = @"";
    if (self.projectObject.projectEndDate != (id)[NSNull null] && self.projectObject.projectEndDate.length > 0)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [formatter dateFromString:self.projectObject.projectEndDate];
        [formatter setDateFormat:@"MM/dd/yy"];
        txt1 = [formatter stringFromDate:date];
    }
    label.text = [NSString stringWithFormat:@"End date:  %@", txt1];
    [headerView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 480, 18)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    txt1 = @"";
    if (self.projectObject.projectComments != (id)[NSNull null] && self.projectObject.projectComments.length > 0)
    {
        txt1 = self.projectObject.projectComments;
    }
    label.text = [NSString stringWithFormat:@"Comments: %@", txt1];
    [headerView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 72, 480, 18)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    label.text = @"Project address:";
    [headerView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(122, 72, 250, 100)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    label.text = [NSString stringWithFormat:@"%@", [Common makeAddress:self.projectObject.projectLocation.address]];
    [label setNumberOfLines:0];
    [label sizeToFit];
    [headerView addSubview:label];
    
    UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollButton setImage:[UIImage imageNamed:@"map_icon.png"] forState:UIControlStateNormal];
    scrollButton.frame = CGRectMake(70, 90, 40, 40);
    [scrollButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:scrollButton];
    
    self.projectMainTableView.tableHeaderView = headerView;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = self.projectObject.projectName;
    self.navigationItem.titleView = label;

    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.contacts = [appD.eSubsDB getContactObjects:self.projectObject.id];
        self.activity = [appD.eSubsDB getActivity:appD.userId forProjectId:self.projectObject.id];
        self.workType = [appD.eSubsDB getWorkType:appD.userId forProjectId:self.projectObject.id];
        self.employee = [appD.eSubsDB getEmployee:appD.userId forProjectId:self.projectObject.id];
        self.companyPreferences = [appD.eSubsDB getCompanyPreferences:appD.userId forProjectId:self.projectObject.id];
        self.systemPhases = [appD.eSubsDB getSystemPhases:appD.userId forProjectId:self.projectObject.id];
        self.weatherObjects = [appD.eSubsDB getWeatherObjects];
        self.windObjects = [appD.eSubsDB getWindObjects];
        self.projectEquipment = [appD.eSubsDB getProjectEquipmentObjects:self.projectObject.id];
    }
    else
    {
        //[DejalBezelActivityView activityViewForView:self.view];
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        //加载到页面上
        [self.view addSubview:_HUD];
        _HUD.dimBackground = YES;
        _HUD.delegate = self;//设代理
        _HUD.labelText = @"Loading...";//写字
        [_HUD show:TRUE];
        self.finishCount = 0;
        [self getAllInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllInfo {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [self getListOfContacts];
    });
    dispatch_group_async(group, queue, ^{
        [self getDataFromWebService];
    });
    dispatch_group_async(group, queue, ^{
        [self getCompanyPreferences];
    });
    dispatch_group_async(group, queue, ^{
        [self getWeatherAndWind];
    });
    dispatch_group_async(group, queue, ^{
        [self getListOfProjectEquipment];
    });
    //下面的方法没用，暂时不知道原因，换个思路
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        [DejalBezelActivityView removeViewAnimated:YES];
//    });
}

- (void) getListOfContacts
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    [Common GetListOfContacts:(int)self.projectObject.id
        success:^(NSMutableArray *c)
        {
            NSLog(@"Date = %@",[NSDate date]);
            [appD.eSubsDB deleteContactObjects:self.projectObject.id];
            
            NSMutableArray *contacts = [[NSMutableArray alloc] init];
            for (ContactsObject *contact in c)
            {
                NSMutableArray *m = contact.contactAddresses;
                for (ContactAddressObject *address in m)
                {
                    NSLog(@"%@ %@ - %@", contact.contactFirstname, contact.contactLastname, address.type);
                    if ([address.type isEqualToString:@"Employee"])
                    {
                        if (![contacts containsObject:contact])
                        {
                            [contacts addObject:contact];
                            [appD.eSubsDB insertContactObject:contact forProjectId:self.projectObject.id];
                        }
                    }
                }
            }
            self.contacts = contacts;
            self.finishCount++;
            if (self.finishCount > 4) {
                //[DejalBezelActivityView removeViewAnimated:YES];
                [_HUD hide:TRUE];
            }
            //[self getDataFromWebService];
        }
        failure:^(NSHTTPURLResponse *response, NSError *error)
        {
            //[DejalBezelActivityView removeViewAnimated:YES];
             [_HUD hide:TRUE];
            NSInteger code = [response statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            NSLog(@"Network error in downloading Contacts: %@", [error localizedDescription]);
        }];
}

- (void) getDataFromWebService
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)self.projectObject.id] forKey:@"projectID"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"DR/Dictionary" parameters:params];
    //NSLog(@"URL-Web = %@,Date = %@",request.URL,[NSDate date]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            for (NSString *key in dic.allKeys) {
                if ([key isEqualToString:@"Activity"]) {
                    if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
                        continue;
                    }
                    NSArray *data = [dic objectForKey:key];
                    if (data.count)
                    {
                        [appD.eSubsDB deleteActivity:self.projectObject.id forUserID:appD.userId];
                        self.activity = nil;
                        self.activity = [[NSMutableArray alloc] init];
                        for (NSDictionary *mdata in data)
                        {
                            ActivityObject *activity = [[ActivityObject alloc] init];
                            if ([mdata objectForKey:@"Id"] != [NSNull null])
                            {
                                activity.id = [[mdata objectForKey:@"Id"] integerValue];
                            }
                            
                            if ([mdata objectForKey:@"Code"] != [NSNull null])
                            {
                                activity.code = [mdata objectForKey:@"Code"];
                            }
                            if ([mdata objectForKey:@"Name"] != [NSNull null])
                            {
                                activity.name = [mdata objectForKey:@"Name"];
                            }
                            [appD.eSubsDB insertActivity:activity forProjectId:self.projectObject.id userId:appD.userId];
                            [self.activity addObject:activity];
                            NSLog(@"Activity : %@", mdata);
                        }
                    }
                }
                if ([key isEqualToString:@"WorkType"]) {
                    if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
                        continue;
                    }
                    NSArray *data = [dic objectForKey:key];
                    if (data.count)
                    {
                        [appD.eSubsDB deleteWorkType:self.projectObject.id forUserID:appD.userId];
                        self.workType = nil;
                        self.workType = [[NSMutableArray alloc] init];
                        for (NSDictionary *mdata in data)
                        {
                            WorkTypeObject *workType = [[WorkTypeObject alloc] init];
                            if ([mdata objectForKey:@"WorkType"] != [NSNull null])
                            {
                                workType.type = [mdata objectForKey:@"WorkType"];
                            }
                            if ([mdata objectForKey:@"WorkTypeID"] != [NSNull null])
                            {
                                workType.id = [[mdata objectForKey:@"WorkTypeID"] integerValue];
                            }
                            if ([mdata objectForKey:@"WorkTypeShow"] != [NSNull null])
                            {
                                workType.show = [[mdata objectForKey:@"WorkTypeShow"] integerValue];
                            }
                            [appD.eSubsDB insertWorkType:workType forProjectId:self.projectObject.id userId:appD.userId];
                            [self.workType addObject:workType];
                            //NSLog(@"Work Type : %@", mdata);
                        }
                    }
                }

                if ([key isEqualToString:@"Employee"]) {
                    if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
                        continue;
                    }
                    NSArray *data = [dic objectForKey:key];
                    if (data.count)
                    {
                        [appD.eSubsDB deleteEmployee:self.projectObject.id forUserID:appD.userId];
                        self.employee = nil;
                        self.employee = [[NSMutableArray alloc] init];
                        for (NSDictionary *mdata in data)
                        {
                            EmployeeObject *employee = [[EmployeeObject alloc] init];
                            if ([mdata objectForKey:@"Id"] != [NSNull null])
                            {
                                employee.id = [[mdata objectForKey:@"Id"] integerValue];
                            }
                            if ([mdata objectForKey:@"FirstName"] != [NSNull null])
                            {
                                employee.firstName = [mdata objectForKey:@"FirstName"];
                            }
                            if ([mdata objectForKey:@"LastName"] != [NSNull null])
                            {
                                employee.lastName = [mdata objectForKey:@"LastName"];
                            }
                            if ([mdata objectForKey:@"LaborClassId"] != [NSNull null])
                            {
                                employee.laborClassId = [[mdata objectForKey:@"LaborClassId"] integerValue];
                            }
                            if ([mdata objectForKey:@"Number"] != [NSNull null])
                            {
                                employee.number = [mdata objectForKey:@"Number"];
                            }
                            [appD.eSubsDB insertEmployee:employee forProjectId:self.projectObject.id userId:appD.userId];
                            [self.employee addObject:employee];
                            NSLog(@"Employee : %@", mdata);
                        }
                    }
                }
                
                if ([key isEqualToString:@"SystemPhase"]) {
                    if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
                        continue;
                    }
                    NSArray *data = [dic objectForKey:key];
                    if (data.count)
                    {
                        [appD.eSubsDB deleteSystemPhases:self.projectObject.id forUserID:appD.userId];
                        self.systemPhases = nil;
                        self.systemPhases = [[NSMutableArray alloc] init];
                        for (NSDictionary *mdata in data)
                        {
                            SystemPhase *systemPhase = [[SystemPhase alloc] init];
                            if ([mdata objectForKey:@"SystemId"] != [NSNull null])
                            {
                                systemPhase.systemId = [[mdata objectForKey:@"SystemId"] integerValue];
                            }
                            if ([mdata objectForKey:@"SystemName"] != [NSNull null])
                            {
                                systemPhase.systemName = [mdata objectForKey:@"SystemName"];
                            }
                            if ([mdata objectForKey:@"PhaseNumberId"] != [NSNull null])
                            {
                                systemPhase.phaseId = [[mdata objectForKey:@"PhaseNumberId"] integerValue];
                            }
                            if ([mdata objectForKey:@"PhaseName"] != [NSNull null])
                            {
                                systemPhase.phaseName = [mdata objectForKey:@"PhaseName"];
                            }
                            [appD.eSubsDB insertSystemPhases:systemPhase forProjectId:self.projectObject.id userId:appD.userId];
                            [self.systemPhases addObject:systemPhase];
                            NSLog(@"System Phase : %@", mdata);
                            
                        }
                    }
                }
            }
            self.finishCount++;
            if (self.finishCount > 4) {
//                [DejalBezelActivityView removeViewAnimated:YES];
                 [_HUD hide:TRUE];
            }
            //[self getCompanyPreferences];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
//            [DejalBezelActivityView removeViewAnimated:YES];
             [_HUD hide:TRUE];
            NSInteger code = [response statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    
    [operation start];
}

- (void) getCompanyPreferences
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Subscriber/Preferences" parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            NSLog(@"Date3 = %@",[NSDate date]);
            [appD.eSubsDB deleteCompanyPreferences:self.projectObject.id forUserID:appD.userId];
            self.companyPreferences = nil;
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                self.companyPreferences = [[CompanyPreferencesObject alloc] init];
                for (NSDictionary *mdata in data)
                {
                    if ([mdata objectForKey:@"DailyReportDoubleTimeEnabled"] != [NSNull null])
                    {
                        self.companyPreferences.dailyReportDoubleTimeEnabled = [[mdata objectForKey:@"DailyReportDoubleTimeEnabled"] integerValue];
                    }
                    if ([mdata objectForKey:@"DailyReportOvertimeEnabled"] != [NSNull null])
                    {
                        self.companyPreferences.dailyReportOvertimeEnabled = [[mdata objectForKey:@"DailyReportOvertimeEnabled"] integerValue];
                    }
                    if ([mdata objectForKey:@"DailyReportUnitTrackingEnabled"] != [NSNull null])
                    {
                        self.companyPreferences.dailyReportUnitTrackingEnabled = [[mdata objectForKey:@"DailyReportUnitTrackingEnabled"] integerValue];
                    }
                    if ([mdata objectForKey:@"DailyReportEquipmentEnabled"] != [NSNull null]) {
                        self.companyPreferences.dailyReportEquipmentEnabled= [[mdata objectForKey:@"DailyReportEquipmentEnabled"] integerValue];
                    }
                    if ([mdata objectForKey:@"DailyReportMaterialsEnabled"] != [NSNull null]) {
                        self.companyPreferences.dailyReportMaterialsEnabled= [[mdata objectForKey:@"DailyReportMaterialsEnabled"] integerValue];
                    }
                    [appD.eSubsDB insertCompanyPreferences:self.companyPreferences forProjectId:self.projectObject.id userId:appD.userId];
                }
            }
            //[self getWeatherAndWind];
            self.finishCount++;
            if (self.finishCount >4) {
//                [DejalBezelActivityView removeViewAnimated:YES];
                 [_HUD hide:TRUE];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
//            [DejalBezelActivityView removeViewAnimated:YES];
             [_HUD hide:TRUE];
            NSInteger code = [response statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            NSLog(@"Network error in download Company Preferences: %@", [error localizedDescription]);
        }];
    
    [operation start];
}

- (void) getWeatherAndWind
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Weather/Dictionary" parameters:nil];
    NSLog(@"URL-Web - 4 = %@,Date = %@",request.URL,[NSDate date]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSDictionary *d = [data objectForKey:@"Weather"];
            self.weatherObjects = [[NSMutableArray alloc] init];
            [appD.eSubsDB deleteWeatherObjects];
            for (NSDictionary *mdata in d)
            {
                WeatherObject *w = [[WeatherObject alloc] init];
                if ([mdata objectForKey:@"WeatherID"] != [NSNull null])
                {
                    w.weatherId = [[mdata objectForKey:@"WeatherID"] integerValue];
                }
                if ([mdata objectForKey:@"Weather"] != [NSNull null])
                {
                    w.weather = [mdata objectForKey:@"Weather"];
                }
                if ([mdata objectForKey:@"ConditionGroup"] != [NSNull null])
                {
                    w.conditionGroup = [mdata objectForKey:@"ConditionGroup"];
                }
                if ([mdata objectForKey:@"Code"] != [NSNull null])
                {
                    w.code = [[mdata objectForKey:@"Code"] integerValue];
                }
                [self.weatherObjects addObject:w];
                [appD.eSubsDB insertWeatherObject:w];
                NSLog(@"Weather : %@", mdata);
            }
            d = [data objectForKey:@"Wind"];
            [appD.eSubsDB deleteWindObjects];
            self.windObjects = [[NSMutableArray alloc] init];
            for (NSDictionary *mdata in d)
            {
                WindObject *w = [[WindObject alloc] init];
                if ([mdata objectForKey:@"WindID"] != [NSNull null])
                {
                    w.windId = [[mdata objectForKey:@"WindID"] integerValue];
                }
                if ([mdata objectForKey:@"Name"] != [NSNull null])
                {
                    w.name = [mdata objectForKey:@"Name"];
                }
                [self.windObjects addObject:w];
                [appD.eSubsDB insertWindObject:w];
                NSLog(@"Wind : %@", mdata);
            }
            //[self getListOfProjectEquipment];
            self.finishCount++;
            if (self.finishCount > 4) {
//                [DejalBezelActivityView removeViewAnimated:YES];
                 [_HUD hide:TRUE];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
//            [DejalBezelActivityView removeViewAnimated:YES];
             [_HUD hide:TRUE];
            NSInteger code = [response statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            NSLog(@"Network error in download of Weather dictionary: %@", [error localizedDescription]);
        }];
    
    [operation start];
}

- (void) getListOfProjectEquipment
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)self.projectObject.id]  forKey:@"projectID"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Equipment" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [appD.eSubsDB deleteProjectEquipmentObjects:self.projectObject.id];
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                self.projectEquipment = [[NSMutableArray alloc] init];
                for (NSDictionary *mdata in data)
                {
                    EquipmentObject *equipment = [[EquipmentObject alloc] init];
                    if ([mdata objectForKey:@"EquipmentID"] != [NSNull null])
                    {
                        equipment.equipmentId = [[mdata objectForKey:@"EquipmentID"] integerValue];
                    }
                    if ([mdata objectForKey:@"Equipment"] != [NSNull null])
                    {
                        equipment.equipment = [mdata objectForKey:@"Equipment"];
                    }
                    if ([mdata objectForKey:@"Code"] != [NSNull null])
                    {
                        equipment.code = [mdata objectForKey:@"Code"];
                    }
                    if ([mdata objectForKey:@"Asset"] != [NSNull null])
                    {
                        equipment.asset = [[mdata objectForKey:@"Asset"] integerValue];
                    }
                    [self.projectEquipment addObject:equipment];
                    [appD.eSubsDB insertProjectEquipmentObject:equipment forProjectId:self.projectObject.id];
                }
            }
            self.finishCount++;
            if (self.finishCount > 4) {
//                [DejalBezelActivityView removeViewAnimated:YES];
                 [_HUD hide:TRUE];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
//            [DejalBezelActivityView removeViewAnimated:YES];
             [_HUD hide:TRUE];
            NSLog(@"Network error in project equipment download %@", [error localizedDescription]);
            NSInteger code = [response statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    
    [operation start];
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) showMap
{
    
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    
    mapVC.location = [[Common makeAddress:self.projectObject.projectLocation.address] stringByReplacingOccurrencesOfString:@"\n"
                                                                                                                withString:@" "];;
    [self.navigationController pushViewController:mapVC animated:YES];
    
}

#pragma mark - UITableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int cnt = 0;
    for (int i=0; i < self.settingArr.count; i++) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:self.settingArr[i]] boolValue]) {
            cnt++;
        }
    }
    return 5 + cnt;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
 
    long cnt;

    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Notes";
        cell.imageView.image = [UIImage imageNamed:@"Notes.png"];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Daily Report";
        cell.imageView.image = [UIImage imageNamed:@"DailyReports.png"];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Project Contacts";
        cell.imageView.image = [UIImage imageNamed:@"Contacts.png"];
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"RFI Log";
        cell.imageView.image = [UIImage imageNamed:@"RFI.png"];
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"Project Uploads";
        cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
    }

    else if (indexPath.row >= 5)
    {
        cnt = [self getIndex:indexPath.row - 4];
        cell.textLabel.text = self.settingInfo[cnt];
        cell.imageView.image = [UIImage imageNamed:self.settingImage[cnt]];
    }

    return cell;
    
}

- (long) getIndex:(long) index
{
    
    int cnt = 0;
    for (int i=0; i < self.settingArr.count; i++) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:self.settingArr[i]] boolValue])
        {
            cnt++;
            if (cnt == index) {
                return i;
            }
        }
    }
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb] boolValue])
//    {
//        cnt++;
//    }
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary] boolValue])
//    {
//        cnt++;
//    }
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity] boolValue])
//    {
//        cnt++;
//    }
//
//    if (cnt == 3)
//    {
//        return index;
//    }
//    
//    if (cnt == 1)
//    {
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb] boolValue])
//        {
//            return 1;
//        }
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary] boolValue])
//        {
//            return 2;
//        }
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity] boolValue])
//        {
//            return 3;
//        }
//    }
//    
//    else
//    {
//        if (index == 1)
//        {
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb] boolValue])
//            {
//                return 1;
//            }
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary] boolValue])
//            {
//                return 2;
//            }
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity] boolValue])
//            {
//                return 3;
//            }
//        }
//        else if (index == 2)
//        {
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb] boolValue])
//            {
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary] boolValue])
//                {
//                    return 2;
//                }
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity] boolValue])
//                {
//                    return 3;
//                }
//            }
//            else
//            {
//                return 3;
//            }
//        }
//        else
//        {
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb] boolValue] &&
//                [[[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary] boolValue])
//            {
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReport] boolValue])
//                {
//                    return 2;
//                }
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity] boolValue])
//                {
//                    return 4;
//                }
//            }
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb] boolValue] &&
//                [[[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity] boolValue])
//            {
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReport] boolValue])
//                {
//                    return 2;
//                }
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary] boolValue])
//                {
//                    return 3;
//                }
//            }
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kProjectSummary] boolValue] &&
//                [[[NSUserDefaults standardUserDefaults] objectForKey:kLaborActivity] boolValue])
//            {
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReportWeb] boolValue])
//                {
//                    return 1;
//                }
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:kDailyReport] boolValue])
//                {
//                    return 2;
//                }
//            }
//        }
//    }
    
    return 0;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long cnt;
    
    if (indexPath.row == 0)
    {
        ProjectDetailsViewController *projectDetailsVC = [[ProjectDetailsViewController alloc] initWithNibName:@"ProjectDetailsViewController" bundle:nil];
        projectDetailsVC.projectObject = self.projectObject;
        projectDetailsVC.projectId = self.projectObject.id;
        [self.navigationController pushViewController:projectDetailsVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        DailyReportLogTableViewController *vc = [[DailyReportLogTableViewController alloc] initWithNibName:@"DailyReportLogTableViewController" bundle:nil];
        vc.projectId = self.projectObject.id;
        vc.projectObject = self.projectObject;
        
        vc.contacts = self.contacts;
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

    else if (indexPath.row == 2)
    {
        ContactsViewController *contactsVC = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
        contactsVC.projectObject = self.projectObject;
        [self.navigationController pushViewController:contactsVC animated:YES];
    }
    else if (indexPath.row == 3)
    {
        RFIViewController *rfiVC = [[RFIViewController alloc] initWithNibName:@"RFIViewController" bundle:nil];
        rfiVC.projectObject = self.projectObject;
        [self.navigationController pushViewController:rfiVC animated:YES];
    }
    else if (indexPath.row == 4)
    {
        UploadsViewController *uploadsVC = [[UploadsViewController alloc] initWithNibName:@"UploadsViewController" bundle:nil];
        uploadsVC.projectId = self.projectObject.id;
        uploadsVC.projectObject = self.projectObject;
        [self.navigationController pushViewController:uploadsVC animated:YES];
    }
    else if (indexPath.row >= 5)
    {
        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        if ([appD.reachability currentReachabilityStatus] == NotReachable)
        {
            return;
        }
        cnt = [self getIndex:indexPath.row - 4];
        WebViewViewController *webViewVC = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:nil];
        webViewVC.projectObject = self.projectObject;
        webViewVC.typeId = cnt;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
}

@end
