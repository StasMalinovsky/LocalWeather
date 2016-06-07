//
//  DescriptionViewController.h
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 30.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;

@property (strong, nonatomic) NSIndexPath *path;
@end
