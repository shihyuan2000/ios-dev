//
//  LoginViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/22/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseProjectViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton                 *loginButton;
@property (strong, nonatomic) IBOutlet UITextField              *emailTextbox;
@property (strong, nonatomic) IBOutlet UITextField              *passwordTextbox;
@property (strong, nonatomic) IBOutlet UIButton                 *rememberMeButton;
@property (strong, nonatomic) IBOutlet UITextField              *subscriberTextbox;

- (IBAction)loginButton:(id)sender;
- (IBAction)rememberMeAction:(id)sender;


@end
