//
//  DisplayNoteViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/14/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteObject.h"

@protocol DisplayNoteViewControllerDelegate <NSObject>
- (void)reloadCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface DisplayNoteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView      *noteImageView;
@property (strong, nonatomic) IBOutlet UITextView       *locationTextview;
@property (strong, nonatomic) IBOutlet UITextView       *noteTextview;
@property (strong, nonatomic) IBOutlet UITextView       *dateTextview;
@property (assign,nonatomic) id<DisplayNoteViewControllerDelegate> delegate;
@property (assign,nonatomic) NSIndexPath *selIndexPath;
@property (weak, nonatomic) NoteObject *note;
@end
