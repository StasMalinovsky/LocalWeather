//
//  MainScreenViewController.m
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 25.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "MainScreenViewController.h"

#import "CoordinatesCell.h"
#import "AddressCell.h"
#import "WeatherCell.h"

#import "LocationManager.h"
#import "WeatherItem.h"
#import <OWMWeatherAPI.h>

#import <CoreData/CoreData.h>

#import "AppDelegate.h"

static NSString *const kCoordinatesCellIdentifier = @"CoordinatesCellIdentifier";
static NSString *const kAddressCellIdentifier = @"AddressCellIdentifier";
static NSString *const kWeatherCellIdentifier = @"WeatherCellIdentifier";

@interface MainScreenViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WeatherItem *weatherItem;
@property (strong, nonatomic) NSString *dateOfGettingInformation;
- (IBAction)actionSwitch:(id)sender;

@end

@implementation MainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LOCATION_MANAGER.delegate = self;
    [LOCATION_MANAGER location];
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    [self registerNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {

        CoordinatesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoordinatesCellIdentifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell =  [[CoordinatesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCoordinatesCellIdentifier];
        }
        
        cell.coordinatesLabel.text = [NSString stringWithFormat:@"Your coordinates: %.2f, %.2f",
                                      LOCATION_MANAGER.currentLocation.coordinate.latitude,
                                      LOCATION_MANAGER.currentLocation.coordinate.longitude];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellIdentifier forIndexPath:indexPath];
        
        if(cell == nil) {
            cell =  [[AddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kAddressCellIdentifier];
        }
        if (LOCATION_MANAGER.placemark != nil) {
        cell.countryLabel.text = [NSString stringWithFormat:@"Your country: %@", LOCATION_MANAGER.placemark.country];
        cell.countryCodeLabel.text = [NSString stringWithFormat:@"Your country code: %@", LOCATION_MANAGER.placemark.ISOcountryCode];
        cell.localityLabel.text = [NSString stringWithFormat:@"Your city: %@", LOCATION_MANAGER.placemark.locality];
            
        }
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeatherCellIdentifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell =  [[WeatherCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kWeatherCellIdentifier];
        }
        
        [cell.getWeather addTarget:self action:@selector(getWeatherClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.clearButton addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];

        
        if (self.weatherItem != nil) {
            cell.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %@ hpa", self.weatherItem.pressure];
            cell.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %.2f%%", [self.weatherItem.humidity floatValue]];
            cell.windSpeedLabel.text = [NSString stringWithFormat:@"Wind Speed: %.2f m/s", [self.weatherItem.windSpeed floatValue]];
            cell.temperatureLabel.text = [NSString stringWithFormat:@"Temperature: %.2f˚C", [self.weatherItem.temperature floatValue]];
            cell.sunriseLabel.text = [NSString stringWithFormat:@"Sunrise: %@", [dateFormatter stringFromDate:self.weatherItem.sunrise]];
            cell.sunsetLabel.text = [NSString stringWithFormat:@"Sunset: %@", [dateFormatter stringFromDate:self.weatherItem.sunset]];
            cell.descriptionLabel.text = [NSString stringWithFormat:@"Description: %@", self.weatherItem.descriptionOfWeather];
            
        } else {
            cell.pressureLabel.text = [NSString stringWithFormat:@"Pressure"];
            cell.humidityLabel.text = [NSString stringWithFormat:@"Humidity"];
            cell.windSpeedLabel.text = [NSString stringWithFormat:@"Wind Speed"];
            cell.temperatureLabel.text = [NSString stringWithFormat:@"Temperature"];
            cell.sunriseLabel.text = [NSString stringWithFormat:@"Sunrise"];
            cell.sunsetLabel.text = [NSString stringWithFormat:@"Sunset"];
            cell.descriptionLabel.text = [NSString stringWithFormat:@"Description"];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
            return 40.0;
            break;
        case 1:
            return 100.0;
            break;
        case 2:
            return 300.0;
            break;
        default:
            return 50.0;
            break;
    }
}

#pragma mark - Utils

- (void) registerNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"CoordinatesCell" bundle:nil] forCellReuseIdentifier:kCoordinatesCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:kAddressCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeatherCell" bundle:nil] forCellReuseIdentifier:kWeatherCellIdentifier];
}

- (void) getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    self.dateOfGettingInformation = [dateFormatter stringFromDate:date];
    
}

#pragma mark - Location

- (void)locationUpdated:(CLLocation *)oldLocation newLocation:(CLLocation *)newLocation {
    
    [LOCATION_MANAGER geocodingForLocation:newLocation];
    
    [self.tableView reloadData];
}

