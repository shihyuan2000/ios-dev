//
//  TimeCardViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 6/25/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSMutableArray                                  *projects;
@property (strong, nonatomic) IBOutlet UILabel                              *clockLabel;
@property (strong, nonatomic) IBOutlet UILabel                              *timerLabel;
@property (strong, nonatomic) IBOutlet UIButton                             *jobNameButton;
@property (strong, nonatomic) IBOutlet UIButton                             *systemButton;
@property (strong, nonatomic) IBOutlet UIButton                             *phaseButton;
@property (strong, nonatomic) IBOutlet UIButton                             *laborActivityButton;
@property (strong, nonatomic) NSTimer                                       *clockTimer;
@property (strong, nonatomic) NSTimer                                       *timer;
@property (strong, nonatomic) UIButton                                      *currentButton;
@property (strong, nonatomic) NSDateFormatter                               *clockFormat;
@property (nonatomic) int                                                   totalTimer;

- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;

@end
