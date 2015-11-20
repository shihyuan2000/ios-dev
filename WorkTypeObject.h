//
//  WorkTypeObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 11/26/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkTypeObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (strong, nonatomic) NSString          *type;
@property (nonatomic) BOOL                      show;

@end