- (void)locationFailed:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)placeMarkUpdated {
    [self.tableView reloadData];
}

- (void)placeMarkFailed:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

#pragma mark - OpenWeatherMap

- (void) getDataFromOpenWeatherMapWithCoordinate:(CLLocationCoordinate2D) coordinate
                                    withCallback:( void (^)( WeatherItem *result ) )callback {
    OWMWeatherAPI *weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"eba47effea88b18d5b67eae531209447"];
    [weatherAPI setTemperatureFormat:kOWMTempCelcius];
    
    [weatherAPI currentWeatherByCoordinate:LOCATION_MANAGER.currentLocation.coordinate
                              withCallback:^(NSError *error, NSDictionary *result) {
                                  
                                  self.weatherItem = [[WeatherItem alloc] init];
                                  
                                  NSNumber *temperature = result[@"main"][@"temp"];
                                  NSNumber *pressure = result[@"main"][@"pressure"];
                                  
                                  NSArray *array = [result objectForKey:@"weather"];
                                  NSDictionary *dictionary = [array objectAtIndex:0];
                                  NSString *description = [dictionary objectForKey:@"description"];
                                  NSNumber *humidity = result[@"main"][@"humidity"];
                                  NSNumber *windSpeed = result[@"wind"][@"speed"];
                                  NSDate *sunrise = result[@"sys"][@"sunrise"];
                                  NSDate *sunset = result[@"sys"][@"sunset"];
                                  
                                  self.weatherItem.pressure = pressure.stringValue;
                                  self.weatherItem.humidity = humidity.stringValue;
                                  self.weatherItem.windSpeed = windSpeed.stringValue;
                                  self.weatherItem.temperature = temperature.stringValue;
                                  self.weatherItem.sunrise = sunrise;
                                  self.weatherItem.sunset = sunset;
                                  self.weatherItem.descriptionOfWeather = description;
                                  

                                  callback(self.weatherItem);
                                  
    }];
}

#pragma mark Actions

- (void) getWeatherClicked:(UIButton *)sender {

    
        
    
    
    [self getDataFromOpenWeatherMapWithCoordinate:LOCATION_MANAGER.currentLocation.coordinate
                                     withCallback:^(WeatherItem *result) {
                                         
    if (self.weatherItem.temperature != nil) {
        
    
        [self getCurrentDate];
    
        NSString *convertedLongitude = [NSString stringWithFormat:@"%.2f", LOCATION_MANAGER.currentLocation.coordinate.longitude];
        NSString *convertedLatitude = [NSString stringWithFormat:@"%.2f", LOCATION_MANAGER.currentLocation.coordinate.latitude];
    
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSString *convertedSunrise = [dateFormatter stringFromDate:self.weatherItem.sunrise];
        NSString *convertedSunset = [dateFormatter stringFromDate:self.weatherItem.sunset];
                                         

                                         
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSManagedObject *information = [NSEntityDescription insertNewObjectForEntityForName:@"Information"
                                                                     inManagedObjectContext:context];
    
    
                                         
        [information setValue:self.dateOfGettingInformation forKey:@"date"];
        [information setValue:convertedLatitude forKey:@"latitude"];
        [information setValue:convertedLongitude forKey:@"longitude"];
        [information setValue:LOCATION_MANAGER.placemark.locality forKey:@"city"];
        [information setValue:LOCATION_MANAGER.placemark.country forKey:@"country"];
        [information setValue:LOCATION_MANAGER.placemark.ISOcountryCode forKey:@"countryCode"];
    
        [information setValue:self.weatherItem.pressure forKey:@"pressure"];
        [information setValue:self.weatherItem.humidity forKey:@"humidity"];
        [information setValue:self.weatherItem.windSpeed forKey:@"windSpeed"];
        [information setValue:self.weatherItem.temperature forKey:@"temperature"];
        [information setValue:convertedSunrise forKey:@"sunrise"];
        [information setValue:convertedSunset forKey:@"sunset"];
        [information setValue:self.weatherItem.descriptionOfWeather forKey:@"descriptionOfWeather"];
    
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@", error.localizedDescription);
        }
        if ([self.weatherItem.temperature floatValue] > 25) {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Danger!" message:@"Weather more than 25, plese, drink some water!" delegate:nil cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
            [errorAlert show];
        }
        [self.tableView reloadData];
    }
                                     }];
}

- (void) clearClicked:(UIButton *)sender {
    self.weatherItem = nil;
    [self.tableView reloadData];
}



- (IBAction)actionSwitch:(id)sender {
}

@end
