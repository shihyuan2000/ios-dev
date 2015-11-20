//
//  AddAnnotationViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "AddAnnotationViewController.h"
#import "AnnotationImageView.h"

@interface AddAnnotationViewController ()


@end

@implementation AddAnnotationViewController

bool annotating;

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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
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
/*
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=self.image.size};
    self.imageView.image = self.image;
*/
    self.imageView = [[AnnotationImageView alloc] init:self.myScrollView];

    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=self.image.size};
    self.imageView.image = self.image;

    self.myScrollView.contentSize = self.image.size;
    [self.myScrollView addSubview:self.imageView];
    
    CGRect scrollViewFrame = self.myScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.myScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.myScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.myScrollView.minimumZoomScale = minScale;
    
    self.myScrollView.maximumZoomScale = 1.0f;
//    self.myScrollView.zoomScale = minScale;
    self.myScrollView.zoomScale = 1.0;

    annotating = NO;

    /*
     self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     self.scrollview.delegate = self;
     
     self.scrollview.contentSize = self.image.size;
     
     [self.scrollview addSubview:self.imageView];
     
     [self.view addSubview:self.scrollview];
     [self.view addSubview:pencilButton];
     
     CGRect scrollViewFrame = self.scrollview.frame;
     CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollview.contentSize.width;
     CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollview.contentSize.height;
     CGFloat minScale = MIN(scaleWidth, scaleHeight);
     self.scrollview.minimumZoomScale = minScale;
     
     self.scrollview.maximumZoomScale = 1.0f;
     self.scrollview.zoomScale = minScale;
     */

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

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    // Return the view that we want to zoom
    return self.imageView;
    
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
    NSLog(@"scale=%f , contentSize.width=%.1f , contentSize.height=%.1f",scale , scrollView.contentSize.width , scrollView.contentSize.height);
    NSLog(@"ContentOffset x : %.1f y : %.1f ", scrollView.contentOffset.x, scrollView.contentOffset.y);
    self.myScrollView.zoomScale = 1.0;

}


- (void) displayImage
{

    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            
            [subView removeFromSuperview];
        }
    }
 
    UIImage *pencil = [UIImage imageNamed: @"pencil.png"];
    //    UIImageView *pencilView = [[UIImageView alloc] initWithImage: pencil];
    UIButton *pencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pencilButton setImage:pencil forState:UIControlStateNormal];
    [pencilButton addTarget:self action:@selector(addAnnotation) forControlEvents:UIControlEventTouchUpInside];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        {
            pencilButton.frame = CGRectMake(710, 50, 50, 50);
        }
        else
        {
            pencilButton.frame = CGRectMake(975, 40, 50, 50);
        }
    }
    else
    {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        {
            pencilButton.frame = CGRectMake(285, 50, 35, 35);
        }
        else
        {
            pencilButton.frame = CGRectMake(535, 40, 35, 35);
        }
    }

    [self.view addSubview:pencilButton];
    
//    [self centerScrollViewContents];
    
    
}

- (void) addAnnotation
{

    if (!annotating)
    {
        [self.imageView setUserInteractionEnabled:YES];
        self.myScrollView.scrollEnabled = NO;
        
        annotating = YES;
    }
    else
    {
        [self.imageView setUserInteractionEnabled:NO];
        self.myScrollView.scrollEnabled = YES;
        annotating = NO;
    }
    
}

- (void)centerScrollViewContents
{
//    CGSize boundsSize = self.scrollview.bounds.size;
    CGSize boundsSize = self.myScrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
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
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
