//
//  RFIViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/9/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "RFIViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "RFIObject.h"
#import "RFIAttachment.h"

NSString *CurrentStatus = @"All";

@interface RFIViewController ()

@end

@implementation RFIViewController

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

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadRFIs:) forControlEvents:UIControlEventValueChanged];
    [self.rfiTableView addSubview:refreshControl];

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if (!self.rfis)
    {
        [self getRFIs];
    }
    
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

- (void) getRFIs
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        /*
         self.categories = [[NSMutableArray alloc] init];
         self.uploads = [appD.eSubsDB getUploadObjects:appD.userId forProjectId:self.projectId];
         for (UploadObject *uploadObject in self.uploads)
         {
         if (![self.categories containsObject:uploadObject.uploadCategory])
         {
         [self.categories addObject:uploadObject.uploadCategory];
         }
         }
         [self.uploadTableView reloadData];
         return;
         */
    }
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)self.projectObject.id]  forKey:@"ProjectId"];
    //    [params setObject:@"object"  forKey:@"Type"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"RFI" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSArray *data = [responseObject objectForKey:@"data"];
            NSMutableArray *status = [[NSMutableArray alloc] init];
            [status addObject:CurrentStatus];
            if (data.count)
            {
                self.rfis = [[NSMutableArray alloc] init];
                self.allRFIs = [[NSMutableArray alloc] init];
                for (NSDictionary *mdata in data)
                {
                    RFIObject *rfi = [[RFIObject alloc] init];
                    if ([mdata objectForKey:@"Id"] != [NSNull null])
                    {
                        rfi.id = [[mdata objectForKey:@"Id"] intValue];
                    }
                    if ([mdata objectForKey:@"Number"] != [NSNull null])
                    {
                        rfi.rfiNumber = [mdata objectForKey:@"Number"];
                    }
                    if ([mdata objectForKey:@"Revision"] != [NSNull null])
                    {
                        rfi.revision = [[mdata objectForKey:@"Revision"] intValue];
                    }
                    if ([mdata objectForKey:@"Subject"] != [NSNull null])
                    {
                        rfi.rfiSubject = [mdata objectForKey:@"Subject"];
                    }
                    if ([mdata objectForKey:@"Date"] != [NSNull null])
                    {
                        rfi.rfiDate = [mdata objectForKey:@"Date"];
                    }
                    if ([mdata objectForKey:@"Status"] != [NSNull null])
                    {
                        rfi.rfiStatus = [mdata objectForKey:@"Status"];
                        if ([status indexOfObject:rfi.rfiStatus] == NSNotFound)
                        {
                            [status addObject:rfi.rfiStatus];
                        }
                            
                    }
                    if ([mdata objectForKey:@"Answer"] != [NSNull null])
                    {
                        rfi.rfiAnswer = [mdata objectForKey:@"Answer"];
                    }
                    else
                    {
                        rfi.rfiAnswer = @"";
                    }
                    if ([mdata objectForKey:@"ClarificationRequested"] != [NSNull null])
                    {
                        rfi.rfiQuestion = [mdata objectForKey:@"ClarificationRequested"];
                    }
                    else
                    {
                        rfi.rfiQuestion = @"";
                    }
                    if ([mdata objectForKey:@"DueDate"] != [NSNull null])
                    {
                        rfi.rfiDueDate = [mdata objectForKey:@"DueDate"];
                    }
                    else
                    {
                        rfi.rfiDueDate = @"";
                    }

                    if ([mdata objectForKey:@"ProjectId"] != [NSNull null])
                    {
                        rfi.projectId = [[mdata objectForKey:@"ProjectId"] intValue];
                    }
                    if ([mdata objectForKey:@"Attachments"] != [NSNull null])
                    {
                        NSMutableArray *rfiAttachments = [[NSMutableArray alloc] init];
                        NSArray *attachments = [mdata objectForKey:@"Attachments"];
                        for (NSDictionary *attachement in attachments)
                        {
                            RFIAttachment *rfiAttachment = [[RFIAttachment alloc] init];
                            if ([attachement objectForKey:@"Id"] != [NSNull null])
                            {
                                rfiAttachment.id = [[attachement objectForKey:@"Id"] integerValue];
                            }
                            if ([attachement objectForKey:@"Mimetype"] != [NSNull null])
                            {
                                rfiAttachment.mimetype = [attachement objectForKey:@"Mimetype"];
                            }
                            if ([attachement objectForKey:@"Filename"] != [NSNull null])
                            {
                                rfiAttachment.filename = [attachement objectForKey:@"Filename"];
                            }
                            if ([attachement objectForKey:@"Url"] != [NSNull null])
                            {
                                rfiAttachment.url = [attachement objectForKey:@"Url"];
                            }
                            if ([attachement objectForKey:@"Thumbnail"] != [NSNull null])
                            {
                                rfiAttachment.thumbnail = [attachement objectForKey:@"Thumbnail"];
                            }
                            if ([attachement objectForKey:@"Date"] != [NSNull null])
                            {
                                rfiAttachment.date = [attachement objectForKey:@"Date"];
                            }
                            if ([attachement objectForKey:@"Description"] != [NSNull null])
                            {
                                rfiAttachment.desc = [attachement objectForKey:@"Description"];
                            }
                            if ([attachement objectForKey:@"Category"] != [NSNull null])
                            {
                                rfiAttachment.category = [attachement objectForKey:@"Category"];
                            }
                            [rfiAttachments addObject:rfiAttachment];
                        }
                        rfi.rfiAttachments = rfiAttachments;
                    }

                    [self.allRFIs addObject:rfi];
                }

                self.rfis = self.allRFIs;
                UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:status];
                segmentedControl.frame = CGRectMake(5, 0, status.count * 75, 30);
                segmentedControl.selectedSegmentIndex = 0;
                [statusView addSubview:segmentedControl];
                self.rfiTableView.tableHeaderView = statusView;
                [segmentedControl addTarget:self
                                     action:@selector(pickOne:)
                           forControlEvents:UIControlEventValueChanged];
                [self.rfiTableView reloadData];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
    
    [operation start];
    
}

