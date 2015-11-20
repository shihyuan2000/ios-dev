//
//  MaterialsEntryTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/19/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialsEntryTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property NSInteger                                     projectId;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) NSMutableArray            *projectMaterials;
@property (strong, nonatomic) NSMutableArray            *perList;

@property (strong, nonatomic) UIButton                  *button;

@property BOOL                                          newEntry;

@property NSInteger                                     id;
@property (strong, nonatomic) NSString                  *name;
@property (strong, nonatomic) NSString                  *quantityValue;
@property (strong, nonatomic) NSString                  *perValue;
@property (strong, nonatomic) NSString                  *notesValue;
@property  NSInteger                                    flag;
@property (strong, nonatomic) UIButton                  *saveBtn;
@end
