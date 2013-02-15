//
//  CPLDetailViewController.m
//  MyMapView
//
//  Created by Chris Lamb on 8/6/12.
//  Copyright (c) 2012 CPL Consulting. All rights reserved.
//

#import "CPLDetailViewController.h"
#import "CPLCountry.h"
#import "CPLAnnotationView.h"

@interface CPLDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation CPLDetailViewController

@synthesize detailItem = _detailItem;
@synthesize myMapView = _myMapView;
@synthesize satelliteViewOn = _satelliteViewOn;
@synthesize mapAnnotations = _mapAnnotations;
@synthesize infoLabel = _infoLabel;
@synthesize masterPopoverController = _masterPopoverController;

#define HOME_LAT 27.50
#define HOME_LONG 90.5

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
// Update the user interface whenever the detail item changes.

    if (self.detailItem) {
// Get latitude & longitude doubles from the countries dictionar table
        NSString *countryLatitude = [self.detailItem objectForKey:@"Latitude"];
        double latitudeNumber = [countryLatitude doubleValue];
        CLLocationDegrees latitudeLocation = latitudeNumber;
        NSString *countryLongitude = [self.detailItem objectForKey:@"Longitude"];
        double longitudeNumber = [countryLongitude doubleValue];
        CLLocationDegrees longitudeLocation = longitudeNumber;
        
// Getting area in square miles to calculate the span
        NSString *areaString = [self.detailItem objectForKey:@"Area"];
        int area = [areaString intValue];
        double span = [self calculateSpan:area];

// Moving & redsizing the mapview region
//        NSString *countryName = [self.detailItem objectForKey:@"Country"];
        NSString *countryName = [self.detailItem objectForKey:@"Name"];
        self.infoLabel.text = [NSString stringWithFormat:@"%@ is located at %3.2f %3.2f, Span = %2.1f", countryName, latitudeNumber, longitudeNumber, span];
        [self.myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitudeLocation, longitudeLocation), MKCoordinateSpanMake(span, span)) animated:YES];
        
        [super viewDidUnload]; 
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
// mapView setup
    self.myMapView.showsUserLocation = YES;
    [self.myMapView setDelegate:self];
    CLLocationDegrees theLatitude =  37;   //[self.detailItem objectForKey:@"Latitude"];
    CLLocationDegrees theLongitude = -122; // [self.detailItem objectForKey:@"Longitude"];
    [self.myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(theLatitude, theLongitude), MKCoordinateSpanMake(1.0, 1.0)) animated:YES];
    self.myMapView.mapType = MKMapTypeStandard;
            
// Setup for annotations & drop a pin at home
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:20];    
    CPLCountry *myHomePin = [[CPLCountry alloc] init];  
//    myHomePin.coordinate = CLLocationCoordinate2DMake(36.968, -121.9987);
    [self.myMapView addAnnotation:myHomePin];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
/*
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    CPLAnnotationView *annotationView =
    (CPLAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[CPLAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}
*/

#pragma mark - myMapView methods

- (double )calculateSpan:(int )area {
//    NSLog(@"The area = %d", area);
    double span = (sqrt(area))*0.014;
    if (span >= 15.0) {
        span = 15.0;
    }
//    NSLog(@"Calculating the span = %2.1f", span);
    return span;
}

- (IBAction)goHomeButton:(UIButton *)sender 
{
//    NSLog(@"Go Home!!");
    CLLocationDegrees theLatitude =  37.0;   //[self.detailItem objectForKey:@"Latitude"];
    CLLocationDegrees theLongitude = -122.0; // [self.detailItem objectForKey:@"Longitude"];
    [self.myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(theLatitude, theLongitude), MKCoordinateSpanMake(1.0, 1.0)) animated:YES];
}

- (IBAction)goToBhutanButton:(UIButton *)sender 
{
//    NSLog(@"Go to Bhutan button pressed");
    CLLocationDegrees theLatitude =  27.50;   //[self.detailItem objectForKey:@"Latitude"];
    CLLocationDegrees theLongitude = 90.5; // [self.detailItem objectForKey:@"Longitude"];
    [self.myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(theLatitude, theLongitude), MKCoordinateSpanMake(3.0, 3.0)) animated:YES];
}

- (IBAction)dropPinButton:(id)sender {
    NSLog(@"Drops a pin close to my home");
    CLLocationCoordinate2D aNewLocation = CLLocationCoordinate2DMake(37.010, -122.010);
    CPLCountry *aNewPin = [[CPLCountry alloc] initWithCoordinates:aNewLocation placeName:@"NewLocation" description:@"close by"];
    [self.mapAnnotations addObject:aNewPin];
    [self.myMapView addAnnotation:aNewPin];
     }

- (IBAction)clearPinsButton:(id)sender {
    NSLog(@"Clears ALL pins off the map!");
    [self.myMapView removeAnnotations:self.mapAnnotations];
}

- (IBAction)searchButton:(UIButton *)sender {
    NSLog(@"Need to make this a delegate method");
}

- (IBAction)showSatelliteView:(UISwitch *)sender {
    if (sender.on) {
        NSLog(@"Turn ON satelliteview");
        self.myMapView.mapType = MKMapTypeHybrid;
    }
    if (!sender.on) {
        NSLog(@"Turn OFF satelliteview");
        self.myMapView.mapType = MKMapTypeStandard;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
    self.infoLabel.text = @"NOW WHAT!!!!";
}

- (void)viewDidUnload {
    [self setInfoLabel:nil];
    [super viewDidUnload];
}

@end
