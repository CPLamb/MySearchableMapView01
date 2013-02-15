//
//  CPLMasterViewController.h
//  MyMapView
//
//  Created by Chris Lamb on 8/6/12.
//  Copyright (c) 2012 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPLDetailViewController;

@interface CPLMasterViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) CPLDetailViewController *detailViewController;

@property (strong, nonatomic) NSArray *countriesArrayDictionary;
@property (strong, nonatomic) NSArray *countriesArray;
@property (strong, nonatomic) NSArray *indexArray;

@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSMutableArray *filteredArray;

- (IBAction)searchButton:(UIBarButtonItem *)sender;


@end
