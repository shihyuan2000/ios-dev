//
//  SettingTableCellTableViewCell.m
//  eSUB
//
//  Created by 张兆健 on 15/8/3.
//  Copyright (c) 2015年 LAWRENCE SHANNON. All rights reserved.
//

#import "SettingTableCellTableViewCell.h"

@implementation SettingTableCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.checkBox = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 30.0, 25, 25)];
        [self.checkBox setBackgroundImage:[UIImage imageNamed:@"checkboxborder.png"] forState:UIControlStateNormal];
        [self.checkBox setBackgroundImage:[UIImage imageNamed:@"checkboxmarkedborder.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.checkBox];
        
        self.infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 0, 59, 79)];
        [self.contentView addSubview:self.infoImage];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 30.0, 300, 25.0)];
        self.infoLabel.font = [UIFont systemFontOfSize:17.0];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.infoLabel];
    }
    return self;
}

@end
