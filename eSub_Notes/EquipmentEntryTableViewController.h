//
//  EquipmentEntryTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/17/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquipmentObject.h"
#import "DailyReportObject.h"

@interface EquipmentEntryTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property NSInteger                                     projectId;
@property NSInteger                                     dailyReportId;
@property (strong, nonatomic) NSMutableArray            *projectEquipment;
@property (strong, nonatomic) EquipmentObject           *equipmentObject;
@property (strong, nonatomic) DailyReportObject         *dr;
@property (strong, nonatomic) UIButton                  *button;
@property BOOL                                          newEntry;
@property (strong, nonatomic) NSMutableArray            *listOfEquipment;

@end
