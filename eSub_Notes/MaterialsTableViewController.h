//
//  MaterialsTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/21/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialsTableViewController : UITableViewController

@property NSInteger                                     projectId;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) NSMutableArray            *projectMaterials;
@property (strong, nonatomic) NSMutableArray            *listOfMaterials;

@end
