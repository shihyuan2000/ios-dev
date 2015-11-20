//
//  NoteDetailsViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "NoteDetailsViewController.h"
#import "UIView+Dimensions.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAttachment.h"
#import "Constants.h"
#import "Common.h"
#import "ImageCache.h"

@interface NoteDetailsViewController ()
{
    
    NSInteger imageIndex;
    UIImagePickerController *ip;
    UIImagePickerController *libraryPicker;
    
}

#define kTextViewTagOffset 300

@property (retain, nonatomic) UITextView *editedTextView;

@end

@implementation NoteDetailsViewController

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

/*
    UIImage *image = [UIImage imageNamed: @"eSub_nav.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    self.navigationItem.titleView = imageView;
*/

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"New Note";
    self.navigationItem.titleView = label;
    
    self.navigationController.navigationBar.topItem.title = @"";

    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sButton.layer.borderWidth = 1;
//    sButton.layer.borderColor = [UIColor blackColor].CGColor;
    sButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sButton setTitle:@"Save" forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logout, nil];
    
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
    
//    self.view.backgroundColor = [UIColor grayColor];

    self.photoImageView.layer.cornerRadius = 10;
    self.photoImageView.layer.borderWidth = 1;
    self.photoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.takeAPictureButton.tintColor = [UIColor blackColor];

    self.locationTextView.layer.cornerRadius = 10;
    self.locationTextView.layer.borderWidth = 1;
    self.locationTextView.layer.borderColor = [rgb(203, 203, 203) CGColor];
    self.locationTextView.tag = 2;

    self.noteTitleTextView.layer.cornerRadius = 10;
    self.noteTitleTextView.layer.borderWidth = 1;
    self.noteTitleTextView.layer.borderColor = [rgb(203, 203, 203) CGColor];
    self.noteTitleTextView.tag = 1;
    
    self.note = [[NoteObject alloc] init];

    [self useCurrentLocation];

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if (self.annotationVC)
    {
//        UIImage *scaledImage = [self scaleImage:self.annotationVC.image toSize:CGSizeMake(280, 170)];
//        self.photoImageView.image = scaledImage;
        self.photoImageView.image = self.annotationVC.image;

        AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
        
        NSData *imageData = [NSData dataWithData: UIImagePNGRepresentation(self.annotationVC.image)];
        
        NSUInteger id = [appD.eSubsDB insertNoteImage:imageData];
        
        if (self.note.noteImages.count)
        {
            [self.note.noteImages removeObjectAtIndex:0];
        }
        [self.note.noteImages addObject:[NSNumber numberWithLong:id]];
    
        imageData = [Common createThumbNail:[[UIImage alloc] initWithData:imageData]];
        id = [appD.eSubsDB insertNoteThumbNail:imageData];
        
        if (self.note.noteThumbNails.count)
        {
            [self.note.noteThumbNails removeAllObjects];
        }
        [self.note.noteThumbNails addObject:[NSNumber numberWithLong:id]];


    }

}

- (void) loadNewImage
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    NSNumber *id = (NSNumber *) [self.note.noteImages objectAtIndex:imageIndex];
    self.photoImageView.image = [appD.eSubsDB getNoteImage:id];
     
}

UIColor *rgb(CGFloat r, CGFloat g, CGFloat b)
{
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

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

- (void) saveDetails
{

/*
    if (self.locationTextView.text.length == 0 || self.noteTitleTextView.text.length == 0)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"" message:@"Notes and location can not be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }
*/
    if (self.noteTitleTextView.text.length == 0)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"" message:@"The Note field can not be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    self.note.notetitle = self.noteTitleTextView.text;
    self.note.noteDescription = @"";
    self.note.projectId = self.projectId;

    NSInteger noteId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewNoteCount] intValue];
    noteId--;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)noteId] forKey:kNewNoteCount];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.note.id = noteId;
    self.note.noteDate = @"This note hasn't been saved";
    [appD.eSubsDB insertNoteObject:self.note forUserID:appD.userId];

    if ([appD.reachability currentReachabilityStatus] != NotReachable)
    {
        [Common saveNoteToWebService:self.note usingUUID:[[NSUUID UUID] UUIDString]];
    }

    [self.navigationController popViewControllerAnimated:YES];


}

#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self action:@selector(resignTextView:)];
        [doneButton setTintColor:[UIColor colorWithRed:253/255.0 green:184/255.0 blue:19/255.0 alpha:1.0]];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        NSArray *itemArray = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
        [toolbar setItems:itemArray];
        [textView setInputAccessoryView:toolbar];
        self.editedTextView = textView;
    }
    return YES;

}

- (void) resignTextView: (id) sender
{

    [self.editedTextView resignFirstResponder];
    
}

- (void) useCurrentLocation
{

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:appD.latitude longitude:appD.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
             NSMutableString *str2 = [[NSMutableString alloc] initWithString:@""];
             
             if (placemark.subThoroughfare)
             {
                 [str appendFormat:@"%@ ", placemark.subThoroughfare];
                 [str2 appendFormat:@"%@ ", placemark.subThoroughfare];
             }
             if (placemark.thoroughfare)
             {
                 [str appendFormat:@"%@ ", placemark.thoroughfare];
                 [str2 appendFormat:@"%@ ", placemark.thoroughfare];
             }
             if (placemark.locality)
             {
                 [str appendFormat:@"%@ ", placemark.locality];
                 self.note.noteLocation.address.city = placemark.locality;
             }
             if (placemark.administrativeArea)
             {
                 [str appendFormat:@"%@ ", placemark.administrativeArea];
                 self.note.noteLocation.address.state = placemark.administrativeArea;
             }
             if (placemark.postalCode)
             {
                 [str appendFormat:@"%@ ", placemark.postalCode];
                 self.note.noteLocation.address.zip = placemark.postalCode;
             }
             if (placemark.country)
             {
                 [str appendFormat:@"%@", placemark.country];
                 self.note.noteLocation.address.country = placemark.country;
             }
             
             self.locationTextView.text = str;
             self.note.noteLocation.address.address1 = [str2 stringByReplacingOccurrencesOfString:@"\u2013" withString:@"-"];

             self.note.noteLocation.location.latitude = currentLocation.coordinate.latitude;
             self.note.noteLocation.location.longitude = currentLocation.coordinate.longitude;
             
             NSLog(@"Current address : %@", str);
         }
         else
         {
             NSLog(@"%@", error.debugDescription);
         }
     } ];

}

- (IBAction)takeAPicture:(id)sender
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
    self.photoImageView.image = selectedImage;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"UIImagePickerController Width : %f - Height : %f", self.photoImageView.image.size.width, self.photoImageView.image.size.height);
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
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
