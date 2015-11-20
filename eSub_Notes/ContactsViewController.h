//
//  ContactsViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 4/30/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"
#import "ContactsObject.h"
#import "ContactAddressObject.h"

@interface ContactsViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView      *contactTableView;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) NSMutableArray            *contacts;
@property (strong, nonatomic) NSMutableDictionary       *sections;
@property (strong, nonatomic) NSMutableArray            *filteredArray;
@property (strong, nonatomic) UISearchDisplayController *searchDC;

@end
