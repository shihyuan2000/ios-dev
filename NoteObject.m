//
//  NoteObject.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/4/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "NoteObject.h"

@implementation NoteObject

-(id) init
{
    self = [super init];
    
    if (self)
    {
        if (!_noteLocation)
        {
            _noteLocation = [[NoteLocation alloc] init];
        }
        if (!_noteImages)
        {
            _noteImages = [[NSMutableArray alloc] init];
        }
        if (!_noteThumbNails)
        {
            _noteThumbNails = [[NSMutableArray alloc] init];
        }
        if (!_noteAttachments)
        {
            _noteAttachments = [[NSMutableArray alloc] init];
        }

    }
    
    return self;
}

@end
