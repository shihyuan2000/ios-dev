//
//  NoteLocation.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/4/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "NoteLocation.h"

@implementation NoteLocation

-(id) init
{
    self = [super init];
    
    if (self)
    {
        if (!_address)
        {
            _address = [[NoteAddress alloc] init];
        }
        if (!_location)
        {
            _location = [[NoteGeolocation alloc] init];
        }
    }
    
    return self;
}

@end
