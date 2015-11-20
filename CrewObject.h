//
//  CrewObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/26/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrewObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (nonatomic) NSUInteger                crewId;
@property (nonatomic) NSUInteger                projectId;
@property (nonatomic) NSUInteger                dailyReportId;
@property (nonatomic) NSUInteger                crewMemberId;
@property (nonatomic) NSUInteger                employeeId;
@property (nonatomic) NSUInteger                laborClassId;
@property (nonatomic) NSUInteger                lineNumber;
@property (nonatomic) float                     hoursST;
@property (nonatomic) float                     hoursOT;
@property (nonatomic) float                     hoursDT;
@property (nonatomic) float                     hoursLost;
@property (nonatomic) NSUInteger                units;
@property (strong, nonatomic) NSString          *comments;
@property (strong, nonatomic) NSString          *crewName;
@property (nonatomic) NSUInteger                laborActivityId;
@property (nonatomic) NSUInteger                workTypeId;
@property (nonatomic) NSUInteger                phaseId;
@property (nonatomic) NSUInteger                totalUnits;
@property (strong, nonatomic) NSString          *systemPhase;
@property (strong, nonatomic) NSString          *drDate;

@end
