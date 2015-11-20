//
//  CrewSections.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 3/18/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrewSections : NSObject

@property (strong, nonatomic) NSString          *systemPhase;
@property (nonatomic) NSUInteger                laborActivityId;
@property (nonatomic) NSUInteger                workTypeId;
@property (strong, nonatomic) NSMutableArray    *crewObjects;

@end
