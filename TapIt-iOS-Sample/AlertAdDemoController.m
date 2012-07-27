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
#import "TapItDialogAd.h"

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
    tapitDialogAd = [[TapItDialogAd alloc] initWithRequest:request];
    tapitDialogAd.delegate = self;
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        [tapitDialogAd showAsActionSheet];
    }
    else {
        [tapitDialogAd showAsAlert];
    }
}

- (void)tapitDialogAd:(TapItDialogAd *)dialogAd didFailWithError:(NSError *)error {
    NSLog(@"Error showing dialog ad: %@", error);
}

- (void)tapitDialogWasDeclined:(TapItDialogAd *)dialogAd {
    NSLog(@"Dialog ad was DECLINED!");
}

- (void)tapitDialogAdDidLoad:(TapItDialogAd *)dialogAd {
    NSLog(@"Dialog ad loaded!");
}

- (BOOL)tapitDialogAdActionShouldBegin:(TapItDialogAd *)dialogAd willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)tapitDialogAdActionDidFinish:(TapItDialogAd *)dialogAd {
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
