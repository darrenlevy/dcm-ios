//
//  DCMVenueViewController.h
//  DCM
//
//  Created by Benjamin Ragheb on 6/3/12.
//  Copyright (c) 2012 Upright Citizens Brigade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Venue;

@interface DCMVenueViewController : UIViewController
@property (nonatomic,strong) Venue *venue;
- (IBAction)flipView:(id)sender;
@end
