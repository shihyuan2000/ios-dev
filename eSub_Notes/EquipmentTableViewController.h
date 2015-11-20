//
//  EquipmentTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/19/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyReportObject.h"

@interface EquipmentTableViewController : UITableViewController

@property NSInteger                                     projectId;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) NSString                  *drDate;
@property (strong, nonatomic) DailyReportObject         *dr;
@property (strong, nonatomic) NSMutableArray            *projectEquipment;
@property (strong, nonatomic) NSMutableArray            *listOfEquipment;

@end
