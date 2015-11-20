//
//  AddEmployeeTableViewController.m
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/24/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import "AddEmployeeTableViewController.h"
#import "EmployeeObject.h"

@interface AddEmployeeTableViewController ()
{

}

@end

@implementation AddEmployeeTableViewController

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
    label.text = @"Select Employees";
    self.navigationItem.titleView = label;

    self.searchResults = [NSMutableArray arrayWithCapacity:[self.employee count]];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.delegate = self;
    searchBar.frame = CGRectMake(0, 0, 0, 38);
    self.tableView.tableHeaderView = searchBar;
/*
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsVC];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
*/
    
//    self.definesPresentationContext = YES;

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];

}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

#pragma mark - UISearchResultsUpdating

//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
//    NSString *searchString = [self.searchController.searchBar text];
    
    [self updateFilteredContentForEmployeeName:searchString];

/*
    self.searchResultsVC.searchResults = self.searchResults;
    self.searchResultsVC.employeeList = self.employeeList;
    [self.searchResultsVC.tableView reloadData];
*/
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
         predicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[c] %@ AND lastName CONTAINS[c] %@)", firstName, lastName];
     } else
     {
         predicate = [NSPredicate predicateWithFormat:@"firstName contains[c] %@",searchText];
     }
     
     self.searchResults = [NSMutableArray arrayWithArray:[self.employee filteredArrayUsingPredicate:predicate]];

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
        return self.employee.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
     UITableViewCell *cell = [[UITableViewCell alloc] init];

     EmployeeObject *employee;
     if (tableView == self.searchController.searchResultsTableView)
     {
         employee = [self.searchResults objectAtIndex:indexPath.row];
     }
     else
     {
         employee = [self.employee objectAtIndex:indexPath.row];
     }

     cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", employee.firstName, employee.lastName];
     if ([self.employeeList containsObject:[NSNumber numberWithInteger:employee.id]])
     {
         cell.imageView.image = [UIImage imageNamed:@"checkmark.png"];
     }
    
     return cell;
     
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    EmployeeObject *employee;
    if (tableView == self.searchController.searchResultsTableView)
    {
        employee = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        employee = [self.employee objectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    
    if (![self.employeeList containsObject:[NSNumber numberWithInteger:employee.id]])
    {
        [self.employeeList addObject:[NSNumber numberWithInteger:employee.id]];
    }
    else
    {
        [self.employeeList removeObject:[NSNumber numberWithInteger:employee.id]];
    }

    if (tableView == self.searchController.searchResultsTableView)
    {
        [self.searchController.searchResultsTableView reloadData];
    }

    [self.tableView reloadData];

}


@end
