//
//  ActivityObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 11/26/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (strong, nonatomic) NSString          *code;
@property (strong, nonatomic) NSString          *name;

@end
