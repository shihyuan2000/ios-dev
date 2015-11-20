//
//  OldAnnotationViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/11/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "OldAnnotationViewController.h"

@interface OldAnnotationViewController ()

@end

@implementation OldAnnotationViewController

@synthesize location;

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
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    UIImage *image = [UIImage imageNamed: @"eSub_nav.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    self.navigationItem.titleView = imageView;
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sButton.layer.borderWidth = 1;
//    sButton.layer.borderColor = [UIColor blackColor].CGColor;
    sButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sButton setTitle:@"Save" forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(saveAnnotations) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    NSLog(@"Start Annotaion Width : %f - Height : %f", self.image.size.width, self.image.size.height);
    
    self.imageView.image = self.image;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self displayImage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setDelegate:(id)newDelegate
{
    
    delegate = newDelegate;
    
}

- (void) displayImage
{
    
    for (UIView *subView in self.imageView.subviews)
    {
        if ([subView isKindOfClass:[UIImageView class]])
        {
            
            [subView removeFromSuperview];
        }
    }
    
    UIImage *image = [UIImage imageNamed: @"pencil.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        {
            imageView.frame = CGRectMake(710, 50, 50, 50);
        }
        else
        {
            imageView.frame = CGRectMake(975, 40, 50, 50);
        }
    }
    else
    {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        {
            imageView.frame = CGRectMake(285, 50, 35, 35);
        }
        else
        {
            imageView.frame = CGRectMake(535, 40, 35, 35);
        }
    }
    
    [self.imageView addSubview:imageView];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [self displayImage];
    
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) saveAnnotations
{
    
    NSLog(@"End Annotaion Width : %f - Height : %f", self.image.size.width, self.image.size.height);
    self.image = self.imageView.image;
    [delegate photoCompleted];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.location = [touch locationInView:self.imageView];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.imageView];
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    //    UIGraphicsBeginImageContext(self.imageView.image.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    //    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 5.0);
    CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, location.x, location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    location = currentLocation;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.imageView];
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    //    UIGraphicsBeginImageContext(self.imageView.image.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    //    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 5.0);
    CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, location.x, location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    location = currentLocation;
}


@end
