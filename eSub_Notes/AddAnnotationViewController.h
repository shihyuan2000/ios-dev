//
//  AddAnnotationViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AnnotateImageViewController.h"

@interface AddAnnotationViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIImage               *image;
@property (strong, nonatomic) UIImageView           *imageView;
//@property (nonatomic, strong) UIScrollView          *scrollview;
@property (nonatomic, strong) UIView                *containerView;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

@end
