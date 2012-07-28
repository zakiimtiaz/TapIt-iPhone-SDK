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
#pragma mark TapItAlertAd Example code

- (IBAction)showAlertAd:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]; // Alert ads only show in test mode for now...
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    AppDelegate *myAppDelegate = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [request updateLocation:myAppDelegate.locationManager.location];
    tapitAlertAd = [[TapItAlertAd alloc] initWithRequest:request];
    tapitAlertAd.delegate = self;
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        [tapitAlertAd showAsActionSheet];
    }
    else {
        [tapitAlertAd showAsAlert];
    }
//    [tapitAlertAd release];
}

- (void)tapitAlertAd:(TapItAlertAd *)alertAd didFailWithError:(NSError *)error {
    NSLog(@"Error showing alert ad: %@", error);
}

- (void)tapitAlertAdWasDeclined:(TapItAlertAd *)alertAd {
    NSLog(@"Alert ad was DECLINED!");
}

- (void)tapitAlertAdDidLoad:(TapItAlertAd *)alertAd {
    NSLog(@"Alert ad loaded!");
}

- (BOOL)tapitAlertAdActionShouldBegin:(TapItAlertAd *)alertAd willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)tapitAlertAdActionDidFinish:(TapItAlertAd *)alertAd {
    NSLog(@"Alert ad Action finished!");
}


#pragma mark -

- (void)dealloc {
    if (tapitAlertAd) {
        [tapitAlertAd release]; tapitAlertAd = nil;
    }
    [super dealloc];
}

@end
