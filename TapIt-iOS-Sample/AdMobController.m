//
//  AdMobController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 8/27/12.
//
//

#import "AdMobController.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"

@implementation AdMobController

@synthesize activityIndicator, loadButton, showButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAdMob];
}

- (void)setupAdMob
{
    // Create a view of the standard size at the bottom of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"85a1ca0818ae4913";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    bannerView_.delegate = self;
    bannerView_.center = self.view.center;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
}

- (IBAction)loadInterstitial:(id)sender
{
    interstitial_ = [[GADInterstitial alloc] init];
//    interstitial_.adUnitID = @"e04e330d387b46d3";
    interstitial_.adUnitID = @"bcbe042d16ca4d37";
    interstitial_.delegate = self;
    [interstitial_ loadRequest:[GADRequest request]];
    [self updateUIWithState:StateLoading];
}

- (IBAction)showInterstital:(id)sender
{
    [interstitial_ presentFromRootViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)updateUIWithState:(ButtonState)state {
    [loadButton setEnabled:(state != StateLoading)];
    [showButton setHidden:(state != StateReady)];
    [activityIndicator setHidden:(state != StateLoading)];
}

- (void)dealloc {
    [interstitial_ release];
    [bannerView_ release];
    [super dealloc];
}

#pragma mark -
#pragma mark AdMob Banner Callbacks

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd: %@", adView);
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", error);
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen: %@", adView);
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen: %@", adView);
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen: %@", adView);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication: %@", adView);
}


#pragma mark -
#pragma mark AdMob Interstitial Callbacks

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd: %@", ad);
    [self updateUIWithState:StateReady];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", error);
    [self updateUIWithState:StateError];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen: %@", ad);
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen: %@", ad);
    [self updateUIWithState:StateNone];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen: %@", ad);
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication: %@", ad);
}

@end
