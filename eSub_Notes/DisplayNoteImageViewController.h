//
//  DisplayNoteImageViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/24/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteObject.h"

@interface DisplayNoteImageViewController : UIViewController <UIScrollViewDelegate>

@property (strong) NoteObject                           *note;
@property (strong, nonatomic) IBOutlet UIImageView      *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView     *scrollView;

@end
