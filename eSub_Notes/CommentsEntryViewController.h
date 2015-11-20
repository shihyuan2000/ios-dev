//
//  CommentsEntryViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 3/10/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyReportObject.h"

@interface CommentsEntryViewController : UIViewController

@property NSInteger                                     projectId;
@property (strong, nonatomic) DailyReportObject         *dr;
@property NSInteger                                     section;
@property (strong, nonatomic) NSString                  *comment;
@property BOOL                                          internal;
@property BOOL                                          showInternal;
@property (strong, nonatomic) NSString                  *headerTitle;

@property (strong, nonatomic) IBOutlet UITextView       *commentTextView;
@property (strong, nonatomic) IBOutlet UIButton         *internalButton;
@property (strong, nonatomic) IBOutlet UILabel          *internalLabel;

@end
