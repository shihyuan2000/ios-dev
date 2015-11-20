//
//  MaterialsObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/21/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialsObject : NSObject

@property (nonatomic) NSUInteger                  id;
@property (nonatomic) NSUInteger                  dailyReportId;
@property (strong, nonatomic) NSString          *name;
@property (strong, nonatomic) NSString          *quantityValue;
@property (strong, nonatomic) NSString          *perValue;
@property (strong, nonatomic) NSString          *notesValue;
@property (nonatomic) NSUInteger                   flag;
@end
