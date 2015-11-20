//
//  Exception.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 3/13/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exception : NSObject

@property (assign) NSNumber                         *number;
@property (nonatomic, assign) NSString              *message;
@property (nonatomic, assign) NSString              *desc;
@property (nonatomic, assign) NSString              *innerException;
@property (nonatomic, assign) NSString              *source;

@end
