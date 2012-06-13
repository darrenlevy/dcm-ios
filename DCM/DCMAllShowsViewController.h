//
//  DCMAllShowsViewController.h
//  DCM
//
//  Created by Benjamin Ragheb on 5/12/12.
//  Copyright (c) 2012 Heroic Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCMTableViewController.h"

@interface DCMAllShowsViewController : DCMTableViewController
{
    NSFetchedResultsController *showsController;
}
- (IBAction)refresh:(id)sender;
@end
