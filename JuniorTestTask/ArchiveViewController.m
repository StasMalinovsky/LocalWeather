//
//  ArchiveViewController.m
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 28.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "ArchiveViewController.h"

#import "LocationManager.h"
#import "ArchiveTableViewCell.h"

#import <CoreData/CoreData.h>

#import "AppDelegate.h"

#import "DescriptionViewController.h"
#import "WeatherItem.h"

static NSString *const kArchiveCellIdentifier = @"ArchiveCellIdentifier";

@interface ArchiveViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *archiveArray;
@end

@implementation ArchiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNib];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Information"];
    self.archiveArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];

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
    return self.archiveArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArchiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArchiveCellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell =  [[ArchiveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kArchiveCellIdentifier];
    }
    
    NSManagedObject *information = [self.archiveArray objectAtIndex:indexPath.row];
    [cell.dateArchiveLabel setText:[NSString stringWithFormat:@"Date of request: %@", [information valueForKey:@"date"]]];
    [cell.coordinatesArchiveLabel setText:[NSString stringWithFormat:@"Coordinates: %@, %@",   [information valueForKey:@"latitude"],
                                                                                        [information valueForKey:@"longitude"]]];
    [cell.cityArchiveLabel setText:[NSString stringWithFormat:@"City: %@", [information valueForKey:@"city"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"show" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [managedObjectContext deleteObject:[self.archiveArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self.archiveArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Utils

- (void) registerNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"ArchiveTableViewCell" bundle:nil] forCellReuseIdentifier:kArchiveCellIdentifier];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"show"]){
        DescriptionViewController *descriptionViewController = segue.destinationViewController;
        descriptionViewController.path = sender;
    }
    
    
}


@end
