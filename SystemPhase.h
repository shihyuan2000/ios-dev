//
//  SystemPhase.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 11/27/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemPhase : NSObject

@property (strong, nonatomic) NSString          *systemName;
@property (nonatomic) NSUInteger                systemId;
@property (strong, nonatomic) NSString          *phaseName;
@property (nonatomic) NSUInteger                phaseId;

@end
