//
//  UploadsViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/3/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "ProjectObject.h"
#import "UploadDisplayViewController.h"

@interface UploadsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *uploadTableView;

@property (nonatomic) NSInteger                     projectId;
@property (strong, nonatomic) ProjectObject         *projectObject;
@property (strong, nonatomic) NSMutableArray        *categories;
@property (strong, nonatomic) NSMutableArray        *uploads;
@property (strong, nonatomic) NSMutableArray        *category;
@property (strong, nonatomic) NSMutableDictionary   *sections;

@end
