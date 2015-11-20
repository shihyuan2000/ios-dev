//
//  WebViewViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 9/20/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "WebViewViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Web Browser";
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
    
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;

}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    ProjectObject *projectObject = self.projectObject;

    NSString *str;
    if ([appD.eSUBServerURL rangeOfString:@".qa."].location == NSNotFound)
    {
        str = @"https://n.esubonline.com/";
    }
    else
    {
        str = @"http://n.qa.esubonline.com/";
    }


//        dailyReport  = 0,
//        projectSummary =1,
//        percentCompleteForecast =2,
//        changeOrderLog =3,
//        RFILog =4,
//        submittalLog =5,
//        purchaseOrderLog =6,
//        meetingMinutesLog =7,
//        correspondenceToolbox =8,
//        laborActivitySummary =9,
//        costCompleteReport = 10

    NSString *urlString;
    if (self.typeId == 1)
    {
        urlString = [NSString stringWithFormat:@"%@Project/Go/%lu/%@", str, (unsigned long)projectObject.id, appD.tokenAccess];
    }
    else if (self.typeId == 0)
    {
        urlString = [NSString stringWithFormat:@"%@Project/Go/%lu/%@/DailyReports/Enter", str, (unsigned long)projectObject.id, appD.tokenAccess];
    }
    else if (self.typeId == 2)
    {
        urlString = [NSString stringWithFormat:@"%@/Project/Go/%lu/%@/Timecards/LaborActivityPercentCompleteForecast", str, (unsigned long)projectObject.id, appD.tokenAccess];
    }
    else if(self.typeId == 3)
    {
        urlString = [NSString stringWithFormat:@"%@/Project/Go/%lu/%@/Transubmittals/Submittallog", str, (unsigned long)projectObject.id, appD.tokenAccess];

    }
    else if(self.typeId == 4)
    {
        urlString = [NSString stringWithFormat:@"%@/Project/Go/%lu/%@/Meeting/Minutes", str, (unsigned long)projectObject.id, appD.tokenAccess];

    }
    else if(self.typeId == 5)
    {
        urlString = [NSString stringWithFormat:@"%@/Project/Go/%lu/%@/CorrespondenceToolbox", str, (unsigned long)projectObject.id, appD.tokenAccess];
    }
    else if(self.typeId == 6)
    {
        urlString = [NSString stringWithFormat:@"%@/Project/Go/%lu/%@/EquipmentRental/Log", str, (unsigned long)projectObject.id, appD.tokenAccess];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.webView = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) backAction
{
    
    [self.webView goBack];
    
}

- (void) forwardAction
{
    
    [self.webView goForward];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [DejalBezelActivityView activityViewForView:self.view];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [DejalBezelActivityView removeViewAnimated:YES];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    [DejalBezelActivityView removeViewAnimated:YES];

}

@end
