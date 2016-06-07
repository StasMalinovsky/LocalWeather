//
//  DescriptionViewController.m
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 30.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "DescriptionViewController.h"

#import <CoreData/CoreData.h>

#import "AppDelegate.h"

@interface DescriptionViewController ()

@property (strong, nonatomic) NSMutableArray *archiveArray;

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Information"];
    self.archiveArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSManagedObject *information = [self.archiveArray objectAtIndex:self.path.row];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    
    [self.temperatureLabel setText:[NSString stringWithFormat:@"Temperature: %@˚C", [information valueForKey:@"temperature"]]];
    [self.descriptionLabel setText:[NSString stringWithFormat:@"Description: %@", [information valueForKey:@"descriptionOfWeather"]]];
    [self.windSpeedLabel setText:[NSString stringWithFormat:@"Wind Speed: %@ m/s", [information valueForKey:@"windSpeed"]]];
    [self.pressureLabel setText:[NSString stringWithFormat:@"Pressure: %@ hpa", [information valueForKey:@"pressure"]]];
    [self.humidityLabel setText:[NSString stringWithFormat:@"Humidity: %@%%", [information valueForKey:@"humidity"]]];
    [self.sunriseLabel setText:[NSString stringWithFormat:@"Sunrise: %@", [information valueForKey:@"sunrise"]]];
    [self.sunsetLabel setText:[NSString stringWithFormat:@"Sunset: %@", [information valueForKey:@"sunset"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
