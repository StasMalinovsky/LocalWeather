//
//  LocationManager.h
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 25.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol LocationDelegate <NSObject>

- (void)locationUpdated:(CLLocation *)oldLocation newLocation:(CLLocation *)newLocation;
- (void)locationFailed:(NSError *)error;
- (void)placeMarkUpdated;
- (void)placeMarkFailed:(NSError *)error;

@end


#define LOCATION_MANAGER [LocationManager sharedManager]

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoderManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (nonatomic, weak) id<LocationDelegate> delegate;

+ (LocationManager*)sharedManager;
- (void)location;
- (void)geocodingForLocation:(CLLocation *)location;

@end
