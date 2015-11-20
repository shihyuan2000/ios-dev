//
//  SearchTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/25/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ContactsObject.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (void) setDelegate:(id)newDelegate
{

    delegate = newDelegate;

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
    label.text = @"Select Contact";
    self.navigationItem.titleView = label;
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.contacts count]];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.delegate = self;
    searchBar.frame = CGRectMake(0, 0, 0, 38);
    self.tableView.tableHeaderView = searchBar;

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];

}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

#pragma mark - UISearchResultsUpdating

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self updateFilteredContentForEmployeeName:searchString];
    
    return YES;
    
}

#pragma mark - Content Filtering


- (void)updateFilteredContentForEmployeeName:(NSString *)searchText
{
    
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.searchResults removeAllObjects];
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
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.contacts filteredArrayUsingPredicate:predicate]];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchController.searchResultsTableView)
    {
        return [self.searchResults count];
        
    } else
    {
        return self.contacts.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
    
    ContactsObject *contact = [self.contacts objectAtIndex:indexPath.row];
    if (tableView == self.searchController.searchResultsTableView)
    {
        contact = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        contact = [self.contacts objectAtIndex:indexPath.row];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@, %@", contact.contactCompany, contact.contactLastname, contact.contactFirstname];

    return cell;
     
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsObject *contact;
    if (tableView == self.searchController.searchResultsTableView)
    {
        contact = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        contact = [self.contacts objectAtIndex:indexPath.row];
    }

    [delegate searchCompleted:contact.id];

    [self.navigationController popViewControllerAnimated:YES];

}

@end
