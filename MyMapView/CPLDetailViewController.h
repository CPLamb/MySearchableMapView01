//
//  CPLDetailViewController.h
//  MyMapView
//
//  Created by Chris Lamb on 8/6/12.
//  Copyright (c) 2012 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CPLDetailViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) NSMutableArray *mapAnnotations;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UISwitch *satelliteViewOn;

- (IBAction)goHomeButton:(UIButton *)sender;
- (IBAction)goToBhutanButton:(UIButton *)sender;

- (IBAction)dropPinButton:(id)sender;
- (IBAction)clearPinsButton:(id)sender;
- (IBAction)searchButton:(UIButton *)sender;

- (IBAction)showSatelliteView:(UISwitch *)sender;
@end
