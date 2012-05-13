//
//  DCMVenueDetailViewController.h
//  DCM
//
//  Created by Benjamin Ragheb on 5/13/12.
//  Copyright (c) 2012 Heroic Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Venue;

@interface DCMVenueDetailViewController : UITableViewController
{
    NSFetchedResultsController *performancesController;
}
@property (strong, nonatomic) Venue *venue;
@end
