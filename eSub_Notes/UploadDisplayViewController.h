//
//  UploadDisplayViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 4/6/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "UploadObject.h"
#import "ProjectObject.h"

@interface UploadDisplayViewController : UIViewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate,  UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSString                  *category;
@property (nonatomic) NSInteger                         categoryId;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) IBOutlet UITableView      *uploadDisplayTableView;
@property (strong, nonatomic) NSURL                     *fileURL;
@property (nonatomic) NSInteger                         projectId;
@property (strong, nonatomic) NSMutableArray            *uploads;

@end
