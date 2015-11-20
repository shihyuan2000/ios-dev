//
//  EquipmentEntryTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 2/17/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "EquipmentEntryTableViewController.h"
#import "EquipmentObject.h"
#import "AppDelegate.h"
#import "SaveNoteAFHTTPClient.h"
#import "DejalActivityView.h"

@interface EquipmentEntryTableViewController ()
{

    NSInteger equipmentId;
    UIButton *systemPhaseButton;
    NSString *equipmentInit;
    float equipmentHours;
    NSString *equipmentNotes;
    NSString *equipmentName;
    NSInteger drEquipmentId;
}

@end

@implementation EquipmentEntryTableViewController

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
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sButton.layer.borderWidth = 1;
//    sButton.layer.borderColor = [UIColor blackColor].CGColor;
    sButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.newEntry)
    {
        [sButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    else
    {
        [sButton setTitle:@"Update" forState:UIControlStateNormal];
    }
    [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:sButton];
//    if (self.dr.isEditable)
//    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:save, nil];
//    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Add Equipment";
    self.navigationItem.titleView = label;
    
    if (!self.newEntry)
    {
        equipmentId = self.equipmentObject.equipmentId;
        equipmentInit = self.equipmentObject.equipment;
        equipmentHours = self.equipmentObject.hours;
        equipmentNotes = self.equipmentObject.useageDesc;
        drEquipmentId = self.equipmentObject.drEquipmentId;
    }
    else
    {
        equipmentInit = @"Equipment";
//        equipmentHours = -1;
        equipmentNotes = @"";
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

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) keyboardDidAppear
{
    
    //self.navigationItem.rightBarButtonItem = nil;
    
}

//- (void) keyboardWillDisappear
//{
//    
//    [self addButtonSaveEdit];
//    
//}

- (void) addButtonSaveEdit
{

    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    sButton.layer.borderWidth = 1;
//    sButton.layer.borderColor = [UIColor greenColor].CGColor;
    sButton.layer.backgroundColor = [UIColor greenColor].CGColor;
    sButton.frame = CGRectMake(0, 0, 55, 15);
    sButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.newEntry)
    {
        [sButton setTitle:@"Save" forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [sButton setTitle:@"Update" forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(saveDetails) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:save, nil];
    
}

- (void) saveDetails
{
    [self.view endEditing:YES];
    if (!self.newEntry)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update not working" message:@"Bug ESUBAPI-68" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [self updateEquipment];
        return;
    }
    
    if (equipmentId == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a Equipment item" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (equipmentHours > 500)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value less than or equal to 500 for hours" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *equipment = [NSMutableDictionary dictionary];
    NSMutableArray *equipmentArray = [[NSMutableArray alloc] init];
    EquipmentObject *saveEquipment = [[EquipmentObject alloc] init];
    
    [equipment setObject:[NSNumber numberWithInteger:equipmentId] forKey:@"equipmentId"];
    [equipment setObject:[NSNumber numberWithFloat:equipmentHours] forKey:@"equipmentHours"];
    [equipment setObject: (equipmentNotes.length>500?[equipmentNotes substringToIndex:500]:equipmentNotes) forKey:@"equipmentNotes"];

    NSInteger saveEquipmentId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewEquipmentCount] intValue];
    saveEquipmentId--;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)saveEquipmentId] forKey:kNewEquipmentCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    saveEquipment.id = saveEquipmentId;
    saveEquipment.equipmentId = equipmentId;
    saveEquipment.hours = equipmentHours;
    saveEquipment.useageDesc = equipmentNotes;
    saveEquipment.projectId = self.projectId;
    saveEquipment.dailyReportId = self.dailyReportId;
    saveEquipment.equipment = equipmentName;
    saveEquipment.code = @"";
    if ([appD.reachability currentReachabilityStatus] == NotReachable) {
        saveEquipment.code = @"This equipment has not been saved";
    }
    saveEquipment.drEquipmentId = drEquipmentId;
    
    [appD.eSubsDB insertEquipmentObject:saveEquipment forUser:appD.userId forProjectId:self.projectId andDailyReportId:self.dailyReportId];
   
    
    [data setObject:[NSNumber numberWithInteger:self.dailyReportId] forKey:@"dailyReportId"];
    [equipmentArray addObject:equipment];
    [data setObject:equipmentArray forKey:@"equipment"];
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"Equipment" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to local store" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    
    [operation start];
    
}

