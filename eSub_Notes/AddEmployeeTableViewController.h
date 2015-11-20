//
//  AddEmployeeTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/24/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEmployeeTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray                    *employee;
@property (strong, nonatomic) NSMutableArray                    *employeeList;
//@property (nonatomic, strong) UISearchController        *searchController;
@property (nonatomic, strong) UISearchDisplayController         *searchController;
@property (nonatomic, strong) NSMutableArray                    *searchResults;

@end
