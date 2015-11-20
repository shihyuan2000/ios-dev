//
//  RFIObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/9/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFIObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (strong, nonatomic) NSString          *rfiNumber;
@property (nonatomic) NSUInteger                revision;
@property (strong, nonatomic) NSString          *rfiSubject;
@property (strong, nonatomic) NSString          *rfiDate;
@property (strong, nonatomic) NSString          *rfiStatus;
@property (strong, nonatomic) NSString          *rfiQuestion;
@property (strong, nonatomic) NSString          *rfiDueDate;
@property (strong, nonatomic) NSString          *rfiAnswer;
@property (strong, nonatomic) NSMutableArray    *rfiThumbNails;
@property (retain, nonatomic) NSMutableArray    *rfiAttachments;
@property (nonatomic) NSUInteger                projectId;

@end
