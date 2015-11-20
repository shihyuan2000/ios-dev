//
//  RFIAttachment.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/9/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFIAttachment : NSObject

@property (nonatomic) NSUInteger                id;
@property (strong, nonatomic) NSString          *mimetype;
@property (strong, nonatomic) NSString          *filename;
@property (nonatomic) NSUInteger                size;
@property (strong, nonatomic) NSString          *url;
@property (strong, nonatomic) NSString          *thumbnail;
@property (strong, nonatomic) NSString          *date;
@property (strong, nonatomic) NSString          *desc;
@property (strong, nonatomic) NSString          *category;

@end
