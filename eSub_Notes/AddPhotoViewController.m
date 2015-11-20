//
//  AddPhotoViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/16/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "Common.h"
#import "AppDelegate.h"
#import "ImageUploadAFHTTPClient.h"
#import "DejalActivityView.h"

@interface AddPhotoViewController ()
{
    
    UIImagePickerController *ip;
    UIImagePickerController *libraryPicker;
    
}
@end

@implementation AddPhotoViewController

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
/*
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sButton.layer.borderWidth = 1;
    sButton.layer.borderColor = [UIColor blackColor].CGColor;
    sButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sButton setTitle:@"Save" forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logout, nil];
*/
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
    label.text = @"Add Photo";
    self.navigationItem.titleView = label;

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

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if (self.annotationVC)
    {

        self.photoImageView.image = self.annotationVC.image;
        
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

//- (void) saveDetails
- (void) photoCompleted
{

    if (self.annotationVC)
    {
        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        
        NSData *imageData = [NSData dataWithData: UIImagePNGRepresentation(self.annotationVC.image)];
        
        UploadObject *uploadObject = [[UploadObject alloc] init];
        uploadObject.uploadProjectId = self.projectId;
        uploadObject.dailyReportId = self.dailyReportId;
        uploadObject.uploadDescription = @"This attachment/photo has not been saved";
        uploadObject.uploadDocumentType = @"DailyReport";
        uploadObject.uploadDocumentId = 0;
        
        NSInteger uploadId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewNoteCount] intValue];
        uploadId--;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)uploadId] forKey:kNewNoteCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
        uploadObject.uploadId = uploadId;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
        [dateFormatter setDateFormat:@"MMddyyyy HH:mm:ss"];
        uploadObject.localFileStoreName = [NSString stringWithFormat:@"%@.png", [dateFormatter stringFromDate:[NSDate date]]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        uploadObject.uploadDate = [dateFormatter stringFromDate:[NSDate date]];

        NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [applicationDocumentsDir stringByAppendingPathComponent:uploadObject.localFileStoreName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:applicationDocumentsDir])
        {
            NSLog(@"applicationDocumentsDir exists");
        }
    
        NSError* error;
        if (![imageData writeToFile:filePath options:NSDataWritingAtomic error:&error])
        {
            NSLog(@"Error write failed in photoCompleted :  %@", error);
        }
        
//        uploadObject.uploadUrl = filePath;
        
        NSData * thumbNailData = [Common createThumbNail:[[UIImage alloc] initWithData:imageData]];
        
        uploadObject.uploadThumbnailId = [appD.eSubsDB insertUploadThumbnail:uploadObject forUserID:appD.userId withData:thumbNailData];
        
        [appD.eSubsDB insertUploadObject:uploadObject forUserID:appD.userId];

        ImageUploadAFHTTPClient *client = [ImageUploadAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
 //        ImageUploadAFHTTPClient *client = [ImageUploadAFHTTPClient sharedClient:[NSURL URLWithString:@"http://api.esub.localhost/v2/"]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        
        [data setObject:[NSNull null] forKey:@"Id"];
        [data setObject:[NSNumber numberWithInteger:self.projectId] forKey:@"ProjectId"];
   //     [data setObject:[NSNumber numberWithInteger:210] forKey:@"ProjectId"];
        [data setObject:@"DailyReport" forKey:@"DocumentType"];
        [data setObject:[NSNumber numberWithInteger:self.dailyReportId] forKey:@"DocumentId"];
  //      [data setObject:[NSNumber numberWithInteger:1407] forKey:@"DocumentId"];
        [data setObject:@"Description" forKey:@"Description"];
        
        [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSLog(@"projectId = %ld;documentId=%ld",(long)self.projectId,(long)self.dailyReportId);
        if (!jsonData)
        {
            NSLog(@"Got an error: %@", error);
        }
        [DejalBezelActivityView activityViewForView:self.view];
        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                                         path:@"Upload"
                                                                   parameters:nil
                                                    constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                        {
//                                            NSString *fn = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
                                            [formData appendPartWithFileData:imageData name:@"binaryData" fileName:uploadObject.localFileStoreName mimeType:@"image/png"];
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
             [DejalBezelActivityView removeViewAnimated:YES];
             [appD.eSubsDB deleteUploadObject:self.projectId andUploadId:uploadObject.uploadId forUserID:appD.userId];
             [self.navigationController popViewControllerAnimated:YES];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [DejalBezelActivityView removeViewAnimated:YES];
             [self.navigationController popViewControllerAnimated:YES];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to local store" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             NSLog(@"error AddPhotoViewController: %@", operation.responseString);
             NSLog(@"%@",error);
         }];
        [operation start];

    }

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
    self.photoImageView.image = selectedImage;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"UIImagePickerController Width : %f - Height : %f", self.photoImageView.image.size.width, self.photoImageView.image.size.height);
//    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
/*
    NSData *imageData = [NSData dataWithData: UIImagePNGRepresentation(selectedImage)];
    
    NSUInteger id = [appD.eSubsDB insertNoteImage:imageData];

    if (self.note.noteImages.count)
    {
        [self.note.noteImages removeAllObjects];
    }
    
    [self.note.noteImages addObject:[NSNumber numberWithLong:id]];
    
    imageData = [Common createThumbNail:[[UIImage alloc] initWithData:imageData]];
    id = [appD.eSubsDB insertNoteThumbNail:imageData];
    
    if (self.note.noteThumbNails.count)
    {
        [self.note.noteThumbNails removeAllObjects];
    }
    [self.note.noteThumbNails addObject:[NSNumber numberWithLong:id]];
*/    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    if (libraryPicker == picker)
    {
        [ip dismissViewControllerAnimated:NO completion:NULL];
    }
    
    /*
     if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
     {
     self.annotationVC = [[AddAnnotationViewController alloc] initWithNibName:@"AddAnnotationViewController_iPad" bundle:nil];
     }
     else
     {
     self.annotationVC = [[AddAnnotationViewController alloc] initWithNibName:@"AddAnnotationViewController" bundle:nil];
     }
     */
    self.annotationVC = [[OldAnnotationViewController alloc] initWithNibName:@"OldAnnotationViewController" bundle:nil];
    self.annotationVC.image = selectedImage;
    [self.annotationVC setDelegate:self];
    [self.navigationController pushViewController:self.annotationVC animated:YES];
    
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

@end
