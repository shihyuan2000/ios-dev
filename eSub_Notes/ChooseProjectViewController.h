//
//  ChooseProjectViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectMainViewController.h"

@interface ChooseProjectViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView              *chooseTableView;
@property (strong, nonatomic) ProjectDetailsViewController      *ProjectDetailsVC;
@property (strong, nonatomic) NSMutableArray                    *projects;
@property (nonatomic) BOOL                                      refresh;

@end
