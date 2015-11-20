//
//  RFIAttachmentsViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 5/11/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "RFIAttachmentsViewController.h"
#import "RFIAttachment.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"

@interface RFIAttachmentsViewController ()

@end

@implementation RFIAttachmentsViewController

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
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    NSString *txt1 = @"";
    if (self.rfiObject.revision > 0)
    {
        txt1 = [NSString stringWithFormat:@"-%lu", (unsigned long)self.rfiObject.revision];
    }
    title.text = [NSString stringWithFormat:@"%@%@ %@", self.rfiObject.rfiNumber, txt1, self.rfiObject.rfiSubject];
    title.textAlignment = NSTextAlignmentCenter;
    
    [statusView addSubview:title];
    
    self.rfiAttachmentsTableView.tableHeaderView = statusView;

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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.rfiObject.rfiAttachments.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 
 {
 
 return @"RFI Details";
 
 }
 */

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    RFIAttachment *attachment = [self.rfiObject.rfiAttachments objectAtIndex:indexPath.row];

    if (self.rfiObject.rfiThumbNails.count)
    {
        cell.imageView.image = [UIImage imageWithData:[appD.eSubsDB getRFIThumbNailData:self.rfiObject.rfiThumbNails[indexPath.row]]];
        NSLog(@"image from SQLite for sql image id : %@", self.rfiObject.rfiThumbNails[0]);
    }
    else if (self.rfiObject.rfiAttachments.count)
    {
        if (attachment.thumbnail.length > 0)
        {
            dispatch_queue_t imageQueue = dispatch_queue_create("RFI Image Queue", NULL);
            dispatch_async(imageQueue, ^{
        
                NSError *error = nil;
        
                NSString *encodedText = [attachment.thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if ([NSURL URLWithString:encodedText])
                {
                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
                    if (data.length)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        NSUInteger id = [appD.eSubsDB insertRFIThumbNail:data];
                        if (self.rfiObject.rfiThumbNails == nil)
                        {
                            self.rfiObject.rfiThumbNails = [[NSMutableArray alloc] init];
                        }
                        [self.rfiObject.rfiThumbNails addObject:[NSNumber numberWithLong:id]];
                        NSLog(@"Added RFI Thumbnail : %lu", (unsigned long)id);
                        cell.imageView.image = [UIImage imageWithData:data];
                        });
                    }
                    else
                    {
                        NSLog(@"No RFI thumbnail data : %@", [error localizedDescription]);
                        NSLog(@"URL for thumbnail: %@", attachment.thumbnail);
                    }
                }
                else
                {
                    NSLog(@"NSURL returned nil");
                }
            });
        }
    }

    cell.textLabel.text = attachment.filename;
    cell.detailTextLabel.text = attachment.desc;
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

/*
    RFIAttachment *attachment = [self.rfiObject.rfiAttachments objectAtIndex:indexPath.row];

    NSString *encodedText = [attachment.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([NSURL URLWithString:encodedText])
    {
        NSError *error = nil;
        [DejalBezelActivityView activityViewForView:self.view];
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
        [DejalBezelActivityView removeViewAnimated:YES];
        if (data.length)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *ext = [attachment.url pathExtension];
            
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"MyFile.%@", ext]];
            [data writeToFile:appFile atomically:YES];
            NSURL *url = [[NSURL alloc] initFileURLWithPath:appFile];
            if (url)
            {
                UIDocumentInteractionController *controller;
                controller = [UIDocumentInteractionController interactionControllerWithURL:url];
                controller.delegate = self;
                [controller presentPreviewAnimated:YES];
            }
        }
    }
*/
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    RFIAttachment *attachment = [self.rfiObject.rfiAttachments objectAtIndex:indexPath.row];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", self.projectObject.projectName, attachment.filename]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSString *encodedText = [attachment.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [DejalBezelActivityView activityViewForView:self.view];
        dispatch_queue_t imageQueue = dispatch_queue_create("RFI Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            NSError *error;
            NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedText] options:NSDataReadingUncached error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [DejalBezelActivityView removeViewAnimated:YES];
                
                NSError *error;
                if (![pdfData writeToFile:filePath options:NSDataWritingAtomic error:&error])
                {
                    NSLog(@"WriteToFile failed RFIAttachmentsViewController: %@", error);
                }
                NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
                if (url)
                {
                    UIDocumentInteractionController *controller;
                    controller = [UIDocumentInteractionController interactionControllerWithURL:url];
                    controller.delegate = self;
                    [controller presentPreviewAnimated:YES];
                }

            });
        });
    }
    else
    {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
        if (url)
        {
            UIDocumentInteractionController *controller;
            controller = [UIDocumentInteractionController interactionControllerWithURL:url];
            controller.delegate = self;
            [controller presentPreviewAnimated:YES];
        }
        
    }

}

-(UIViewController *)documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    
    return self;
    
}


@end
