//
//  FirstViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "TapIt.h"
#import "TapItDialogAd.h"

#define ZONE_ID @"3644"


@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize locationManager;

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
    
    tapitAd.delegate = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:  
//                                @"test", @"mode", 
                                nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    [request updateLocation:self.locationManager.location];
    [tapitAd startServingAdsForRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [tapitAd repositionToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark -
#pragma mark TapItBannerAdViewDelegate methods

- (void)tapitBannerAdViewWillLoadAd:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is about to check server for ad...");
}

- (void)tapitBannerAdViewDidLoadAd:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner has been loaded...");
    // Banner view will display automatically if docking is enabled
    // if disabled, you'll want to show bannerView
}

- (void)tapitBannerAdView:(TapItBannerAdView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Banner failed to load, try a different ad network...");
    // Banner view will hide automatically if docking is enabled
    // if disabled, you'll want to hide bannerView
}

- (BOOL)tapitBannerAdViewActionShouldBegin:(TapItBannerAdView *)bannerView willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Banner was tapped, your UI will be covered up.");
    // minimise app footprint for a better ad experience.
    // e.g. pause game, duck music, pause network access, reduce memory footprint, etc...
    return YES;
}

- (void)tapitBannerAdViewActionDidFinish:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is done covering your app, back to normal!");
    // resume normal app functions
}

#pragma mark -
#pragma mark CoreLocation delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [tapitAd updateLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager:didFailWithError:");
}

#pragma mark -
#pragma mark TapItDialogAd Example code

- (IBAction)showDialogAd:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]; // Dialog ads only show in test mode for now...
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    tapitDialogAd = [[TapItDialogAd alloc] initWithRequest:request];
    tapitDialogAd.delegate = self;
    [tapitDialogAd showAsAlert];
//    [tapitDialogAd showAsActionSheet];
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
    if (tapitAd) {
        [tapitAd release]; tapitAd = nil;
    }
    [self.locationManager stopMonitoringSignificantLocationChanges];
    self.locationManager = nil;
    [super dealloc];
}

@end
