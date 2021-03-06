//
//  DCMAppDelegate.m
//  DCM
//
//  Created by Benjamin Ragheb on 5/12/12.
//  Copyright (c) 2012 Upright Citizens Brigade LLC. All rights reserved.
//

#import "DCMAppDelegate.h"
#import "DCMDatabase.h"
#import "DCMImportOperation.h"
#import "MBProgressHUD.h"
#import "WallClock.h"

@implementation DCMAppDelegate

+ (DCMAppDelegate *)sharedDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"America/New_York"];
    if (tz) [NSTimeZone setDefaultTimeZone:tz];
#if TESTFLIGHT_ENABLED
#if BETA_RELEASE
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    [TestFlight takeOff:@"17d0e716-24af-462b-a2bd-bad946a25a6f"];
#endif

    UIColor *tintColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UINavigationBar appearance] setTintColor:tintColor];
        [[UISearchBar appearance] setTintColor:tintColor];
    } else {
        self.window.tintColor = tintColor;
    }

    [[NSNotificationCenter defaultCenter]
     addObserverForName:DCMDatabaseProgressNotification object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         NSError *error = [[note userInfo] objectForKey:DCMDatabaseErrorKey];
         if (error) {
             NSLog(@"Error: %@", [error localizedDescription]);
             [[MBProgressHUD HUDForView:self.window] hide:YES];
             UIAlertView *alert = [[UIAlertView alloc] init];
             alert.title = @"Update Failed";
             alert.message = [error localizedDescription];
             [alert addButtonWithTitle:@"Dismiss"];
             [alert show];
         } else {
             NSDictionary *info = [note userInfo];
             float progress = [[info objectForKey:DCMDatabaseProgressKey] floatValue];
             NSString *activity = [info objectForKey:DCMDatabaseActivityKey];
             MBProgressHUD *hud = [MBProgressHUD HUDForView:self.window];
             if (hud == nil) {
                 hud = [[MBProgressHUD alloc] initWithWindow:self.window];
                 hud.removeFromSuperViewOnHide = YES;
                 [self.window addSubview:hud];
                 [hud show:YES];
             }
             if (progress == DCMDatabaseProgressIndeterminate) {
                 hud.mode = MBProgressHUDModeIndeterminate;
             } else if (progress < DCMDatabaseProgressComplete) {
                 hud.mode = MBProgressHUDModeDeterminate;
                 hud.progress = progress;
             }
             hud.labelText = activity;
             if (progress == DCMDatabaseProgressComplete) {
                 hud.mode = MBProgressHUDModeText;
                 [hud hide:YES afterDelay:1];
             }
         }
     }];
    // Supress error messages unless the database is empty.
    DCMDatabase *db = [DCMDatabase sharedDatabase];
    [db checkForUpdateQuietly:![db isEmpty]];
    [[WallClock sharedClock] start];
    return YES;
}

@end
