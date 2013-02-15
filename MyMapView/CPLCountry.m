//
//  CPLCountry.m
//  MyMapView
//
//  Created by Chris Lamb on 8/6/12.
//  Copyright (c) 2012 CPL Consulting. All rights reserved.
//

#import "CPLCountry.h"
#include <stdlib.h>

#define HOME_LAT 36.96805
#define HOME_LONG -121.9987

@implementation CPLCountry
@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

/*- (CLLocationCoordinate2D)coordinate { 
    NSLog(@"get some coords");
    double rlat = 36.986;
    double rlong = -121.9987;
    NSLog(@"Lat N Long = %f, %f", rlat, rlong);
    
    return CLLocationCoordinate2DMake(rlat, rlong);
}
*/
#pragma mark Overidden getters

- (CLLocationCoordinate2D)coordinate {    
//    double rlat = (double)(rand() % 1000 - 500)/30000.0;
//    double rlong = (double)(rand() % 1000 - 500)/30000.0;
    double lat = [self.latitude doubleValue];
    double lon = [self.longitude doubleValue];
    
//    NSLog(@"Coords are %3.3f %3.3f", lat, lon);    
    return CLLocationCoordinate2DMake(lat, lon);
}
/*
- (NSString *)title {
    return @"My Home";
}

- (NSString *)subTitle {
    return @"CPL's house in Santa Cruz";

}
*/
- (id)initWithCoordinates:(CLLocationCoordinate2D )location placeName:(NSString *)placeName description:(NSString *)description {
    self.latitude = [NSNumber numberWithDouble:location.latitude];
    self.longitude = [NSNumber numberWithDouble:location.longitude];
    self.title = placeName;
    self.subTitle = description;
    return self;
}



@end
