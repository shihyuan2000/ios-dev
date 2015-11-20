//
//  SettingsViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/17/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (nonatomic) BOOL                                      refresh;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
