//
//  EmployeeObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 11/26/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmployeeObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (strong, nonatomic) NSString          *firstName;
@property (strong, nonatomic) NSString          *lastName;
@property (nonatomic) NSUInteger                laborClassId;
@property (strong, nonatomic) NSString          *number;

@end
