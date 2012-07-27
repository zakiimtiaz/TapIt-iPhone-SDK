//
//  AlertAdDemoController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "AppDelegate.h"
#import "AlertAdDemoController.h"
#import "TapIt.h"
#import "TapItAlertAd.h"

#define ZONE_ID @"3644"


@interface AlertAdDemoController ()

@end

@implementation AlertAdDemoController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark TapItDialogAd Example code

- (IBAction)showDialogAd:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]; // Dialog ads only show in test mode for now...
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    AppDelegate *myAppDelegate = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [request updateLocation:myAppDelegate.locationManager.location];
    tapitDialogAd = [[TapItAlertAd alloc] initWithRequest:request];
    tapitDialogAd.delegate = self;
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        [tapitDialogAd showAsActionSheet];
    }
    else {
        [tapitDialogAd showAsAlert];
    }
//    [tapitDialogAd release];
}

- (void)tapitAlertAd:(TapItAlertAd *)dialogAd didFailWithError:(NSError *)error {
    NSLog(@"Error showing dialog ad: %@", error);
}

- (void)tapitAlertAdWasDeclined:(TapItAlertAd *)dialogAd {
    NSLog(@"Dialog ad was DECLINED!");
}

- (void)tapitAlertAdDidLoad:(TapItAlertAd *)dialogAd {
    NSLog(@"Dialog ad loaded!");
}

- (BOOL)tapitAlertAdActionShouldBegin:(TapItAlertAd *)dialogAd willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)tapitAlertAdActionDidFinish:(TapItAlertAd *)dialogAd {
    NSLog(@"Dialog ad Action finished!");
}


#pragma mark -

- (void)dealloc {
    if (tapitDialogAd) {
        [tapitDialogAd release]; tapitDialogAd = nil;
    }
    [super dealloc];
}

@end
