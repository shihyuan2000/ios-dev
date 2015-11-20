//
//  OldAnnotationViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/11/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoProtocolDelegate

- (void) photoCompleted;

@end

@interface OldAnnotationViewController : UIViewController
{
    
    id delegate;
    CGPoint location;
}

@property (strong, nonatomic) UIImage                   *image;
@property (strong, nonatomic) IBOutlet UIImageView      *imageView;

@property CGPoint                                       location;

- (void) setDelegate:(id)newDelegate;

@end
