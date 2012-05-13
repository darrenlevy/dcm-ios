//
//  DCMAllShowsViewController.m
//  DCM
//
//  Created by Benjamin Ragheb on 5/12/12.
//  Copyright (c) 2012 Heroic Software Inc. All rights reserved.
//

#import "DCMAllShowsViewController.h"
#import "DCMDatabase.h"

@interface DCMAllShowsViewController ()

@end

@implementation DCMAllShowsViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(databaseDidChange:)
     name:DCMDatabaseDidChangeNotification object:nil];
}

- (void)databaseDidChange:(NSNotification *)note
{
    NSError *error = nil;
    if (![showsController performFetch:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    if (note) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DCMDatabase *database = [DCMDatabase sharedDatabase];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Show"];
    [request setSortDescriptors:
     [NSArray arrayWithObject:
      [NSSortDescriptor sortDescriptorWithKey:@"sortName" ascending:YES]]];
    showsController = [[NSFetchedResultsController alloc]
                       initWithFetchRequest:request
                       managedObjectContext:database.managedObjectContext
                       sectionNameKeyPath:@"sortSection"
                       cacheName:@"DCMAllShowsViewController"];
    [self databaseDidChange:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    showsController = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[showsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = [[showsController sections] objectAtIndex:section];
    return [info numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = [[showsController sections] objectAtIndex:section];
    return [info name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowCell"];
    
    // Configure the cell...
    Show *show = [showsController objectAtIndexPath:indexPath];
    cell.textLabel.text = show.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
