//
//  MaterialsEntryTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/19/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "MaterialsEntryTableViewController.h"
#import "AppDelegate.h"
#import "SaveNoteAFHTTPClient.h"
#import "DejalActivityView.h"
#import "Common.h"
@interface MaterialsEntryTableViewController ()
{
    
    UIButton *systemPhaseButton;
    
    NSInteger materialId;
    NSString *materialName;
    NSString *materialQuantity;
    NSString *materialPer;
    NSString *materialNotes;
    NSInteger  materialFlag;
}
@end

@implementation MaterialsEntryTableViewController

- (void)viewDidLoad {
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
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sButton.layer.borderWidth = 1;
//    sButton.layer.borderColor = [UIColor blackColor].CGColor;
    sButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sButton setTitle:@"Save" forState:UIControlStateNormal];
//    [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:save, nil];
    self.saveBtn = sButton;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Add Material";
    self.navigationItem.titleView = label;
    
    if (self.newEntry)
    {
        [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
        materialId = 0;
        materialName = @"";
        materialQuantity = @"";
        materialPer = @"Per";
        materialNotes = @"";
        materialFlag = 1;
    }
    else
    {
        [self.saveBtn setTitle:@"Update" forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(updateDetails) forControlEvents:UIControlEventTouchUpInside];
        materialId = self.id;
        materialName = self.name;
        materialQuantity = self.quantityValue;
        materialPer = self.perValue;
        materialNotes = self.notesValue;
        materialFlag = 2;//self.flag;
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveDetails
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    MaterialsObject *material = [[MaterialsObject alloc] init];
    material.id = materialId;
    material.name = materialName;
    material.quantityValue =materialQuantity;
    material.perValue = materialPer;
    material.notesValue = (materialNotes.length>500?[materialNotes substringToIndex:500]:materialNotes);
    material.flag = materialFlag;
    
    [self.projectMaterials addObject:material];

    if ([appD.reachability currentReachabilityStatus] != NotReachable)
    {
        material.flag = 0;
        [DejalBezelActivityView activityViewForView:self.view];

        [Common SaveMaterial:material dailyReportId:self.dailyReportId
          success:^(id responseObject)
         {
             [DejalBezelActivityView removeViewAnimated:YES];
         }
        failure:^(NSError *error)
         {
             [DejalBezelActivityView removeViewAnimated:YES];
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
              [alert show];
         }];
    }
    
    if (self.newEntry) {
        [appD.eSubsDB insertProjectMaterialObject:material forProjectId:self.projectId forDailyReportId:self.dailyReportId];
    }
    else
    {
        [appD.eSubsDB updateProjectMaterialObject:material forProjectId:self.projectId];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) updateDetails
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    MaterialsObject *material = [[MaterialsObject alloc] init];
    material.id = materialId;
    material.name = materialName;
    material.quantityValue =materialQuantity;
    material.perValue = materialPer;
    material.notesValue = (materialNotes.length>500?[materialNotes substringToIndex:500]:materialNotes);
    material.flag = materialFlag;
    
    [self.projectMaterials addObject:material];
    
    if ([appD.reachability currentReachabilityStatus] != NotReachable)
    {
        material.flag = 0;
        [DejalBezelActivityView activityViewForView:self.view];
        
        [Common UpdateMaterial:material dailyReportId:self.dailyReportId
        success:^(id responseObject)
         {
             [DejalBezelActivityView removeViewAnimated:YES];
         }
         failure:^(NSError *error)
         {
             [DejalBezelActivityView removeViewAnimated:YES];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }];
    }
    

    [appD.eSubsDB updateProjectMaterialObject:material forProjectId:self.projectId];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

//- (void) keyboardDidAppear
//{

//    self.navigationItem.rightBarButtonItem = nil;
    
//}

//- (void) keyboardWillDisappear
//{
//    
//    [self addButtonSaveEdit];
//    
//}

- (void) addButtonSaveEdit
{
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sButton.layer.borderWidth = 1;
    sButton.layer.borderColor = [UIColor blackColor].CGColor;
    sButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (self.newEntry)
    {
        [sButton setTitle:@"Save" forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [sButton setTitle:@"Update" forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(updateDetails) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:save, nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 3)
    {
        return 220;
    }
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    float cellWidth;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleBlackOpaque;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resetView)];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    
    if (indexPath.row == 4)
    {
        cellWidth = 100;
    }
    else
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            if (orientation == UIInterfaceOrientationPortrait)
            {
                cellWidth = 650;
            }
            else
            {
                cellWidth = 900;
            }
        }
        else
        {
            if (orientation == UIInterfaceOrientationPortrait)
            {
                cellWidth = 250;
            }
            else
            {
                cellWidth = 480;
            }
        }
    }
    
    UILabel *titleLabel;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 4, cellWidth, 43)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.row == 0)
    {
        titleLabel.text = @"Material:";
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 15, cellWidth - 25, 30)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.font = [UIFont systemFontOfSize:17];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.tag = 1;
        textField.delegate = self;
        textField.text = materialName;
        textField.inputAccessoryView = toolbar;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:textField];
    }
    if (indexPath.row == 1)
    {
        titleLabel.text = @"Quantity:";
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 15, 50, 30)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.font = [UIFont systemFontOfSize:17];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tag = 2;
        textField.delegate = self;
        textField.text = materialQuantity;
        textField.inputAccessoryView = toolbar;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:textField];
    }
    else if (indexPath.row == 2)
    {
        titleLabel.text = materialPer;
        systemPhaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        systemPhaseButton.tag = 1;
        systemPhaseButton.frame = CGRectMake(cellWidth, 5, 40, 40);
        UIImage *btnImage = [UIImage imageNamed:@"arrow_down.png"];
        [systemPhaseButton setImage:btnImage forState:UIControlStateNormal];
        [systemPhaseButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:systemPhaseButton];
    }
    else if (indexPath.row == 3)
    {
        titleLabel.text = @"Notes:";
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 50, cellWidth, 150)];
        [[textView layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[textView layer] setBorderWidth:2];
        textView.font = [UIFont systemFontOfSize:17];
        textView.keyboardType = UIKeyboardTypeDefault;
        textView.textAlignment = NSTextAlignmentLeft;
        textView.tag = 2;
        textView.delegate = self;
        textView.text = materialNotes;
        textView.inputAccessoryView = toolbar;
        [cell.contentView addSubview:textView];
    }
    
    return cell;
    
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self showPopover:systemPhaseButton];
}

- (void)resetView
{
    
    [self.view endEditing:YES];
    
}

//- (void)textViewDidEndEditing:(UITextView *)textView
- (void)textViewDidChange:(UITextView *)textView
{
    
    materialNotes = textView.text;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 50) ? NO : YES;
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
- (void)textFieldDidChange:(id) sender
{
    UITextField *textField = (UITextField *)sender;
    if (textField.tag == 1)
    {
        materialName = textField.text;
    }
    else if (textField.tag == 2)
    {
        materialQuantity = textField.text;
    }
    
}

-(void) showPopover:(id)sender
{
    
    self.button = sender;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a Units Per"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (NSString *str in self.perList)
    {
        [actionSheet addButtonWithTitle:str];
    }
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //    {
    //        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    //    }
    //    else
    {
        [actionSheet showInView:self.view];
    }
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // Handle cancel
    if (buttonIndex == 0)
    {
        return;
    }
    
    materialPer = [self.perList objectAtIndex:buttonIndex - 1];
    
    [self.tableView reloadData];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.tableView reloadData];
    
}

@end
