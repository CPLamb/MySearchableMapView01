//
//  CPLMasterViewController.h
//  MyMapView
//
//  Created by Chris Lamb on 8/6/12.
//  Copyright (c) 2012 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPLDetailViewController;

@interface CPLMasterViewController : UITableViewController

@property (strong, nonatomic) CPLDetailViewController *detailViewController;

@end
