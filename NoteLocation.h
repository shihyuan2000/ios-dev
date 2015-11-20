//
//  NoteLocation.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 2/4/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteAddress.h"
#import "NoteGeolocation.h"

@interface NoteLocation : NSObject

@property (retain, nonatomic) NoteAddress           *address;
@property (retain, nonatomic) NoteGeolocation       *location;

@end