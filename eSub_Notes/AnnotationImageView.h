//
//  AnnotationImageView.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 3/30/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationImageView : UIImageView

{
    CGPoint location;
}

@property (strong, nonatomic) UIImageView           *imageView;
@property (strong, nonatomic) UIScrollView          *myScrollView;
@property CGPoint location;

- (id)init:(UIScrollView *) myScrollView;

@end
