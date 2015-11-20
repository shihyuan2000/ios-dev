//
//  TimeCardViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 6/25/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "TimeCardViewController.h"
#import "ProjectObject.h"

@interface TimeCardViewController ()

@end

@implementation TimeCardViewController
{

}

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
    // Do any additional setup after loading the view from its nib.

    
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

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"Time Card";
    self.navigationItem.titleView = label;

    [self.jobNameButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    self.jobNameButton.tag = 1;
    [self.systemButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    self.systemButton.tag = 2;
    [self.phaseButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    self.phaseButton.tag = 3;
    [self.laborActivityButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    self.laborActivityButton.tag = 4;

    self.clockFormat = [[NSDateFormatter alloc] init];
    [self.clockFormat setDateFormat:@"hh:mm:ss a"];

    self.totalTimer = 0;
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClockLabel) userInfo:nil repeats:YES];

}

- (void) viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    if ([self.timer isValid])
    {
        [self.timer invalidate];
    }
    
    if ([self.clockTimer isValid])
    {
        [self.clockTimer invalidate];
    }

    self.clockLabel = nil;

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

- (void) updateClockLabel
{

    self.clockLabel.text = [self.clockFormat stringFromDate:[NSDate date]];

}

- (void) updateTimerLabel
{

    self.totalTimer++;
    int hours, minutes, seconds;
    
    hours = self.totalTimer / 3600;
    minutes = (self.totalTimer % 3600) / 60;
    seconds = (self.totalTimer % 3600) % 60;
    
    self.timerLabel.text = nil;
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
}

-(void)showPopover:(id)sender
{

    UIButton *button = sender;
    self.currentButton = button;
    
//    [self.tableViewController.tableView reloadData];

//    [self.fpPopoverController presentPopoverFromView:button];
//    [self.wyPopoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];

    
}

- (IBAction)startTimer:(id)sender
{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];

}

- (IBAction)stopTimer:(id)sender
{

    if ([self.timer isValid])
    {
        [self.timer invalidate];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (self.currentButton.tag)
    {
        case 1:
            return [self.projects count];
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
        default:
            return 1;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

/*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
*/

    if (self.currentButton.tag == 1)
    {
        ProjectObject *projectObject = [self.projects objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", projectObject.projectNumber, projectObject.projectName];
    }
    else if (self.currentButton.tag == 2)
    {
        cell.textLabel.text = @"System";
    }
    else if (self.currentButton.tag == 3)
    {
        cell.textLabel.text = @"Phase";
    }
    else if (self.currentButton.tag == 4)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"frame";
                break;
            case 1:
                cell.textLabel.text = @"hang";
                break;
            default:
                break;
        }
    }
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.currentButton.tag == 1)
    {
        ProjectObject *projectObject = [self.projects objectAtIndex:indexPath.row];
        [self.jobNameButton setTitle:[NSString stringWithFormat:@"%@ - %@", projectObject.projectNumber, projectObject.projectName] forState:UIControlStateNormal];
    }
    else if (self.currentButton.tag == 2)
    {
        [self.systemButton setTitle:@"System" forState:UIControlStateNormal];
    }
    else if (self.currentButton.tag == 3)
    {
        [self.phaseButton setTitle:@"Phase" forState:UIControlStateNormal];
    }
    else if (self.currentButton.tag == 4)
    {
        switch (indexPath.row)
        {
            case 0:
                [self.laborActivityButton setTitle:@"frame" forState:UIControlStateNormal];
                break;
            case 1:
                [self.laborActivityButton setTitle:@"hang" forState:UIControlStateNormal];
                break;
            default:
                break;
        }

    }

//    [self.fpPopoverController dismissPopoverAnimated:YES];
    
//    [self.wyPopoverController dismissPopoverAnimated:YES];

}

@end
