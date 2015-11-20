//
//  ProjectObject.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/4/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteEmployee.h"
#import "NoteLocation.h"

@interface ProjectObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (strong, nonatomic) NSString          *projectNumber;
@property (strong, nonatomic) NSString          *projectName;
@property (strong, nonatomic) NSString          *projectStatus;
@property (strong, nonatomic) NSString          *projectStartDate;
@property (strong, nonatomic) NSString          *projectEndDate;
//@property (retain, nonatomic) NoteEmployee      *projectManager;
@property (retain, nonatomic) NSString          *projectManager;
@property (retain, nonatomic) NoteLocation      *projectLocation;
@property (strong, nonatomic) NSString          *projectComments;

@end
