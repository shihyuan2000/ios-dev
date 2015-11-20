//
//  UploadDisplayViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/6/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "UploadDisplayViewController.h"
#import "UploadObject.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Common.h"
#import "ImageUploadAFHTTPClient.h"
#import "NoteAFHTTPClient.h"
#import "TeamCell.h"

@interface UploadDisplayViewController ()
{

    UIImagePickerController *ip;
    UIImagePickerController *libraryPicker;

}

@end

@implementation UploadDisplayViewController

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
    
    UIImage *buttonImage = [UIImage imageNamed:@"camera.png"];
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sButton setImage:buttonImage forState:UIControlStateNormal];
    sButton.frame = CGRectMake(0, 0, 40, 40);
    [sButton addTarget:self action:@selector(takeAPicture) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    
// LTS 7/18/2014 - Remove for release to APP store.
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, nil];

    
// LTS 10-14-2014 Moved download of uploads to UploadViewController
//    UIRefreshControl *refreshControl = [UIRefreshControl new];
//    [refreshControl addTarget:self action:@selector(reloadUploads:) forControlEvents:UIControlEventValueChanged];
//    [self.uploadDisplayTableView addSubview:refreshControl];

//    [self getUploads];

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
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

- (void) reloadUploads:(UIRefreshControl *)refreshControl
{
    
    [self getUploads];
    
    [refreshControl endRefreshing];
    
}


- (void) getUploads
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        self.uploads = nil;
        NSMutableArray *m  = [appD.eSubsDB getUploadObjects:appD.userId forProjectId:self.projectId];
        self.uploads = [[NSMutableArray alloc] init];
        for (UploadObject *data in m)
        {
            if ([data.uploadCategory isEqualToString:self.category])
            {
                [self.uploads addObject:data];
            }
        }
        [self.uploadDisplayTableView reloadData];
        return;
    }

    
    [DejalBezelActivityView activityViewForView:self.view];

    NoteAFHTTPClient *client = [NoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:(int)self.projectId]  forKey:@"Id"];
    //    [params setObject:@"object"  forKey:@"Type"];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"Projects/Uploads" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count)
            {
                NSMutableArray *m = [[NSMutableArray alloc] init];
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
                    [m addObject:uploadObject];
                    [appD.eSubsDB deleteUploadObject:self.projectId andUploadId:uploadObject.uploadId forUserID:appD.userId];
                    [appD.eSubsDB insertUploadObject:uploadObject forUserID:appD.userId];
                }

                self.uploads = nil;
                self.uploads = [[NSMutableArray alloc] init];
                for (UploadObject *data in m)
                {
                    if ([data.uploadCategory isEqualToString:self.category])
                    {
                        [self.uploads addObject:data];
                    }
                }
                [self.uploadDisplayTableView reloadData];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [self.uploadDisplayTableView reloadData];
        }];
    
    [operation start];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.uploads.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return self.category;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

/*
    NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                  [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                  stringByAppendingPathComponent:@"Documents"]];

    UploadObject *uploadObject = [self.uploads objectAtIndex:indexPath.row];
    NSString *filePath = [resourceDocPath stringByAppendingPathComponent: [NSString stringWithFormat:@"/%@-%@", self.projectObject.projectName, uploadObject.uploadFilename]];
 */

    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    UploadObject *uploadObject = [self.uploads objectAtIndex:indexPath.row];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", self.projectObject.projectName, uploadObject.uploadFilename]];

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
    
                NSError *error;
                if (![pdfData writeToFile:filePath options:NSDataWritingAtomic error:&error])
                {
                    NSLog(@"WriteToFile failed %@", error);
                }
                self.fileURL = [NSURL fileURLWithPath:filePath];
        
                QLPreviewController *previewController=[[QLPreviewController alloc]init];
                previewController.dataSource = self;
                [self presentViewController:previewController animated:YES completion:nil];

