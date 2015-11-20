//
//  ContactsObject.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 4/30/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsObject : NSObject

@property (nonatomic) NSUInteger                id;
@property (nonatomic) NSUInteger                  AddressId;
@property (strong, nonatomic) NSString          *contactFirstname;
@property (strong, nonatomic) NSString          *contactLastname;
@property (strong, nonatomic) NSString          *contactCompany;
@property (strong, nonatomic) NSMutableArray    *contactAddresses;

@end
