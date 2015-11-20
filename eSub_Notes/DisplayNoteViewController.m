//
//  DisplayNoteViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/14/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "DisplayNoteViewController.h"
#import "Common.h"
#import "NoteAttachment.h"
#import "AppDelegate.h"
#import "ImageCache.h"
#import "DisplayNoteImageViewController.h"
#import "DejalActivityView.h"
#import "ProjectDetailsViewController.h"
@interface DisplayNoteViewController ()

@property (retain, nonatomic) UITextView *editedTextView;

@end

@implementation DisplayNoteViewController

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
    label.text = @"Note";
    self.navigationItem.titleView = label;

    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

//    self.view.backgroundColor = [UIColor grayColor];

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
    
    self.noteImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.noteImageView.layer.cornerRadius = 10;
    self.noteImageView.layer.borderWidth = 1.0f;

    self.dateTextview.layer.borderColor = [UIColor blackColor].CGColor;
    self.dateTextview.layer.cornerRadius = 10;
    self.dateTextview.layer.borderWidth = 1.0f;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:self.note.noteDate];
    [formatter setDateFormat:@"MM/dd/yy hh:mm:ss a"];
    self.dateTextview.text = [formatter stringFromDate:date];
    if (self.dateTextview.text.length == 0 && self.note.noteDate.length > 0)
    {
        self.dateTextview.text = self.note.noteDate;
    }
    self.dateTextview.userInteractionEnabled = NO;

    self.locationTextview.layer.borderColor = [UIColor blackColor].CGColor;
    self.locationTextview.layer.cornerRadius = 10;
    self.locationTextview.layer.borderWidth = 1;
//    self.locationTextview.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.locationTextview.text = [Common makeAddress:self.note.noteLocation.address];

    self.noteTextview.layer.borderColor = [UIColor blackColor].CGColor;
    self.noteTextview.layer.cornerRadius = 10;
    self.noteTextview.layer.borderWidth = 1;
//    self.noteTextview.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.noteTextview.text = self.note.notetitle;
    self.noteTextview.userInteractionEnabled = YES;
    [self.noteTextview setScrollEnabled:YES];
    self.noteTextview.showsVerticalScrollIndicator = YES;
    
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

    self.noteImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.noteImageView addGestureRecognizer:tap];

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
    if (self.noteTextview.text.length == 0)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"" message:@"The Note field can not be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    self.note.notetitle = self.noteTextview.text;
    
//    NSInteger noteId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewNoteCount] intValue];
//    noteId--;
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)noteId] forKey:kNewNoteCount];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    self.note.id = noteId;
//    self.note.noteDate = @"This note hasn't been saved";
//    [appD.eSubsDB insertNoteObject:self.note forUserID:appD.userId];
    
    [appD.eSubsDB deleteNoteObject:self.note.projectId andNoteId:self.note.id forUserID:appD.userId];
    [appD.eSubsDB insertNoteObject:self.note forUserID:appD.userId];
    
    NSLog(@"%@",self.note.noteDescription);
    if ([appD.reachability currentReachabilityStatus] != NotReachable)
    {
        NSString *dateStr = [appD.eSubsDB getNoteDate:self.note.projectId andNoteId:self.note.id forUserID:appD.userId];
        if (![dateStr isEqualToString:@"This note hasn't been saved"] &&
            ![dateStr isEqualToString:@"The image for this note has not been saved"]){
             [Common editNoteToWebService:self.note usingUUID:[[NSUUID UUID] UUIDString]];
        }
    }
    if ([self.delegate respondsToSelector:@selector(reloadCellAtIndexPath:)]) {
        [self.delegate reloadCellAtIndexPath:self.selIndexPath];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    ProjectDetailsViewController *setPrizeVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    setPrizeVC.refresh = YES;
    [self.navigationController popToViewController:setPrizeVC animated:true];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

    NoteObject *sqlNote = [appD.eSubsDB getNoteObject:self.note.projectId andNoteId:self.note.id forUserID:appD.userId];
    
    if (sqlNote && sqlNote.noteImages.count)
    {
        
        UIImage *image = [UIImage imageWithData:[appD.eSubsDB getNoteImageData:sqlNote.noteImages[0]]];
//        UIImage *image = [UIImage imageNamed:@"eSub_100.png"];

        NSLog(@"Width : %f - Height : %f", image.size.width, image.size.height);
        /*
         CGSize newSize;
         if (image.size.width > image.size.height)
         {
         newSize = CGSizeMake(280, 170);
         UIGraphicsBeginImageContext(newSize);
         [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
         UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         self.noteImageView.image = newImage;
         }
         else
         {
         self.noteImageView.image = [Common scaleImage:image toSize:CGSizeMake(280, 170)];
         }
         */
        [self sizeImageForDisplay:image];
        image = nil;
    }
    else if (self.note.noteAttachments.count && [appD.reachability currentReachabilityStatus] != NotReachable)
    {
        NoteAttachment *attachment = self.note.noteAttachments[0];
        if (attachment.attachmentUrl.length > 0)
        {
            dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
            dispatch_async(imageQueue, ^{
                NSError *error = nil;
                NSLog(@"Get URL for image : %@", attachment.attachmentUrl);
                NSLog(@"ProjectId : %lu NoteId : %lu", (unsigned long)self.note.projectId, (unsigned long)self.note.id);
                NSString *encodedText = [attachment.attachmentUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if ([NSURL URLWithString:encodedText])
                {
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
                    if (data.length)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSUInteger id = [appD.eSubsDB insertNoteImage:data];
                            [self.note.noteImages addObject:[NSNumber numberWithLong:id]];
                            [appD.eSubsDB deleteNoteObject:self.note.projectId andNoteId:self.note.id forUserID:appD.userId];
                            [appD.eSubsDB insertNoteObject:self.note forUserID:appD.userId];
                            [self sizeImageForDisplay:[UIImage imageWithData:data]];
                            NSLog(@"Added Image projectId : %lu NoteId : %lu id for sql image : %lu", (unsigned long)self.note.projectId, (unsigned long)self.note.id, (unsigned long)id);
                        });
                    }
                    else
                    {
                        NSLog(@"No image data for projectId : %lu NoteId : %lu error : %@", (unsigned long)self.note.projectId, (unsigned long)self.note.id, [error localizedDescription]);
                    }
                }
                else
                {
                    NSLog(@"NSURL returned nil");
                }
            });
        }
        
        //        self.noteImageView.image = [UIImage imageNamed:@"eSub_100.png"];
    }

}

- (void) viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];

    self.noteImageView.image = nil;

}

- (void) sizeImageForDisplay: (UIImage *) image
{

    CGSize newSize;
    if (image.size.width > image.size.height)
    {
        newSize = CGSizeMake(280, 170);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.noteImageView.image = newImage;
    }
    else
    {
        self.noteImageView.image = [Common scaleImage:image toSize:CGSizeMake(280, 170)];
    }

}

- (void) imageTapped: (id) sender
{

    DisplayNoteImageViewController *vc;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        vc = [[DisplayNoteImageViewController alloc] initWithNibName:@"DisplayNoteImageViewController_iPad" bundle:nil];
    }
    else
    {
        vc = [[DisplayNoteImageViewController alloc] initWithNibName:@"DisplayNoteImageViewController" bundle:nil];
    }
    vc.note = self.note;
    [self.navigationController pushViewController:vc animated:YES];

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

@end
