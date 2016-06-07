//
//  WeatherCell.m
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 25.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "WeatherCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation WeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[self.getWeather layer] setBorderWidth:1.5f];
    [[self.getWeather layer] setCornerRadius:16.f];
    [[self.clearButton layer] setBorderWidth:1.5f];
    [[self.clearButton layer] setCornerRadius:16.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
