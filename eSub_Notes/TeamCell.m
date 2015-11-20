//
//  ProfilesGroupCell.m
//  Jurhood
//
//  Created by Mountain on 5/1/13.
//  Copyright (c) 2013 ChinaSoft. All rights reserved.
//

#import "TeamCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation TeamCell

@synthesize content_;

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (NSString *)nibName {
    return @"TeamCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.selectedBackgroundView = [[UIView alloc] init];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (id)init {
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *identifier = NSStringFromClass([self class]);
    
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
        NSString *nibName = [[self class] nibName];
        if (nibName) {
            
            [[NSBundle mainBundle] loadNibNamed:nibName
                                          owner:self
                                        options:nil];
            NSAssert(self.content_ != nil, @"NIB file loaded but content property not set.");
            [self.contentView addSubview:self.content_];
            
            self.contentView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
            self.content_.backgroundColor = [UIColor clearColor];
            
            self.selectedBackgroundView = [[UIView alloc] init];
        }
    }
    return self;
}

+ (CGFloat) height {
    return 92;
}



@end
