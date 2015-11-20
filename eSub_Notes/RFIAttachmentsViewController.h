//
//  RFIAttachmentsViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/11/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectObject.h"
#import "RFIObject.h"

@interface RFIAttachmentsViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) ProjectObject             *projectObject;
@property (strong, nonatomic) IBOutlet UITableView      *rfiAttachmentsTableView;
@property (strong, nonatomic) RFIObject                 *rfiObject;

@end
