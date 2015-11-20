//
//  UploadsViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/3/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "UploadsViewController.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "Constants.h"
#import "UploadObject.h"
#import "UploadCategory.h"
#import "AppDelegate.h"

@interface UploadsViewController ()

@end

@implementation UploadsViewController

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

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadNotes:) forControlEvents:UIControlEventValueChanged];
    [self.uploadTableView addSubview:refreshControl];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = self.projectObject.projectName;
    self.navigationItem.titleView = label;
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    self.categories = [appD.eSubsDB getUploadCategories:appD.userId];
    
    if ((self.categories.count == 0) && [appD.reachability currentReachabilityStatus] != NotReachable)
    {
        [self getListOfCategories];
    }
    else
    {
        [self getUploads];
    }

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    self.categories = [appD.eSubsDB getUploadCategories:appD.userId];
    [self.uploadTableView reloadData];

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

- (void) getListOfCategories
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.categories = [appD.eSubsDB getUploadCategories:appD.userId];
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Dictionaries/UploadCategories" parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSArray *data = [responseObject objectForKey:@"data"];
            self.categories = [[NSMutableArray alloc] init];
            for (NSDictionary *mdata in data)
            {
                UploadCategory *uploadCategory = [[UploadCategory alloc] init];
                if ([mdata objectForKey:@"Id"] != [NSNull null])
                {
                    uploadCategory.categoryId = [[mdata objectForKey:@"Id"] intValue];
                }
                if ([mdata objectForKey:@"Name"] != [NSNull null])
                {
                    uploadCategory.categoryName = [mdata objectForKey:@"Name"];
                }
                [self.categories addObject:uploadCategory];
            }
            [appD.eSubsDB insertUploadCategories:self.categories forUserID:appD.userId];
            [self.categories sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"categoryName" ascending:YES]]];
            [self getUploads];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [self.uploadTableView reloadData];
        }];
    
    [operation start];

}

- (void) getUploads
{

    self.sections = nil;
    self.sections = [[NSMutableDictionary alloc] init];
    for (UploadCategory *uploadCategory in self.categories)
    {
        [self.sections setValue:[[NSMutableArray alloc] init] forKey:uploadCategory.categoryName];
    }

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.uploads = nil;
        self.uploads = [appD.eSubsDB getUploadObjects:appD.userId forProjectId:self.projectId];
        for (UploadObject *uploadObject in self.uploads)
        {
            [[self.sections objectForKey:uploadObject.uploadCategory] addObject:uploadObject];
        }
        for (NSString *key in [self.sections allKeys])
        {
            if ([[self.sections objectForKey:key] count] == 0)
            {
                [self.sections removeObjectForKey:key];
            }
        }
        [self.uploadTableView reloadData];
        return;
    }

    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)self.projectId]  forKey:@"Id"];
//    [params setObject:@"object"  forKey:@"Type"];
//    [params setObject:@"Upload"  forKey:@"documentType"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Projects/Uploads" parameters:params];
//    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Upload" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
    {
        [DejalBezelActivityView removeViewAnimated:YES];
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSArray *data = [responseObject objectForKey:@"data"];
        if (data.count)
        {
            for (NSDictionary *mdata in data)
            {
               UploadObject *uploadObject = [[UploadObject alloc] init];
               if ([mdata objectForKey:@"Id"] != [NSNull null])
               {
                   uploadObject.uploadId = [[mdata objectForKey:@"Id"] intValue];
               }
               if ([mdata objectForKey:@"Mimetype"] != [NSNull null])
               {
                   uploadObject.uploadMimetype = [mdata objectForKey:@"Mimetype"];
               }
               if ([mdata objectForKey:@"Filename"] != [NSNull null])
               {
                   uploadObject.uploadFilename = [mdata objectForKey:@"Filename"];
               }
               if ([mdata objectForKey:@"Size"] != [NSNull null])
               {
                   uploadObject.uploadSize = [[mdata objectForKey:@"Size"] intValue];
               }
               if ([mdata objectForKey:@"Url"] != [NSNull null])
               {
                   uploadObject.uploadUrl = [mdata objectForKey:@"Url"];
               }
               if ([mdata objectForKey:@"Thumbnail"] != [NSNull null])
               {
                   uploadObject.uploadThumbnail = [mdata objectForKey:@"Thumbnail"];
               }
               if ([mdata objectForKey:@"Date"] != [NSNull null])
               {
                   uploadObject.uploadDate = [mdata objectForKey:@"Date"];
               }
               if ([mdata objectForKey:@"Description"] != [NSNull null])
               {
                   uploadObject.uploadDescription = [mdata objectForKey:@"Description"];
               }
               if ([mdata objectForKey:@"Category"] != [NSNull null])
               {
                   uploadObject.uploadCategory = [mdata objectForKey:@"Category"];
               }
               uploadObject.uploadProjectId = self.projectId;
               uploadObject.uploadDocumentType = @"";
               uploadObject.uploadDocumentId = 0;
               [[self.sections objectForKey:uploadObject.uploadCategory] addObject:uploadObject];
               [appD.eSubsDB deleteUploadObject:self.projectId andUploadId:uploadObject.uploadId forUserID:appD.userId];
               [appD.eSubsDB insertUploadObject:uploadObject forUserID:appD.userId];
            }

            for (NSString *key in [self.sections allKeys])
            {
                if ([[self.sections objectForKey:key] count] == 0)
                {
                    [self.sections removeObjectForKey:key];
                }
            }
            [self.uploadTableView reloadData];
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        [DejalBezelActivityView removeViewAnimated:YES];
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSLog(@"Network error in download upload object: %@", [error localizedDescription]);
    }];
    
    [operation start];
    
}

#pragma mark - UITableView

- (void) reloadNotes:(UIRefreshControl *)refreshControl
{
    
    [self getListOfCategories];
    [self.uploadTableView reloadData];

    [refreshControl endRefreshing];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    int i = 0;
    for (NSString *key in [self.sections allKeys])
    {
        if ([[self.sections objectForKey:key] count] != 0)
        {
            i++;
        }
    }
    
    return i;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Project Uploads";
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSArray *keys = [self.sections allKeys];
    cell.textLabel.text = [keys objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    UploadCategory *cat = [self.categories objectAtIndex:indexPath.row];

    NSArray *keys = [self.sections allKeys];
    NSString *cat = [keys objectAtIndex:indexPath.row];
    NSInteger catId = 0;
    for (UploadCategory *c in self.categories)
    {
        if ([cat isEqualToString:c.categoryName])
        {
            catId = c.categoryId;
        }
    }

    UploadDisplayViewController *displayVC = [[UploadDisplayViewController alloc] initWithNibName:@"UploadDisplayViewController" bundle:nil];

    displayVC.projectObject = self.projectObject;
    displayVC.projectId = self.projectId;
    displayVC.category = cat;
    displayVC.categoryId = catId;

    displayVC.uploads = [self.sections objectForKey:[keys objectAtIndex:indexPath.row]];

    [self.navigationController pushViewController:displayVC animated:YES];

}

@end
