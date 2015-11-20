//
//  ContactsDetailViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/1/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ProjectObject.h"
#import "ContactsObject.h"

@interface ContactsDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) ProjectObject         *projectObject;
@property (strong, nonatomic) IBOutlet UITableView  *detailTableView;
@property (strong, nonatomic) ContactsObject        *contact;

@end
