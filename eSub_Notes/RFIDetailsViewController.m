//
//  RFIDetailsViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/11/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "RFIDetailsViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "RFIDownloadAFHTTPClient.h"

@interface RFIDetailsViewController ()

@end

@implementation RFIDetailsViewController

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
    label.text = self.projectObject.projectName;
    self.navigationItem.titleView = label;
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    NSString *txt1 = @"";
    if (self.rfiObject.revision > 0)
    {
        txt1 = [NSString stringWithFormat:@"-%lu", (unsigned long)self.rfiObject.revision];
    }
    title.text = [NSString stringWithFormat:@"%@%@ %@", self.rfiObject.rfiNumber, txt1, self.rfiObject.rfiSubject];
    title.textAlignment = NSTextAlignmentCenter;
    
    [statusView addSubview:title];

    self.rfiDetailsTableView.tableHeaderView = statusView;

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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    
    return @"RFI Details";
    
}
*/

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    NSDateFormatter *formatter;
    NSString *txt;
    NSDate *date;
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"Status: %@", self.rfiObject.rfiStatus];
            break;
            
        case 1:
            txt = @"n/a";
            if (self.rfiObject.rfiDate != (id)[NSNull null])
            {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                date = [formatter dateFromString:self.rfiObject.rfiDate];
                [formatter setDateFormat:@"MM/dd/yy"];
                txt = [formatter stringFromDate:date];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"Date: %@", txt];
            break;

        case 2:
            txt = @"n/a";
            if (self.rfiObject.rfiDueDate != (id)[NSNull null])
            {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                date = [formatter dateFromString:self.rfiObject.rfiDueDate];
                [formatter setDateFormat:@"MM/dd/yy"];
                txt = [formatter stringFromDate:date];
            }

            cell.textLabel.text = [NSString stringWithFormat:@"Due Date: %@", txt];
            break;

        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"Total Attachments: %lu Documents", (unsigned long)self.rfiObject.rfiAttachments.count];
            break;

        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"Question: %@", self.rfiObject.rfiQuestion];
            break;

        case 5:
            cell.textLabel.text = [NSString stringWithFormat:@"Answer: %@", self.rfiObject.rfiAnswer];
            break;
            
        case 6:
            cell.textLabel.text = @"Download RFI document";
            break;

        default:
            break;
    }
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 3 && self.rfiObject.rfiAttachments.count > 0)
    {
        RFIAttachmentsViewController *rfiAttachmentsVC = [[RFIAttachmentsViewController alloc] initWithNibName:@"RFIAttachmentsViewController" bundle:nil];
        rfiAttachmentsVC.projectObject = self.projectObject;
        rfiAttachmentsVC.rfiObject = self.rfiObject;
    
        [self.navigationController pushViewController:rfiAttachmentsVC animated:YES];
    }
    else if (indexPath.row == 6)
    {
   
        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        
        [DejalBezelActivityView activityViewForView:self.view];
        
        RFIDownloadAFHTTPClient *httpClient = [RFIDownloadAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInt:(int)self.rfiObject.id]  forKey:@"Id"];
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:@"RFI/Download"
                                                          parameters:params];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSData *responseObject)
         {
             [DejalBezelActivityView removeViewAnimated:YES];
             
             if (responseObject.length)
             {
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString *documentsDirectory = [paths objectAtIndex:0];
                 
                 NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.pdf"];
                 [responseObject writeToFile:appFile atomically:YES];
                 NSURL *url = [[NSURL alloc] initFileURLWithPath:appFile];
                 if (url)
                 {
                     UIDocumentInteractionController *controller;
                     controller = [UIDocumentInteractionController interactionControllerWithURL:url];
                     controller.delegate = self;
                     [controller presentPreviewAnimated:YES];
                 }
             }
             
         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [DejalBezelActivityView removeViewAnimated:YES];
             NSLog(@"Error: %@", error);
         }];
        [operation start];

    }
    
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    
    return self;
    
}

@end
