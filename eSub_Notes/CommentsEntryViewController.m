//
//  CommentsEntryViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 3/10/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "CommentsEntryViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Common.h"
#import "SaveNoteAFHTTPClient.h"

@interface CommentsEntryViewController ()

@end

@implementation CommentsEntryViewController

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
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sButton.layer.borderWidth = 1;
//    sButton.layer.borderColor = [UIColor blackColor].CGColor;
    sButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sButton setTitle:@"Save" forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    if (self.dr.isEditable)
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:save, nil];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = self.headerTitle;
    self.navigationItem.titleView = label;
    
    self.commentTextView.text = self.comment;
    
    [[self.commentTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentTextView layer] setBorderWidth:2];
    self.commentTextView.font = [UIFont systemFontOfSize:17];

    self.internalButton.hidden = YES;
    self.internalLabel.hidden = YES;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleBlackOpaque;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resetView)];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];

    self.commentTextView.inputAccessoryView = toolbar;

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

    [self.commentTextView setContentOffset: CGPointMake(0, 0) animated:YES];
    
    if (self.showInternal)
    {
        self.internalButton.hidden = NO;
        self.internalLabel.hidden = NO;
        
        [self.internalButton addTarget:self action:@selector(myCustomFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self.internalButton setBackgroundImage:[UIImage imageNamed:@"checkboxborder.png"] forState:UIControlStateNormal];
        [self.internalButton setBackgroundImage:[UIImage imageNamed:@"checkboxmarkedborder.png"] forState:UIControlStateSelected];
        self.internalButton.selected = self.internal;
    }
    else
    {
        self.internalButton.hidden = YES;
        self.internalLabel.hidden = YES;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myCustomFunction:(id)sender
{
    
    UIButton *button = (id)sender;
    
    button.selected = !button.selected;

}

- (void)resetView
{
    
    [self.view endEditing:YES];
    
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) saveDetails
{

    switch (self.section)
    {
        case 0:
            self.dr.communicationWithOthers = self.commentTextView.text;
            break;
        case 1:
            self.dr.scheduleCoordination = self.commentTextView.text;
            break;
        case 2:
            self.dr.extraWork = self.commentTextView.text;
            self.dr.extraWorkIsInternal = self.internalButton.selected;
            break;
        case 3:
            self.dr.accidentReport = self.commentTextView.text;
            self.dr.accidentReportIsInternal = self.internalButton.selected;
            break;
        case 4:
            self.dr.subcontractors = self.commentTextView.text;
            self.dr.subcontractorsIsInternal = self.internalButton.selected;
            break;
        case 5:
            self.dr.otherVisitors = self.commentTextView.text;
            self.dr.otherVisitorsIsInternal = self.internalButton.selected;
            break;
        case 6:
            self.dr.problems = self.commentTextView.text;
            self.dr.problemsIsInternal = self.internalButton.selected;
            break;
        case 7:
            self.dr.internal = self.commentTextView.text;
        default:
            break;
    }

    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    self.dr.number = @"This DR has not been saved";
    [appD.eSubsDB deleteDailyReport:self.projectId forUserID:appD.userId forDRId:self.dr.id];
    [appD.eSubsDB insertDailyReports:self.dr forProjectId:self.projectId userId:appD.userId];
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
  
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *comments = [NSMutableDictionary dictionary];
    
    if (self.dr.communicationWithOthers)
    {
        [comments setObject:self.dr.communicationWithOthers forKey:@"CommunicationWithOthers"];
    }
    else
    {
        [comments setObject:@"" forKey:@"CommunicationWithOthers"];
    }
    
    if (self.dr.scheduleCoordination)
    {
        [comments setObject:self.dr.scheduleCoordination forKey:@"ScheduleCoordination"];
    }
    else
    {
        [comments setObject:@"" forKey:@"ScheduleCoordination"];
    }
    
    NSMutableDictionary *extraWork = [NSMutableDictionary dictionary];
    if (self.dr.extraWork)
    {
        [extraWork setObject:self.dr.extraWork forKey:@"Comment"];
        [extraWork setObject:[NSNumber numberWithInteger:self.dr.extraWorkIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [extraWork setObject:@""forKey:@"Comment"];
        [extraWork setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:extraWork forKey:@"ExtraWork"];

    NSMutableDictionary *accidentReport = [NSMutableDictionary dictionary];
    if (self.dr.accidentReport)
    {
        [accidentReport setObject:self.dr.accidentReport forKey:@"Comment"];
        [accidentReport setObject:[NSNumber numberWithInteger:self.dr.accidentReportIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [accidentReport setObject:@"" forKey:@"Comment"];
        [accidentReport setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:accidentReport forKey:@"AccidentReport"];

    NSMutableDictionary *subcontractors = [NSMutableDictionary dictionary];
    if (self.dr.subcontractors)
    {
        [subcontractors setObject:self.dr.subcontractors forKey:@"Comment"];
        [subcontractors setObject:[NSNumber numberWithInteger:self.dr.subcontractorsIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [subcontractors setObject:@"" forKey:@"Comment"];
        [subcontractors setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:subcontractors forKey:@"Subcontractors"];
    
    NSMutableDictionary *otherVisitors = [NSMutableDictionary dictionary];
    if (self.dr.otherVisitors)
    {
        [otherVisitors setObject:self.dr.otherVisitors forKey:@"Comment"];
        [otherVisitors setObject:[NSNumber numberWithInteger:self.dr.otherVisitorsIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [otherVisitors setObject:@"" forKey:@"Comment"];
        [otherVisitors setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:otherVisitors forKey:@"OtherVisitors"];
    
    NSMutableDictionary *problems = [NSMutableDictionary dictionary];
    if (self.dr.problems)
    {
        [problems setObject:self.dr.problems forKey:@"Comment"];
        [problems setObject:[NSNumber numberWithInteger:self.dr.problemsIsInternal] forKey:@"isInternal"];
    }
    else
    {
        [problems setObject:@"" forKey:@"Comment"];
        [problems setObject:[NSNumber numberWithInteger:0] forKey:@"isInternal"];
    }
    [comments setObject:problems forKey:@"Problems"];
    
    if (self.dr.internal)
    {
        [comments setObject:self.dr.internal forKey:@"Internal"];
    }
    else
    {
        [comments setObject:@"" forKey:@"Internal"];
    }

    [data setObject:comments forKey:@"Comments"];
    
// LTS - 2/10/2-15 remove once date field is changed to GMT
/*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:self.dr.date];
    [formatter setDateFormat:@"MM/dd/yy"];
    [data setObject:[formatter stringFromDate:date] forKey:@"drDate"];
*/
    [data setObject:self.dr.date forKey:@"drDate"];
    [data setObject:[NSNumber numberWithInteger:self.dr.employeeFromId] forKey:@"drFrom"];
    [data setObject:[NSNumber numberWithInteger:self.dr.id] forKey:@"dailyReportId"];
    [data setObject:[NSNumber numberWithInteger:self.projectId] forKey:@"ProjectId"];
    [data setObject:[NSNumber numberWithInteger:self.dr.weatherId] forKey:@"Weather"];
    [data setObject:[NSNumber numberWithInteger:self.dr.windId] forKey:@"Wind"];
    [data setObject:[NSNumber numberWithFloat:self.dr.temperature] forKey:@"Temperature"];
    [data setObject:self.dr.weatherIcon?self.dr.weatherIcon:@"" forKey:@"WeatherIconValue"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];

    NSURLRequest *request = [client requestWithMethod:@"PUT" path:@"DR" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [appD.eSubsDB deleteDailyReport:self.projectId forUserID:appD.userId forDRId:self.dr.id];
            self.dr.number = @"";
            [appD.eSubsDB insertDailyReports:self.dr forProjectId:self.projectId userId:appD.userId];
            [self.navigationController popViewControllerAnimated:YES];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to local store" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    
    [operation start];


    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    
    [self.commentTextView setContentOffset: CGPointMake(0, 0) animated:YES];
    
}

@end
