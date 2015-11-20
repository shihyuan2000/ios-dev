//
//  SearchTableViewController.h
//  eSUB
//
//  Created by LAWRENCE SHANNON on 1/25/15.
//  Copyright (c) 2015 LAWRENCE SHANNON. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchProtocolDelegate

- (void)searchCompleted: (NSUInteger) contactID;

@end

@interface SearchTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    id delegate;
}

@property (strong, nonatomic) NSMutableArray                    *contacts;

@property (nonatomic, strong) UISearchDisplayController         *searchController;
@property (nonatomic, strong) NSMutableArray                    *searchResults;

- (void) setDelegate:(id)newDelegate;

@end
