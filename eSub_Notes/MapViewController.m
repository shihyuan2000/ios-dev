//
//  MapViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue:255.0/255.0 alpha: 1.0];

//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    UIImage *image = [UIImage imageNamed: @"eSub_nav.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    self.navigationItem.titleView = imageView;
    
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
    

    self.navigationController.navigationBar.topItem.title = @"";
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue:255.0/255.0 alpha: 1.0];

    self.mapView.mapType = MKMapTypeStandard;

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.location
                 completionHandler:^(NSArray* placemarks, NSError* error)
                 {
                     if (placemarks && placemarks.count > 0)
                     {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 8.0;
                         region.span.latitudeDelta /= 8.0;
                         
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:placemark];
                     }
                     else
                     {
//                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Address not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

                         [alert show];

                     }
                 }
     ];
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
