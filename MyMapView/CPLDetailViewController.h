//
//  CPLDetailViewController.h
//  MyMapView
//
//  Created by Chris Lamb on 8/6/12.
//  Copyright (c) 2012 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPLDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
