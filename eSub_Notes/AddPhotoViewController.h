//
//  AddPhotoViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/16/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OldAnnotationViewController.h"

@interface AddPhotoViewController : UIViewController <UIImagePickerControllerDelegate, PhotoProtocolDelegate>
{

}

@property (strong, nonatomic) IBOutlet UIImageView          *photoImageView;

@property (strong, nonatomic) OldAnnotationViewController   *annotationVC;
@property (nonatomic) NSInteger                             projectId;
@property NSInteger                                         dailyReportId;

@end
