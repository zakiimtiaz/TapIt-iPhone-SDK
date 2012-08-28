//
//  TapItMediationAdMob.m
//
//  Created by Nick Penteado on 8/24/12.
//  Copyright (c) 2012 Nick Penteado. All rights reserved.
//

#import "TapItMediationAdMob.h"
#import "GADAdSize.h"
#import "Tapit.h"

@implementation TapItMediationAdMob

@synthesize tapitAd, tapitInterstitial;

+ (NSString *)adapterVersion {
    return TAPIT_VERSION;
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

- (id)initWithGADMAdNetworkConnector:(id<GADMAdNetworkConnector>)c {
    self = [super init];
    if (self != nil) {
        connector = c;
        bannerClicks = 0;
    }
    return self;
}

- (void)getInterstitial {
    tapitInterstitial = [[TapItInterstitialAd alloc] init];
    tapitInterstitial.delegate = self; // notify me of the interstitial's state changes
    NSString *zoneId = [connector publisherId];
    TapItRequest *request = [TapItRequest requestWithAdZone:zoneId];
    [tapitInterstitial loadInterstitialForRequest:request];
}

- (void)getBannerWithSize:(GADAdSize)adSize {
    if (!GADAdSizeEqualToSize(adSize, kGADAdSizeBanner) &&
        !GADAdSizeEqualToSize(adSize, kGADAdSizeFullBanner) &&
        !GADAdSizeEqualToSize(adSize, kGADAdSizeLeaderboard) &&
        !GADAdSizeEqualToSize(adSize, kGADAdSizeMediumRectangle) &&
        !GADAdSizeEqualToSize(adSize, kGADAdSizeSkyscraper)) {
        NSString *errorDesc = [NSString stringWithFormat:
                               @"Invalid ad type %@, not going to get ad.",
                               NSStringFromGADAdSize(adSize)];
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   errorDesc, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"ad_mediation"
                                             code:1
                                         userInfo:errorInfo];
        [self tapitBannerAdView:nil didFailToReceiveAdWithError:error];
        return;
    }
    
    CGSize cgAdSize = CGSizeFromGADAdSize(adSize);
    CGRect adFrame = CGRectMake(0, 0, cgAdSize.width, cgAdSize.height);
    tapitAd = [[TapItBannerAdView alloc] initWithFrame:adFrame];
    NSString *zoneId = [connector publisherId];
    NSLog(@"zoneid: %@", zoneId);
    TapItRequest *adRequest = [TapItRequest requestWithAdZone:zoneId];
    [adRequest setCustomParameter:@"999999" forKey:TAPIT_PARAM_KEY_BANNER_ROTATE_INTERVAL]; // don't rotate banner
    tapitAd.delegate = self;
    [tapitAd startServingAdsForRequest:adRequest];
    NSLog(@"getBannerWithSize done!");
}

- (void)stopBeingDelegate {
    if(tapitInterstitial) {
        tapitInterstitial.delegate = nil;
    }
    
    if(tapitAd) {
        tapitAd.delegate = nil;
    }
}

- (BOOL)isBannerAnimationOK:(GADMBannerAnimationType)animType {
    return YES;
}

- (void)presentInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [tapitInterstitial presentFromViewController:rootViewController];
    [connector adapterWillPresentInterstitial:self];
}

- (void)dealloc {
    [self stopBeingDelegate];
    [tapitAd release], tapitAd = nil;
    [tapitInterstitial release], tapitInterstitial = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark TapItBannerAdViewDelegate methods

- (void)tapitBannerAdViewWillLoadAd:(TapItBannerAdView *)bannerView {
//    NSLog(@"Banner is about to check server for ad...");
    // no google equivilent... NOOP
}

- (void)tapitBannerAdViewDidLoadAd:(TapItBannerAdView *)bannerView {
//    NSLog(@"Banner has been loaded...");
    // Banner view will display automatically if docking is enabled
    // if disabled, you'll want to show bannerView
    [connector adapter:self didReceiveAdView:bannerView];
}

- (void)tapitBannerAdView:(TapItBannerAdView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
//    NSLog(@"Banner failed to load, try a different ad network...");
    // Banner view will hide automatically if docking is enabled
    // if disabled, you'll want to hide bannerView
    [connector adapter:self didFailAd:error];
}

- (BOOL)tapitBannerAdViewActionShouldBegin:(TapItBannerAdView *)bannerView willLeaveApplication:(BOOL)willLeave {
//    NSLog(@"Banner was tapped, your UI will be covered up.");
    // minimise app footprint for a better ad experience.
    // e.g. pause game, duck music, pause network access, reduce memory footprint, etc...
    if (bannerClicks++ == 0) {
        [connector adapter:self clickDidOccurInBanner:bannerView];
        [connector adapterWillPresentFullScreenModal:self];
    }
    return YES;
}

- (void)tapitBannerAdViewActionDidFinish:(TapItBannerAdView *)bannerView {
//    NSLog(@"Banner is done covering your app, back to normal!");
    // resume normal app functions
    [connector adapterDidDismissFullScreenModal:self];
}


#pragma mark -
#pragma mark TapItInterstitialAdDelegate methods

- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
//    NSLog(@"Error: %@", error.localizedDescription);
    [connector adapter:self didFailInterstitial:error];
}

- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd {
//    NSLog(@"Ad did unload");
}

- (void)tapitInterstitialAdWillLoad:(TapItInterstitialAd *)interstitialAd {
//    NSLog(@"Ad will load");
}

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
//    NSLog(@"Ad did load");
    [connector adapter:self didReceiveInterstitial:interstitialAd];
}

- (BOOL)tapitInterstitialAdActionShouldBegin:(TapItInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave {
//    NSLog(@"Ad action should begin");
    [connector adapterWillPresentInterstitial:self];
    return YES;
}

- (void)tapitInterstitialAdActionDidFinish:(TapItInterstitialAd *)interstitialAd {
//    NSLog(@"Ad action did finish");
    [connector adapterDidDismissInterstitial:self];
}

@end