//                [[self navigationController] pushViewController:previewController animated:YES];
//                [previewController.navigationItem setRightBarButtonItem:nil];
            });
        });
    }
    else
    {
        self.fileURL = [NSURL fileURLWithPath:filePath];
    
        QLPreviewController *previewController=[[QLPreviewController alloc]init];
        previewController.dataSource = self;
        [self presentViewController:previewController animated:YES completion:nil];
//        [previewController.navigationItem setRightBarButtonItem:nil];
//        [[self navigationController] pushViewController:previewController animated:YES];

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

- (void) takeAPicture
{
    
    if (ip)
    {
        ip = nil;
    }
    ip = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    ip.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        ip.sourceType = UIImagePickerControllerSourceTypeCamera;
        ip.showsCameraControls = YES;
        ip.navigationBarHidden = YES;
        ip.toolbarHidden = YES;
        ip.allowsEditing = NO;
        
        
        // Button for camera roll
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        /*
         UIButton *button = [[UIButton alloc] init];
         if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
         {
         if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
         {
         button.frame = CGRectMake(0, 940, 100, 30);
         }
         else
         {
         button.frame = CGRectMake(0, 680, 100, 30);
         }
         }
         else
         {
         if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
         {
         button.frame = CGRectMake(0, 450, 100, 30);
         }
         else
         {
         button.frame = CGRectMake(0, 0, 250, 30);
         }
         }
         */
        [button setTitle:@"Library" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor darkGrayColor]];
        [button addTarget:self action:@selector(gotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
        
        [ip.view addSubview:button];
        
    }
    else
    {
        ip.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
#endif
    ip.delegate = (id) self;
    
    
    [self presentViewController:ip animated:YES completion:NULL];
    
}

-(void) gotoLibrary:(id)sender
{
    
    libraryPicker = [[UIImagePickerController alloc] init];
    [libraryPicker.view setFrame:CGRectMake(0, 80, 320, 350)];
    [libraryPicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [libraryPicker setDelegate:(id)self];
    
    [ip presentViewController:libraryPicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"Before scaling Width : %f - Height : %f", image.size.width, image.size.height);
    UIImage* selectedImage = [Common scaleAndRotateImage:[info objectForKey:UIImagePickerControllerOriginalImage]];

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    NSData *imageData = [NSData dataWithData: UIImagePNGRepresentation(selectedImage)];

    UploadObject *uploadObject = [[UploadObject alloc] init];
    uploadObject.uploadProjectId = self.projectId;
    uploadObject.uploadDescription = @"This is a new upload image";
    uploadObject.uploadDocumentType = @"";
    uploadObject.uploadDocumentId = 0;

    uploadObject.uploadCategory = self.category;

    NSInteger uploadId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewNoteCount] intValue];
    uploadId--;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)uploadId] forKey:kNewNoteCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    uploadObject.uploadId = uploadId;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    uploadObject.uploadFilename = [NSString stringWithFormat:@"%@.png", [dateFormatter stringFromDate:[NSDate date]]];
    
//    dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
//    uploadObject.uploadDate = [dateFormatter stringFromDate:[NSDate date]];
    uploadObject.uploadDate = @"This upload hasn't been saved";

    NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                  [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                  stringByAppendingPathComponent:@"Documents"]];

    NSString *filePath = [resourceDocPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@-%@", self.projectObject.projectName, uploadObject.uploadFilename]];
    [imageData writeToFile:filePath atomically:YES];

    uploadObject.uploadUrl = filePath;
    
    NSData * thumbNailData = [Common createThumbNail:[[UIImage alloc] initWithData:imageData]];

    uploadObject.uploadThumbnailId = [appD.eSubsDB insertUploadThumbnail:uploadObject forUserID:appD.userId withData:thumbNailData];
    
    [appD.eSubsDB insertUploadObject:uploadObject forUserID:appD.userId];
    
//    [self.uploadDisplayTableView reloadData];


    ImageUploadAFHTTPClient *client = [ImageUploadAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSNull null] forKey:@"Id"];
    [data setObject:[NSNumber numberWithInteger:self.projectId] forKey:@"ProjectId"];
    [data setObject:@"Upload" forKey:@"DocumentType"];
    [data setObject:[NSNumber numberWithInteger:self.categoryId] forKey:@"CategoryId"];
    [data setObject:[NSNumber numberWithInteger:self.categoryId] forKey:@"DocumentId"];
    [data setObject:@"Description" forKey:@"Description"];
    
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                                     path:@"Upload"
                                                               parameters:nil
                                                constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                    {
                                        [formData appendPartWithFileData:imageData name:@"binaryData" fileName:@"file.png" mimeType:@"image/png"];
                                        [formData appendPartWithFormData:jsonData name:@"data"];
                                    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [client enqueueHTTPRequestOperation:operation];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self getUploads];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error: %@", operation.responseString);
         NSLog(@"%@",error);
     }];
    [operation start];

/*
    NSUInteger id = [appD.eSubsDB insertNoteImage:imageData];
 
    [self.note.noteImages addObject:[NSNumber numberWithLong:id]];
*/
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    if (libraryPicker == picker)
    {
        [ip dismissViewControllerAnimated:NO completion:NULL];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    if (libraryPicker == picker)
    {
        [libraryPicker dismissViewControllerAnimated:NO completion:nil];
        [ip dismissViewControllerAnimated:NO completion:nil];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
}

@end
