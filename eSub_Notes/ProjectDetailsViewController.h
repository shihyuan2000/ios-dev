//
//  ProjectDetailsViewController.h
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/23/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "NoteDetailsViewController.h"
#import "ProjectObject.h"
#import "DisplayNoteViewController.h"

@interface ProjectDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton     *noteButton;
@property (strong, nonatomic) IBOutlet UITableView  *projectDetailsTableView;
@property (assign, nonatomic) NSInteger             selectedNoteIndex;
@property (strong, nonatomic) NSMutableArray        *notes;
@property (strong, nonatomic) ProjectObject         *projectObject;
@property (nonatomic) BOOL                          refresh;

@property (assign, nonatomic) NSInteger             projectId;

@end
