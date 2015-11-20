//
//  ProjectDetailsViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "ProjectDetailsViewController.h"
#import "NoteLocation.h"
#import "AppDelegate.h"
#import "NoteObject.h"
#import "NoteAttachment.h"
#import "NoteAFHTTPClient.h"
#import "ProjectObject.h"
#import "DejalActivityView.h"
#import "Common.h"
#import "ImageCache.h"
#import "Constants.h"

@interface ProjectDetailsViewController () <DisplayNoteViewControllerDelegate>

@end

@implementation ProjectDetailsViewController
{
//    NSMutableArray *notes;
//    NoteObject *note;
}


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
    
    self.refresh = YES;

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
    [sButton addTarget:self action:@selector(addNote) forControlEvents:UIControlEventTouchUpInside];
    self.noteButton = sButton;
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, nil];

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

    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    label.text = @"Project address:";
    [headerView addSubview:label];

    label = [[UILabel alloc] initWithFrame:CGRectMake(122, 70, 250, 100)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

    label.text = [NSString stringWithFormat:@"%@", [Common makeAddress:self.projectObject.projectLocation.address]];
    [label setNumberOfLines:0];
    [label sizeToFit];
    [headerView addSubview:label];
    
    UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollButton setImage:[UIImage imageNamed:@"map_icon.png"] forState:UIControlStateNormal];
    scrollButton.frame = CGRectMake(270, 70, 40, 40);
    [scrollButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:scrollButton];

//    self.projectDetailsTableView.tableHeaderView = headerView;

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadNotes:) forControlEvents:UIControlEventValueChanged];
    [self.projectDetailsTableView addSubview:refreshControl];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = self.projectObject.projectName;
    self.navigationItem.titleView = label;

}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
//    self.navigationItem.title = @"eSub Notes";

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = self.projectObject.projectName;
    self.navigationItem.titleView = label;

    if (self.refresh)
    {
        [self loadNotes];
        self.refresh = NO;
    }

}

- (void) loadNotes
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.notes = nil;
        self.notes = [appD.eSubsDB getNoteObjects:self.projectId forUserId:appD.userId];
        [self.projectDetailsTableView reloadData];
        return;
    }

    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)self.projectId]  forKey:@"ProjectId"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Notes" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSMutableArray *noteObjects = [[NSMutableArray alloc] init];
            NSArray *data = [responseObject objectForKey:@"data"];
            for (NSDictionary *note in data)
            {
                NSLog(@" data : %@", note);
                NoteObject *noteObject = [[NoteObject alloc] init];
                noteObject.noteDescription = @"";
                if ([note objectForKey:@"Id"] != [NSNull null])
                {
                    noteObject.id = (NSUInteger )[[note objectForKey:@"Id"] intValue];
                }
                if ([note objectForKey:@"ProjectId"] != [NSNull null])
                {
                    noteObject.projectId = (NSUInteger )[[note objectForKey:@"ProjectId"] intValue];
                }
                if ([note objectForKey:@"Date"] != [NSNull null])
                {
                    noteObject.noteDate = [note objectForKey:@"Date"];
                }
                if ([note objectForKey:@"Text"] != [NSNull null])
                {
                    noteObject.notetitle = [note objectForKey:@"Text"];
                }
                if ([note objectForKey:@"Attachments"] != [NSNull null])
                {
                    NSMutableArray *noteAttachments = [[NSMutableArray alloc] init];
                    NSArray *attachments = [note objectForKey:@"Attachments"];
                    for (NSDictionary *attachement in attachments)
                    {
                        NoteAttachment *noteAttachment = [[NoteAttachment alloc] init];
                        if ([attachement objectForKey:@"Id"] != [NSNull null])
                        {
                            noteAttachment.attachmentId = [[attachement objectForKey:@"Id"] integerValue];
                        }
                        if ([attachement objectForKey:@"Mimetype"] != [NSNull null])
                        {
                            noteAttachment.attachmentMimetype = [attachement objectForKey:@"Mimetype"];
                        }
                        if ([attachement objectForKey:@"Filename"] != [NSNull null])
                        {
                            noteAttachment.attachmentFilename = [attachement objectForKey:@"Filename"];
                        }
                        if ([attachement objectForKey:@"Url"] != [NSNull null])
                        {
                            noteAttachment.attachmentUrl = [attachement objectForKey:@"Url"];
                        }
                        if ([attachement objectForKey:@"Thumbnail"] != [NSNull null])
                        {
                            noteAttachment.attachmentThumbnail = [attachement objectForKey:@"Thumbnail"];
                        }
                        if ([attachement objectForKey:@"Date"] != [NSNull null])
                        {
                            noteAttachment.attachmentDate = [attachement objectForKey:@"Date"];
                        }
                        if ([attachement objectForKey:@"Size"] != [NSNull null])
                        {
                            noteAttachment.attachmentSize = [[attachement objectForKey:@"Size"] integerValue];
                        }
                        [noteAttachments addObject:noteAttachment];
                    }
                    noteObject.noteAttachments = noteAttachments;
                }
                if ([note objectForKey:@"Location"] != [NSNull null])
                {
                    NoteLocation *noteLocation = [[NoteLocation alloc] init];
                    NSDictionary *location = [note objectForKey:@"Location"];
                    NSDictionary *address = [location objectForKey:@"Address"];
                    if ([address count])
                    {
                        if ([address objectForKey:@"Address1"] != [NSNull null])
                        {
                            noteLocation.address.address1 = [address objectForKey:@"Address1"];
                        }
                        if ([address objectForKey:@"Address2"] != [NSNull null])
                        {
                            noteLocation.address.address2 = [address objectForKey:@"Address2"];
                        }
                        if ([address objectForKey:@"City"] != [NSNull null])
                        {
                            noteLocation.address.city = [address objectForKey:@"City"];
                        }
                        if ([address objectForKey:@"State"] != [NSNull null])
                        {
                            noteLocation.address.state = [address objectForKey:@"State"];
                        }
                        if ([address objectForKey:@"Zip"] != [NSNull null])
                        {
                            noteLocation.address.zip = [address objectForKey:@"Zip"];
                        }
                        if ([address objectForKey:@"Country"] != [NSNull null])
                        {
                            noteLocation.address.country = [address objectForKey:@"Country"];
                        }
                    }
                    if ([location objectForKey:@"Geolocation"] != [NSNull null])
                    {
                        NSDictionary *geolocation = [location objectForKey:@"Geolocation"];
                        if ([geolocation objectForKey:@"Longitude"] != [NSNull null])
                        {
                            noteLocation.location.longitude = [[address objectForKey:@"Longitude"] doubleValue];
                        }
                        if ([geolocation objectForKey:@"Latitude"] != [NSNull null])
                        {
                            noteLocation.location.latitude = [[address objectForKey:@"Latitude"] doubleValue];
                        }
                    }
                    noteObject.noteLocation = noteLocation;
                }
                [noteObjects addObject:noteObject];
                NSString *dateStr = [appD.eSubsDB getNoteDate:noteObject.projectId andNoteId:noteObject.id forUserID:appD.userId];
                if (![dateStr isEqualToString:@"This note hasn't been saved"] &&
                    ![dateStr isEqualToString:@"The image for this note has not been saved"])
                {
                    [appD.eSubsDB deleteNoteObject:noteObject.projectId andNoteId:noteObject.id forUserID:appD.userId];
                    [appD.eSubsDB insertNoteObject:noteObject forUserID:appD.userId];
                }

            }
