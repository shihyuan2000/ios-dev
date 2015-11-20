//
//  AttachmentsPhotosTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/16/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"
#import <QuickLook/QuickLook.h>
#import "DailyReportObject.h"

@interface AttachmentsPhotosTableViewController : UITableViewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic) NSInteger                         projectId;
@property (strong, nonatomic) NSMutableArray            *uploads;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) NSURL                     *fileURL;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) DailyReportObject         *dr;

@end
