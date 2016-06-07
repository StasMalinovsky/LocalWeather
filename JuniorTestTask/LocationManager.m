//
//  LocationManager.m
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 25.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "LocationManager.h"


@interface LocationManager ()

@end

@implementation LocationManager

+ (LocationManager *)sharedManager {
    static LocationManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[LocationManager alloc] init];
        }
    });
    
    return sharedInstance;
}

- (void) location {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.geocoderManager = [[CLGeocoder alloc] init];
}

- (void) geocodingForLocation:(CLLocation *)location {
    [self.geocoderManager reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            [self.delegate placeMarkUpdated];
        } else {
            [self.delegate placeMarkFailed:error];
        }
    } ];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.delegate locationFailed:error];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    
    [self.delegate locationUpdated:oldLocation newLocation:newLocation];
    [self.locationManager stopUpdatingLocation];
}



@end
