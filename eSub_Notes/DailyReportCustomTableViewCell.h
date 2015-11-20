//
//  DailyReportCustomTableViewCell.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 3/17/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyReportCustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *customImageView;
@property (strong, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *customSubtitleLabel;

@end