//            self.notes = noteObjects;
            self.notes = nil;
            self.notes = [appD.eSubsDB getNoteObjects:self.projectId forUserId:appD.userId];

            [self.projectDetailsTableView reloadData];
                                             
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger code = [httpResponse statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if (code != 404)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    
    [operation start];

}

- (void) reloadNotes:(UIRefreshControl *)refreshControl
{

    [self loadNotes];
    [refreshControl endRefreshing];
    
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

- (void) addNote
{

    self.refresh = YES;
    NoteDetailsViewController *noteDetailVC = [[NoteDetailsViewController alloc] initWithNibName:@"NoteDetailsViewController" bundle:nil];
    noteDetailVC.projectId = self.projectId;
    [self.navigationController pushViewController:noteDetailVC animated:YES];

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
    
    return self.notes.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Notes";
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NoteObject *note;

    UITableViewCell *cell = [[UITableViewCell alloc] init];

    note = [self.notes objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = note.notetitle;

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    if (note.noteThumbNails.count)
    {
        cell.imageView.image = [UIImage imageWithData:[appD.eSubsDB getNoteThumbNailData:note.noteThumbNails[0]]];
        NSLog(@"image from SQLite for sql image id : %@", note.noteThumbNails[0]);
    }
    else if (note.noteAttachments.count)
    {
        NoteAttachment *attachment = note.noteAttachments[0];
        if (attachment.attachmentThumbnail.length > 0)
        {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{

                NSError *error = nil;
                NSLog(@"ProjectId : %lu NoteId : %lu", (unsigned long)note.projectId, (unsigned long)note.id);

                NSString *encodedText = [attachment.attachmentThumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if ([NSURL URLWithString:encodedText])
                {
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
                    if (data.length)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSUInteger id = [appD.eSubsDB insertNoteThumbNail:data];
                            [note.noteThumbNails addObject:[NSNumber numberWithLong:id]];
                            [appD.eSubsDB deleteNoteObject:note.projectId andNoteId:note.id forUserID:appD.userId];
                            [appD.eSubsDB insertNoteObject:note forUserID:appD.userId];
                            NSLog(@"Added Thumbnail projectId : %lu NoteId : %lu id for sql image : %lu", (unsigned long)note.projectId, (unsigned long)note.id, (unsigned long)id);
                            cell.imageView.image = [UIImage imageWithData:data];
                        });
                    }
                    else
                    {
                        NSLog(@"No thumbnail data for projectId : %lu NoteId : %lu error : %@", (unsigned long)note.projectId, (unsigned long)note.id, [error localizedDescription]);
                        NSLog(@"URL for thumbnail: %@", attachment.attachmentThumbnail);
                    }
                }
                else
                {
                    NSLog(@"NSURL returned nil");
                }
            });
            
        }
//        cell.imageView.image = [UIImage imageNamed:@"eSub_100.png"];
    }
//    else
//    {
//        cell.imageView.image = [UIImage imageNamed:@"eSub_100.png"];
//    }

    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.refresh = NO;
    DisplayNoteViewController *displayNoteVC = [[DisplayNoteViewController alloc] initWithNibName:@"DisplayNoteViewController" bundle:nil];
    displayNoteVC.note = [self.notes objectAtIndex:indexPath.row];
    displayNoteVC.delegate = self;
    displayNoteVC.selIndexPath = indexPath;
    [self.navigationController pushViewController:displayNoteVC animated:YES];

}

@end
