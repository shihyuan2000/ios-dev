//
//  RFIViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/9/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"
#import "RFIDetailsViewController.h"

@interface RFIViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView      *rfiTableView;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) NSMutableArray            *rfis;
@property (strong, nonatomic) NSMutableArray            *allRFIs;

@end
