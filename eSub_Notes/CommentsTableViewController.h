//
//  CommentsTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 3/9/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyReportObject.h"

@interface CommentsTableViewController : UITableViewController

@property NSInteger                                     projectId;
@property (strong, nonatomic) NSMutableArray            *dailyReports;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) DailyReportObject         *dr;

@end
