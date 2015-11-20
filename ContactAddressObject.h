//
//  ContactAddressObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 4/30/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteAddress.h"

@interface ContactAddressObject : NSObject

@property (retain, nonatomic) NoteAddress           *address;
@property (strong, nonatomic) NSString              *phone;
@property (strong, nonatomic) NSString              *fax;
@property (strong, nonatomic) NSString              *mobile;
@property (strong, nonatomic) NSString              *pager;
@property (strong, nonatomic) NSString              *tollFree;
@property (strong, nonatomic) NSString              *home;
@property (strong, nonatomic) NSString              *email;
@property (strong, nonatomic) NSString              *website;
@property (strong, nonatomic) NSString              *type;

@end
