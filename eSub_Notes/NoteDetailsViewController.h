//
//  NoteDetailsViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteObject.h"
#import "AddAnnotationViewController.h"
#import "OldAnnotationViewController.h"


@interface NoteDetailsViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate>
{
    UIPopoverController *popoverController;
}

@property (strong, nonatomic) IBOutlet UITextView           *locationTextView;
@property (strong, nonatomic) IBOutlet UITextView           *noteTitleTextView;
@property (strong, nonatomic) IBOutlet UIImageView          *photoImageView;

@property (strong, nonatomic) IBOutlet UIButton             *takeAPictureButton;

@property (retain) NoteObject                               *note;

@property (nonatomic, assign) NSInteger                     projectId;


//@property (strong, nonatomic) AddAnnotationViewController   *annotationVC;
@property (strong, nonatomic) OldAnnotationViewController   *annotationVC;


- (IBAction)takeAPicture:(id)sender;

@end
