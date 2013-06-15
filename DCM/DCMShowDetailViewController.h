//
//  DCMShowDetailViewController.h
//  DCM
//
//  Created by Benjamin Ragheb on 5/13/12.
//  Copyright (c) 2012 Upright Citizens Brigade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCMTableViewController.h"

@class Show;

@interface DCMShowDetailViewController : DCMTableViewController
{
    NSArray *performers;
    NSArray *performances;
}
@property (strong, nonatomic) Show *show;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoBlurbLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketWarningLabel;
- (IBAction)toggleFavorite:(id)sender;
@end
