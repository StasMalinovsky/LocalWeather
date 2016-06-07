//
//  GraphViewController.m
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 30.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "GraphViewController.h"
#import <ANDLineChartView/ANDLineChartView.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface GraphViewController () <ANDLineChartViewDataSource, ANDLineChartViewDelegate>

@property (strong, nonatomic) NSMutableArray *graphArray;
@property (strong, nonatomic) NSManagedObject *graphObject;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Information"];
    self.graphArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.graphObject = (NSManagedObject *)self.graphArray;
    
    self.chartView = [[ANDLineChartView alloc] initWithFrame:CGRectMake(0, 50,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height - 100)];
    [self.chartView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.chartView setDataSource:self];
    [self.chartView setDelegate:self];
    [self.chartView setAnimationDuration:0.4];
    
    self.chartView.chartBackgroundColor = [UIColor whiteColor];
    self.chartView.lineColor = [UIColor blackColor];
    self.chartView.elementFillColor = [UIColor blueColor];
    
    [self.view addSubview:self.chartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSUInteger)numberOfElementsInChartView:(ANDLineChartView *)chartView {
    return self.graphArray.count;
}

- (NSUInteger)numberOfGridIntervalsInChartView:(ANDLineChartView *)chartView {
    return 13;
}

- (CGFloat)chartView:(ANDLineChartView *)chartView valueForElementAtRow:(NSUInteger)row {
    NSArray *temperature = [self.graphObject valueForKey:@"temperature"];
    
    NSString* str = [temperature objectAtIndex:row];
    
    return [str floatValue];
}

- (NSString*)chartView:(ANDLineChartView *)chartView descriptionForGridIntervalValue:(CGFloat)interval {
  return [NSString stringWithFormat:@"%.1f",interval];
}

- (CGFloat)maxValueForGridIntervalInChartView:(ANDLineChartView *)chartView {
    return 35.0;
}
- (CGFloat)minValueForGridIntervalInChartView:(ANDLineChartView *)chartView {
    return -25.0;
}

- (CGFloat)chartView:(ANDLineChartView *)graphView spacingForElementAtRow:(NSUInteger)row{
    return (row == 0) ? 120.0 : 30.0;
}

@end
