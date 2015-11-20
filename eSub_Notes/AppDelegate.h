//
//  AppDelegate.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/22/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "eSubsDB.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "Constants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController           *viewController;
@property (strong, nonatomic) UINavigationController        *navigationController;
@property (strong, nonatomic) NSString                      *tokenAccess;
@property (strong, nonatomic) NSString                      *tokenExpires;
@property (strong, nonatomic) NSString                      *tokenType;
@property (strong, nonatomic) eSubsDB                       *eSubsDB;
@property (nonatomic, strong) CLLocationManager             *locationManager;
@property (assign) double                                   latitude;
@property (assign) double                                   longitude;
@property (strong, nonatomic) NSString                      *projectFilter;
@property (nonatomic) NSUInteger                            userId;
@property (strong, nonatomic) Reachability                  *reachability;
@property (nonatomic) NSUInteger                            newNoteCount;
@property (strong, nonatomic) NSString                      *eSUBServerURL;

@end
