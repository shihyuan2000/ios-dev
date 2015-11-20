//
//  ContactsViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 4/30/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "ContactsViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "NoteAFHTTPClient.h"
#import "ContactsDetailViewController.h"
#import "Common.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadContacts:) forControlEvents:UIControlEventValueChanged];
    [self.contactTableView addSubview:refreshControl];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 480, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = self.projectObject.projectName;
    self.navigationItem.titleView = label;

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDC.searchResultsDelegate = (id)self;
    self.searchDC.searchResultsDataSource = (id)self;
    self.searchDC.delegate = self;
    searchBar.frame = CGRectMake(0, 0, 0, 38);
    self.contactTableView.tableHeaderView = searchBar;

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if (!self.contacts)
    {
        [self getContacts];
    }
    
}

- (void) getContacts
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    [DejalBezelActivityView activityViewForView:self.view];
    [Common GetListOfContacts:(int)self.projectObject.id
        success:^(NSMutableArray *contacts)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [appD.eSubsDB deleteContactObjects:self.projectObject.id];

            for (ContactsObject *contact in contacts)
            {
                [appD.eSubsDB insertContactObject:contact forProjectId:self.projectObject.id];
            }
            self.contacts = contacts;
            [self buildContentFilter];
        }
        failure:^(NSHTTPURLResponse *response, NSError *error)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            self.contacts = [appD.eSubsDB getContactObjects:self.projectObject.id];
            [self buildContentFilter];
        }];
    
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

- (void) buildContentFilter
{
    
    [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"contactLastname" ascending:YES]]];
    
    BOOL found;
    self.sections = [[NSMutableDictionary alloc] init];
    
    // Loop through the books and create our keys
    for (ContactsObject *contact in self.contacts)
    {
        NSString *c = @"";
        if (contact.contactLastname.length)
        {
            c = [contact.contactLastname substringToIndex:1];
        }
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    for (ContactsObject *contact in self.contacts)
    {
        if (contact.contactLastname.length)
        {
            [[self.sections objectForKey:[contact.contactLastname substringToIndex:1]] addObject:contact];
        }
        else
        {
            [[self.sections objectForKey:@""] addObject:contact];
        }
    }
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"contactLastname" ascending:YES]]];
    }
    
    self.filteredArray = [NSMutableArray arrayWithCapacity:[self.contacts count]];
    [self.contactTableView reloadData];

}

- (void) reloadContacts: (UIRefreshControl *)refreshControl
{

    [refreshControl endRefreshing];

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{

    if (tableView == self.searchDC.searchResultsTableView)
    {
        return 1;
    }
    else
    {
        return [[self.sections allKeys] count];
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.searchDC.searchResultsTableView)
    {
        return [self.filteredArray count];
        
    } else
    {
        return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (tableView == self.searchDC.searchResultsTableView)
    {
        return nil;
    }
    else
    {
        return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    ContactsObject *contact;
    if (tableView == self.searchDC.searchResultsTableView)
    {
        contact = [self.filteredArray objectAtIndex:indexPath.row];
    }
    else
    {
        contact = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.contactFirstname, contact.contactLastname];
    cell.detailTextLabel.text = contact.contactCompany;
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsDetailViewController *contactsVC = [[ContactsDetailViewController alloc] initWithNibName:@"ContactsDetailViewController" bundle:nil];
    contactsVC.projectObject = self.projectObject;
    if (tableView == self.searchDC.searchResultsTableView)
    {
        contactsVC.contact = [self.filteredArray objectAtIndex:indexPath.row];
    }
    else
    {
        contactsVC.contact = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:contactsVC animated:YES];

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if (tableView == self.searchDC.searchResultsTableView)
    {
        return nil;
    }
    else
    {
        return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
}

#pragma mark Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredArray removeAllObjects];
    // Filter the array using NSPredicate
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactLastname contains[c] %@",searchText];

    
    NSArray *array = [searchText componentsSeparatedByString:@" "];
    NSString *firstName = searchText;
    NSString *lastName = searchText;
    NSPredicate *predicate = nil;
    
    if ([array count] > 1)
    {
        firstName = array[0];
        lastName = array[1];
        predicate = [NSPredicate predicateWithFormat:@"(contactFirstname CONTAINS[c] %@ AND contactLastname CONTAINS[c] %@)", firstName, lastName];
    } else
    {
        predicate = [NSPredicate predicateWithFormat:@"contactFirstname contains[c] %@",searchText];
    }

    self.filteredArray = [NSMutableArray arrayWithArray:[self.contacts filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;

}

-(void)setCorrectFrames
{
    
    // Here we set the frame to avoid overlay
    CGRect searchDisplayerFrame = self.searchDisplayController.searchResultsTableView.superview.frame;
    searchDisplayerFrame.origin.y = CGRectGetMaxY(self.searchDisplayController.searchBar.frame);
    searchDisplayerFrame.size.height -= searchDisplayerFrame.origin.y;
    self.searchDisplayController.searchResultsTableView.superview.frame = searchDisplayerFrame;
    
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
    [self setCorrectFrames];

}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
    [self setCorrectFrames];
    
}

@end