- (void) pickOne:(id)sender
{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    CurrentStatus = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    self.rfis = nil;
    if ([CurrentStatus isEqualToString:@"All"])
    {
        self.rfis = self.allRFIs;
    }
    else
    {
        self.rfis = [[NSMutableArray alloc] init];
        for (RFIObject *rfi in self.allRFIs)
        {
            if ([rfi.rfiStatus isEqualToString:CurrentStatus])
            {
                [self.rfis addObject:rfi];
            }
        }
    }
    
    [self.rfiTableView reloadData];

}


#pragma mark - UITableView

- (void) reloadRFIs: (UIRefreshControl *)refreshControl
{
    
    CurrentStatus = @"All";
    [self getRFIs];
    [refreshControl endRefreshing];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.rfis.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"RFI's";
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    RFIObject *rfi = [self.rfis objectAtIndex:indexPath.row];
    NSString *txt1 = @"";
    if (rfi.revision > 0)
    {
        txt1 = [NSString stringWithFormat:@"-%lu", (unsigned long)rfi.revision];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@ %@", rfi.rfiNumber, txt1, rfi.rfiSubject];
    txt1 = @"n/a";
    if (rfi.rfiDate != (id)[NSNull null])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [formatter dateFromString:rfi.rfiDate];
        [formatter setDateFormat:@"MM/dd/yy"];
        txt1 = [formatter stringFromDate:date];
    }

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Date : %@ Status: %@", txt1, rfi.rfiStatus];
    return cell;
    
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    RFIDetailsViewController *rfiDetailsVC = [[RFIDetailsViewController alloc] initWithNibName:@"RFIDetailsViewController" bundle:nil];
    rfiDetailsVC.projectObject = self.projectObject;

    RFIObject *rfi = [self.rfis objectAtIndex:indexPath.row];
    rfiDetailsVC.rfiObject = rfi;
    
    [self.navigationController pushViewController:rfiDetailsVC animated:YES];

}



@end
