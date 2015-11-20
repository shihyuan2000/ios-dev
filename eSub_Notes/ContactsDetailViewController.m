//
//  ContactsDetailViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/1/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "ContactsDetailViewController.h"
#import "ContActAddressObject.h"
#import "PhoneButton.h"

@interface ContactsDetailViewController ()

@end

@implementation ContactsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
        
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = self.projectObject.projectName;
    self.navigationItem.titleView = label;
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    sButton.frame = CGRectMake(0, 0, 40, 40);
    sButton.tintColor = [UIColor blackColor];
    [sButton addTarget:self action:@selector(addToContacts:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settings, nil];


//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 140)];

//    self.detailTableView.tableHeaderView = headerView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

#pragma mark - UITableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    return 1 + self.contact.contactAddresses.count * 10;
    return 11;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Contact Details";
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    ContactAddressObject *addresses = [self.contact.contactAddresses objectAtIndex:0];
    PhoneButton *cellButton;
    PhoneButton *textButton;
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.contact.contactFirstname, self.contact.contactLastname];
            cell.detailTextLabel.text = self.contact.contactCompany;
            break;
        case 1:
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", addresses.address.address1, addresses.address.address2, addresses.address.city, addresses.address.state, addresses.address.zip, addresses.address.country];
            break;
        case 2:

            if (addresses.mobile.length)
            {
                cellButton = [[PhoneButton alloc] initWithFrame:CGRectMake(290, 15, 25, 25)];
                [cellButton setBackgroundImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
                [cellButton addTarget:self action:@selector(dailPhone:) forControlEvents:UIControlEventTouchUpInside];
                cellButton.phoneNumber = addresses.mobile;
                [cell.contentView addSubview:cellButton];
                textButton = [[PhoneButton alloc] initWithFrame:CGRectMake(240, 15, 25, 25)];
                [textButton setBackgroundImage:[UIImage imageNamed:@"bubble.png"] forState:UIControlStateNormal];
                [textButton addTarget:self action:@selector(textMessage:) forControlEvents:UIControlEventTouchUpInside];
                textButton.phoneNumber = addresses.phone;
                [cell.contentView addSubview:textButton];
            }
            cell.textLabel.text = @"Mobile";
            cell.detailTextLabel.text = addresses.mobile;
            break;
        case 3:
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = addresses.email;
            break;
        case 4:
            if (addresses.phone.length)
            {
                cellButton = [[PhoneButton alloc] initWithFrame:CGRectMake(290, 15, 25, 25)];
                [cellButton setBackgroundImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
                [cellButton addTarget:self action:@selector(dailPhone:) forControlEvents:UIControlEventTouchUpInside];
                cellButton.phoneNumber = addresses.phone;
                [cell.contentView addSubview:cellButton];
                textButton = [[PhoneButton alloc] initWithFrame:CGRectMake(240, 15, 25, 25)];
                [textButton setBackgroundImage:[UIImage imageNamed:@"bubble.png"] forState:UIControlStateNormal];
                [textButton addTarget:self action:@selector(textMessage:) forControlEvents:UIControlEventTouchUpInside];
                textButton.phoneNumber = addresses.phone;
                [cell.contentView addSubview:textButton];
            }
            cell.textLabel.text = @"Phone";
            cell.detailTextLabel.text = addresses.phone;
            break;
        case 5:
            cell.textLabel.text = @"Fax";
            cell.detailTextLabel.text = addresses.fax;
            break;
        case 6:
            if (addresses.tollFree.length)
            {
                cellButton = [[PhoneButton alloc] initWithFrame:CGRectMake(290, 15, 25, 25)];
                [cellButton setBackgroundImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
                [cellButton addTarget:self action:@selector(dailPhone:) forControlEvents:UIControlEventTouchUpInside];
                cellButton.phoneNumber = addresses.tollFree;
                [cell.contentView addSubview:cellButton];
            }
            cell.textLabel.text = @"TollFree";
            cell.detailTextLabel.text = addresses.tollFree;
            break;
        case 7:
            if (addresses.home.length)
            {
                cellButton = [[PhoneButton alloc] initWithFrame:CGRectMake(290, 15, 25, 25)];
                [cellButton setBackgroundImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
                [cellButton addTarget:self action:@selector(dailPhone:) forControlEvents:UIControlEventTouchUpInside];
                cellButton.phoneNumber = addresses.home;
                [cell.contentView addSubview:cellButton];
            }

            cell.textLabel.text = @"Home";
            cell.detailTextLabel.text = addresses.home;
            break;
        case 8:
            cell.textLabel.text = @"Website";
            cell.detailTextLabel.text = addresses.website;
            break;
        case 9:
            cell.textLabel.text = @"Type";
            cell.detailTextLabel.text = addresses.type;
            break;
        case 10:
            cell.textLabel.text = @"Pager";
            cell.detailTextLabel.text = addresses.pager;
            break;
    }

    return cell;

    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ContactAddressObject *addresses = [self.contact.contactAddresses objectAtIndex:0];
    MFMailComposeViewController *controller;
    
    switch (indexPath.row)
    {
        case 3:
        {
            controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            NSArray *toRecipients = [NSArray arrayWithObjects:addresses.email, nil];
            [controller setToRecipients:toRecipients];
//            [controller setTitle:@"Contact Us"];
//            [controller setSubject:@"Your Mail Subject"];
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                controller.modalPresentationStyle = UIModalPresentationFormSheet;
            }
            else
            {
                controller.modalPresentationStyle = UIModalPresentationFullScreen;
            }
            [self presentViewController:controller animated:YES completion:nil];

            break;
        }
        case 8:
        {
            NSURL *url;
            if ([addresses.website rangeOfString:@"http:"].location == NSNotFound)
            {
                NSString *str = [NSString stringWithFormat:@"http:////%@", addresses.website];
                url = [NSURL URLWithString:str];
            }
            else
            {
                url = [NSURL URLWithString:addresses.website];
            }
            [[UIApplication sharedApplication] openURL:url];
            break;
        }
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:NO completion:nil];

}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{

    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void) dailPhone: (id) sender
{
    
    PhoneButton *button = sender;
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] )
    {
        NSString *cleanedString = [[button.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL])
        {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}

- (void) textMessage: (id) sender
{

    PhoneButton *button = sender;
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        NSString *cleanedString = [[button.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        controller.recipients = [NSArray arrayWithObjects:cleanedString, nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void) addToContacts: (id) sender
{
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
        {
            if (granted)
            {
                [self addGranted];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        // The user has previously given access, add the contact
        [self addGranted];
    }

}

 - (void) addGranted
{
    ContactAddressObject *addresses = [self.contact.contactAddresses objectAtIndex:0];
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef newPerson = ABPersonCreate();
    
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFStringRef) self.contact.contactFirstname, nil);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFStringRef)self.contact.contactLastname, nil);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFStringRef)self.contact.contactCompany, nil);
    
    if (addresses.phone != nil)
    {
        ABMutableMultiValueRef phoneNumberMultiValue =  ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,(__bridge CFStringRef)addresses.phone, kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty,  phoneNumberMultiValue, nil);
    }
    
    if (addresses.address != nil)
    {
        ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        
        NoteAddress *address = addresses.address;
        if (address.address1 != nil)
        {
            addressDictionary[(NSString *) kABPersonAddressStreetKey] = address.address1;
        }
        if (address.city != nil)
        {
            addressDictionary[(NSString *)kABPersonAddressCityKey] = address.city;
        }
        if (address.state != nil)
        {
            addressDictionary[(NSString *)kABPersonAddressStateKey] = address.state;
        }
        if (address.zip != nil)
        {
            addressDictionary[(NSString *)kABPersonAddressZIPKey] = address.zip;
        }
        ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef) addressDictionary, kABWorkLabel, NULL);
        
        ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress, nil);
    }
    
    if (addresses.email != nil)
    {
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef) addresses.email, kABWorkLabel, NULL);
        
        ABRecordSetValue(newPerson, kABPersonEmailProperty, emailMultiValue, nil);
    }
    
    CFErrorRef cfError = NULL;
    ABAddressBookAddRecord(ab, newPerson, nil);
    if (ABAddressBookSave(ab, &cfError))
    {
        NSLog(@"\nPerson Saved successfuly");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your contact was sucessfully added" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else
    {
        NSLog(@"\n Error Saving person to AddressBook");
        NSError *error = (__bridge NSError *)cfError;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.description delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }

}

@end
