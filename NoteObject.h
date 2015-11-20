//
//  NoteObject.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/4/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteLocation.h"
#import "UploadObject.h"

@interface NoteObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (strong, nonatomic) NSString          *noteDate;
@property (strong, nonatomic) NSString          *notetitle;
@property (strong, nonatomic) NSString          *noteDescription;
@property (retain, nonatomic) NoteLocation      *noteLocation;
@property (strong, nonatomic) NSMutableArray    *noteImages;
@property (strong, nonatomic) NSMutableArray    *noteThumbNails;
@property (retain, nonatomic) NSMutableArray    *noteAttachments;
@property (nonatomic) NSUInteger                projectId;

@end
