//
//  WeatherItem.h
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 27.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherItem : NSObject

@property (strong, nonatomic) NSString *pressure;
@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSString *windSpeed;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSDate *sunrise;
@property (strong, nonatomic) NSDate *sunset;
@property (strong, nonatomic) NSString *descriptionOfWeather;

@property (strong, nonatomic) NSString *weatherObjectID;
@end
