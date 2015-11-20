//
//  DailyReportObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 11/26/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyReportObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (nonatomic) NSUInteger                projectId;
@property (strong, nonatomic) NSString          *number;
@property (strong, nonatomic) NSString          *revision;
@property (strong, nonatomic) NSString          *subject;
@property (strong, nonatomic) NSString          *date;
@property (nonatomic) NSUInteger                enteredBy;
@property (strong, nonatomic) NSString          *timeOnSite;
@property (strong, nonatomic) NSString          *timeOffSite;
@property (strong, nonatomic) NSString          *weatherIcon;
@property (nonatomic) NSUInteger                weatherId;
@property (nonatomic) NSUInteger                windId;
@property (nonatomic) NSUInteger                weatherImage;
@property (nonatomic) NSUInteger                temperature;
@property (nonatomic) NSUInteger                employeeFromId;
@property (nonatomic) NSUInteger                drCopyId;
@property (strong, nonatomic) NSString          *communicationWithOthers;
@property (strong, nonatomic) NSString          *scheduleCoordination;
@property (strong, nonatomic) NSString          *extraWork;
@property BOOL                                  extraWorkIsInternal;
@property (strong, nonatomic) NSString          *accidentReport;
@property BOOL                                  accidentReportIsInternal;
@property (strong, nonatomic) NSString          *subcontractors;
@property BOOL                                  subcontractorsIsInternal;
@property (strong, nonatomic) NSString          *otherVisitors;
@property BOOL                                  otherVisitorsIsInternal;
@property (strong, nonatomic) NSString          *problems;
@property BOOL                                  problemsIsInternal;
@property (strong, nonatomic) NSString          *internal;
@property BOOL                                  isEditable;

@end
