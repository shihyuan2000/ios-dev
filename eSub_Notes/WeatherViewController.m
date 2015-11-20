//
//  WeatherViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/22/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "WeatherViewController.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

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
    label.text = @"Weather";
    self.navigationItem.titleView = label;

// http://api.worldweatheronline.com/premium/v1/weather.ashx?q=33.029198,-117.184406&format=json&num_of_days=1extra=localObsTime&includeLocation=yes&key=y5bem3d6f2szrvaccxsgg9c5

    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:@"http://api.worldweatheronline.com/premium/v1/weather.ashx"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"33.029198,-117.184406" forKey:@"q"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"1extra=localObsTime" forKey:@"num_of_days"];
    [params setObject:@"yes" forKey:@"includeLocation"];
    [params setObject:@"y5bem3d6f2szrvaccxsgg9c5" forKey:@"key"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];;
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            NSLog(@"Network error in download Daily Reports: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    
    [operation start];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];

}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

@end