-(void) updateEquipment
{
    [DejalBezelActivityView activityViewForView:self.view];
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    SaveNoteAFHTTPClient *client = [SaveNoteAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *equipment = [NSMutableDictionary dictionary];
    NSMutableArray *equipmentArray = [[NSMutableArray alloc] init];
//    EquipmentObject *saveEquipment = [[EquipmentObject alloc] init];
    
    [equipment setObject:[NSNumber numberWithInteger:equipmentId] forKey:@"equipmentId"];
    [equipment setObject:[NSNumber numberWithFloat:equipmentHours] forKey:@"equipmentHours"];
    [equipment setObject:(equipmentNotes.length>500?[equipmentNotes substringToIndex:500]:equipmentNotes) forKey:@"equipmentNotes"];
    [equipment setObject:[NSNumber numberWithInteger:drEquipmentId] forKey:@"drEquipmentId"];
    
    NSInteger saveEquipmentId = [[[NSUserDefaults standardUserDefaults] objectForKey:kNewEquipmentCount] intValue];
    saveEquipmentId--;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)saveEquipmentId] forKey:kNewEquipmentCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [data setObject:[NSNumber numberWithInteger:self.dailyReportId] forKey:@"dailyReportId"];
    [equipmentArray addObject:equipment];
    [data setObject:equipmentArray forKey:@"equipment"];
    [params setObject:[NSArray arrayWithObject:data] forKey:@"data"];
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:@"Equipment" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
           {
               [DejalBezelActivityView removeViewAnimated:YES];
               [self.navigationController popViewControllerAnimated:YES];
            }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
            {
                   [DejalBezelActivityView removeViewAnimated:YES];
                   [self.navigationController popViewControllerAnimated:YES];
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to local store" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                             [alert show];
                    }];
    
    [operation start];
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 2)
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
        titleLabel.text = equipmentInit;
        systemPhaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        systemPhaseButton.tag = 1;
        systemPhaseButton.frame = CGRectMake(cellWidth, 5, 40, 40);
        UIImage *btnImage = [UIImage imageNamed:@"arrow_down.png"];
        [systemPhaseButton setImage:btnImage forState:UIControlStateNormal];
        [systemPhaseButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:systemPhaseButton];
        
    }
    else if (indexPath.row == 1)
    {
        titleLabel.text = @"Hours:";
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 15, 75, 30)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.font = [UIFont systemFontOfSize:17];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tag = 1;
        textField.delegate = self;
        if (equipmentHours)
        {
            textField.text = [NSString stringWithFormat:@"%.02f", equipmentHours];
        }
        textField.inputAccessoryView = toolbar;
        [cell.contentView addSubview:textField];
    }
    else if (indexPath.row == 2)
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
        textView.text = equipmentNotes;
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    equipmentNotes = textView.text;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 6) ? NO : YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    equipmentHours = [textField.text floatValue];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >=500)
        return NO;
    return YES;
}
- (void) showPopover:(id) sender
{
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAction;
    for (EquipmentObject *projectEquipment  in self.projectEquipment)
    {
        alertAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@-%@", projectEquipment.code, projectEquipment.equipment]
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action)
                                             {
                                                 equipmentInit = [NSString stringWithFormat:@"%@-%@", projectEquipment.code, projectEquipment.equipment];
                                                 equipmentId = projectEquipment.equipmentId;
                                                 equipmentName = projectEquipment.equipment;
                                                 [self.tableView reloadData];
                                             }];
        [controller addAction:alertAction];
    }
    alertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
    }];
    
    [controller addAction:alertAction];
    
    UIPopoverPresentationController *popPresenter = [controller popoverPresentationController];
    popPresenter.sourceView = (UIButton *)sender;
    popPresenter.sourceRect = [(UIButton *)sender bounds];
    
    [self presentViewController:controller animated:YES completion:^{[DejalBezelActivityView removeViewAnimated:YES];}];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.tableView reloadData];
    
}

@end
