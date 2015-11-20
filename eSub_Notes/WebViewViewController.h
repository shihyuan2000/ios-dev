//
//  WebViewViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 9/20/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"

@interface WebViewViewController : UIViewController <UIWebViewDelegate>

@property NSInteger                                     typeId;
@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) IBOutlet UIWebView        *webView;
@property (strong, nonatomic) IBOutlet UIButton         *backButton;
@property (strong, nonatomic) IBOutlet UIButton         *forwardButton;

@end
