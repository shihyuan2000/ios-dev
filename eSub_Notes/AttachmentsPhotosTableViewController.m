//
//  AttachmentsPhotosTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/16/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "AttachmentsPhotosTableViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "TeamCell.h"
#import "AddPhotoViewController.h"

@interface AttachmentsPhotosTableViewController ()
{

}
@end

@implementation AttachmentsPhotosTableViewController

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
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    sButton.frame = CGRectMake(0, 0, 40, 40);
    sButton.tintColor = [UIColor blackColor];
    [sButton addTarget:self action:@selector(addAttachmentsPhotos) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
//    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, editBarButtonItem, nil];
    if (self.dr.isEditable)
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, nil];
    }
    
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
    [refreshControl addTarget:self action:@selector(reloadAttachmentsPhotos:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Attachments / Photos";
    self.navigationItem.titleView = label;

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [self getUploads];
    
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

- (void) reloadAttachmentsPhotos:(UIRefreshControl *)refreshControl
{
    
    [self getUploads];
    [refreshControl endRefreshing];
    
}

- (void) addAttachmentsPhotos
{
   
    AddPhotoViewController *vc = [[AddPhotoViewController alloc] initWithNibName:@"AddPhotoViewController" bundle:nil];
    vc.projectId = self.projectId;
    vc.dailyReportId = self.dailyReportId;
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void) getUploads
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.uploads = [appD.eSubsDB getUploadAttachmentPhotoObjects:appD.userId forProjectId:self.projectId forDailyReport:self.dailyReportId];
        [self.tableView reloadData];
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
 // NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:@"http://api.esub.localhost/v2/"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)self.projectId]  forKey:@"projectId"];
//    [params setObject:[NSNumber numberWithInt:210]  forKey:@"projectId"];
    [params setObject:@"object"  forKey:@"Type"];
    [params setObject:@"DailyReport" forKey:@"documentType"];
    [params setObject:[NSNumber numberWithInt:(int)self.dailyReportId]  forKey:@"DocumentId"];
  //      [params setObject:[NSNumber numberWithInt:1407]  forKey:@"DocumentId"];
    
    NSLog(@"projectId = %ld;documentId=%ld",(long)self.projectId,(long)self.dailyReportId);
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Upload" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                [appD.eSubsDB deleteUnsavedUploadObjects:appD.userId forProjectId:self.projectId forDailyReportId:self.dailyReportId];
                self.uploads = [[NSMutableArray alloc] init];
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
                    uploadObject.dailyReportId = self.dailyReportId;
                    uploadObject.uploadDocumentType = @"DailyReport";
                    uploadObject.uploadDocumentId = 0;
                    [appD.eSubsDB insertUploadObject:uploadObject forUserID:appD.userId];
                }
                self.uploads = [appD.eSubsDB getUploadAttachmentPhotoObjects:appD.userId forProjectId:self.projectId forDailyReport:self.dailyReportId];
                [self.tableView reloadData];
            }

        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            NSInteger code = [response statusCode];
            if (code == 401)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your session has expired, please login again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    
    [operation start];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.uploads.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    UploadObject *uploadObject = [self.uploads objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = uploadObject.uploadFilename;
    cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
    return cell;
*/

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    TeamCell *cell = [[TeamCell alloc] init];
    UploadObject *uploadObject = [self.uploads objectAtIndex:indexPath.row];
    cell.uploadDescription1.text = uploadObject.uploadDescription;
    cell.uploadDescription2.text = uploadObject.uploadFilename;
    
    NSString *txt1 = @"";
    if (uploadObject.uploadDate != (id)[NSNull null])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [formatter dateFromString:uploadObject.uploadDate];
        [formatter setDateFormat:@"MM/dd/yy hh:mm a"];
        txt1 = [formatter stringFromDate:date];
    }
    
    cell.uploadDescription3.text = txt1;
    
    UIImage *thumbnail = [appD.eSubsDB getUploadThumbNail:uploadObject forUserID:appD.userId];
    if (thumbnail)
    {
        cell.uploadImageView.image = thumbnail;
    }
    else
    {
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            NSError *error = nil;
            NSString *encodedText = [uploadObject.uploadThumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([NSURL URLWithString:encodedText])
            {
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
                if (data.length)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        uploadObject.uploadThumbnailId = [appD.eSubsDB insertUploadThumbnail:uploadObject forUserID:appD.userId withData:data];
                        [appD.eSubsDB deleteUploadObject:self.projectId andUploadId:uploadObject.uploadId forUserID:appD.userId];
                        [appD.eSubsDB insertUploadObject:uploadObject forUserID:appD.userId];
                        [self.tableView reloadData];
                    });
                }
                else
                {
                    NSLog(@"No thumbnail data for projectId : %lu NoteId : %lu error : %@", (unsigned long)self.projectId, (unsigned long)uploadObject.uploadId, [error localizedDescription]);
                    NSLog(@"URL for thumbnail: %@", uploadObject.uploadThumbnail);
                }
            }
            else
            {
                NSLog(@"NSURL returned nil");
            }
        });
        
        UIDocumentInteractionController* docController = [[UIDocumentInteractionController alloc] init];
        docController.name = uploadObject.uploadFilename;
        NSArray* icons = docController.icons;
        if (icons.count)
        {
            cell.uploadImageView.image = [icons objectAtIndex:0];
        }
        
    }
    
    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UploadObject *uploadObject = [self.uploads objectAtIndex:indexPath.row];
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath;
    if (uploadObject.localFileStoreName.length == 0)
    {
        filePath = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%ld.png", self.projectObject.projectName, (long)uploadObject.uploadId]];
    }
    else
    {
        filePath = [applicationDocumentsDir stringByAppendingPathComponent:uploadObject.localFileStoreName];
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSString *encodedText = [uploadObject.uploadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [DejalBezelActivityView activityViewForView:self.view];
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            NSError *error;
            NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [DejalBezelActivityView removeViewAnimated:YES];
                
                NSError* error;
                if (![pdfData writeToFile:filePath options:NSDataWritingAtomic error:&error])
                {
                    NSLog(@"Error write failed in photoCompleted :  %@", error);
                }

                self.fileURL = [NSURL fileURLWithPath:filePath];
                
                QLPreviewController *previewController=[[QLPreviewController alloc]init];
                previewController.dataSource = self;
                [self presentViewController:previewController animated:YES completion:nil];
                
            });
        });
    }
    else
    {
        self.fileURL = [NSURL fileURLWithPath:filePath];
        
        QLPreviewController *previewController = [[QLPreviewController alloc]init];
        previewController.dataSource = self;
        [self presentViewController:previewController animated:YES completion:nil];
    }
    
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    
    return 1;
    
}

- (id)previewController:(QLPreviewController*)previewController previewItemAtIndex:(NSInteger)idx
{
    
    return self.fileURL;
    
}


@end
