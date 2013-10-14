//
//  TapItInterstitialAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

/**
 Responsible for loading up the appropriate type of interstitial controller...
 */

#import "TapItInterstitialAd.h"
#import "TapIt.h"
#import "TapItAdManager.h"
#import "TapItBannerAdView.h"
#import "TapItInterstitialAdViewController.h"
#import "TapItBrowserController.h"

@interface TapItInterstitialAdViewController ()
- (void)closeTapped:(id)sender;
@end

@interface TapItInterstitialAd() <TapItAdManagerDelegate, TapItMraidDelegate> 

@property (retain, nonatomic) TapItRequest *adRequest;
@property (retain, nonatomic) TapItAdView *adView;
@property (retain, nonatomic) TapItAdManager *adManager;
@property (retain, nonatomic) TapItBannerAdView *bannerView;
@property (retain, nonatomic) UIView *presentingView;
@property (retain, nonatomic) TapItInterstitialAdViewController *adController;
@property (retain, nonatomic) TapItBrowserController *browserController;
@property (assign) BOOL useCustomClose;

@end

@implementation TapItInterstitialAd {
    BOOL isLoaded;
    BOOL prevStatusBarHiddenState;
    BOOL statusBarVisibilityChanged;
}

@synthesize delegate, adRequest, adView, adManager, allowedAdTypes, bannerView, presentingView, animated, autoReposition, showLoadingOverlay, adController, browserController, presentingController, useCustomClose;

- (id)init {
    self = [super init];
    if (self) {
        self.adManager = [[[TapItAdManager alloc] init] autorelease];
        self.adManager.delegate = self;
        self.allowedAdTypes = TapItFullscreenAdType|TapItOfferWallType|TapItVideoAdType;
        self.animated = YES;
        isLoaded = NO;
        self.autoReposition = YES;
        self.showLoadingOverlay = YES;
        prevStatusBarHiddenState = NO;
        statusBarVisibilityChanged = NO;
        self.useCustomClose = NO;
    }
    return self;
}

- (BOOL)loaded {
    return isLoaded;
}

- (BOOL)loadInterstitialForRequest:(TapItRequest *)request {
    self.adRequest = request;
    [self.adRequest setCustomParameter:TAPIT_AD_TYPE_INTERSTITIAL forKey:@"adtype"];
    NSString *orientation;
    UIInterfaceOrientation uiOrt = [[UIApplication sharedApplication] statusBarOrientation];
    if (uiOrt == UIInterfaceOrientationPortrait || uiOrt == UIInterfaceOrientationPortraitUpsideDown) {
        orientation = @"p";
    } else {
        orientation = @"l";
    }
    [self.adRequest setCustomParameter:orientation forKey:@"o"];
    [self.adManager fireAdRequest:self.adRequest];
    return YES;
}

- (void)presentFromViewController:(UIViewController *)controller {
//    adController = [[TapItLightboxAdViewController alloc] init];
    adController = [[TapItInterstitialAdViewController alloc] init];
    self.adController.adView = self.adView;
    self.adController.animated = self.animated;
    self.adController.autoReposition = self.autoReposition;
    self.adController.tapitDelegate = self;
    
    self.presentingController = controller;

    [controller presentModalViewController:self.adController animated:YES];
    if (self.adView.isMRAID) {
        CGRect frame = TapItApplicationFrame([UIDevice currentDevice].orientation);
        
        NSString *reqSysVer = @"7.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        int extraRoom = 0;
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
            extraRoom = 20;
        }
        self.adView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height+extraRoom);
        self.adView.center = controller.view.center;
        self.adView.isVisible = YES;
        [self.adView fireMraidEvent:TAPIT_MRAID_EVENT_VIEWABLECHANGE withParams:@"[true]"];
        [self.adView syncMraidState];
        if (!self.useCustomClose) {
            [self.adController showCloseButton];
        }
    }
    else {
        self.adView.center = controller.view.center;
        [self.adController showCloseButton];
    }
}

#pragma mark -
#pragma mark TapItAdManagerDelegate methods

- (void)willLoadAdWithRequest:(TapItRequest *)request {
    if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdWillLoad:)]) {
        [self.delegate tapitInterstitialAdWillLoad:self];
    }
}

- (void)didLoadAdView:(TapItAdView *)theAdView {
    self.adView = theAdView;
    isLoaded = YES;
    self.adView.mraidDelegate = self;

    if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdDidLoad:)]) {
        [self.delegate tapitInterstitialAdDidLoad:self];
    }
}

- (void)adView:(TapItAdView *)adView didFailToReceiveAdWithError:(NSError*)error {
    [self tapitInterstitialAd:self didFailWithError:error];
}

- (BOOL)adActionShouldBegin:(NSURL *)actionUrl willLeaveApplication:(BOOL)willLeave {
    BOOL shouldLoad = YES;
    if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionShouldBegin:willLeaveApplication:)]) {
        shouldLoad = [self.delegate tapitInterstitialAdActionShouldBegin:self willLeaveApplication:willLeave];
    }
    
    if (shouldLoad) {
        [self openURLInFullscreenBrowser:actionUrl];
        return NO; // pass off control to the full screen browser
    }
    else {
        // app decided not to allow the click to proceed... Not sure why you'd want to do this...
        return NO;
    }
}

- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd {
    if (self.adView) {
        self.adView = nil;
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdDidUnload:)]) {
            [self.delegate tapitInterstitialAdDidUnload:self];
        }
    }
}

- (void)adViewActionDidFinish:(TapItAdView *)adView {
    // This method should always be overridden by child class
}

- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    isLoaded = NO;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAd:didFailWithError:)]) {
            [self.delegate tapitInterstitialAd:self didFailWithError:error];
        }
    }
}

- (BOOL)tapitInterstitialAdActionShouldBegin:(TapItInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionShouldBegin:willLeaveApplication:)]) {
            return [self.delegate tapitInterstitialAdActionShouldBegin:self willLeaveApplication:willLeave];
        }
    }
    return YES;
}

- (void)tapitInterstitialAdActionWillFinish:(TapItInterstitialAd *)interstitialAd {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionWillFinish:)]) {
            [self.delegate tapitInterstitialAdActionWillFinish:self];
        }
    }
}

- (void)tapitInterstitialAdActionDidFinish:(TapItInterstitialAd *)interstitialAd {
    if (self.adView.isMRAID) {
        self.adView.mraidState = TAPIT_MRAID_STATE_HIDDEN;
        [self.adView syncMraidState];
        [self.adView fireMraidEvent:TAPIT_MRAID_EVENT_STATECHANGE withParams:self.adView.mraidState];
    }

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionDidFinish:)]) {
            [self.delegate tapitInterstitialAdActionDidFinish:self];
        }
    }
}


#pragma mark -
#pragma mark MRAID methods

- (NSDictionary *)mraidQueryState {
    NSDictionary *state = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"interstitial", @"placementType",
                           nil];
    return state;
}


- (UIViewController *)mraidPresentingViewController {
    return self.presentingController;
}

- (void)mraidClose {
    [self.adController closeTapped:nil];
}

- (void)mraidAllowOrientationChange:(BOOL)isOrientationChangeAllowed andForceOrientation:(TapItMraidForcedOrientation)forcedOrientation {
    
}

- (void)mraidResize:(CGRect)frame withUrl:(NSURL *)url isModal:(BOOL)isModal useCustomClose:(BOOL)useCustomClose {
    // unused for interstitials
}

- (void)mraidOpen:(NSString *)urlStr {
    BOOL shouldLoad = YES;
    if ([self.delegate respondsToSelector:@selector(tapitInterstitialAdActionShouldBegin:willLeaveApplication:)]) {
        // app has something to say about allowing tap to proceed...
        shouldLoad = [self.delegate tapitInterstitialAdActionShouldBegin:self willLeaveApplication:NO];
    }
    
    if (shouldLoad) {
        [self openURLInFullscreenBrowser:[NSURL URLWithString:urlStr]];
    }
    else {
        if (self.adView.isMRAID) {
            [self.adView fireMraidEvent:@"error" withParams:@"[\"Application declined to open browser\", \"open\"]"];
        }
    }
}

- (void)mraidUseCustomCloseButton:(BOOL)useCustomCloseButton {
    self.useCustomClose = useCustomCloseButton;
    if (useCustomCloseButton) {
        [self.adController hideCloseButton];
    }
    else {
        [self.adController showCloseButton];
    }
}


#pragma mark -
#pragma mark TapItBrowserController methods

//- (void)openURLInFullscreenBrowser:(NSURL *)url {
//    BOOL shouldLoad = [self.tapitDelegate tapitInterstitialAdActionShouldBegin:nil willLeaveApplication:NO];
//    if (!shouldLoad) {
//        id<TapItInterstitialAdDelegate> tDel = [self.tapitDelegate retain];
//        [self dismissViewControllerAnimated:self.animated completion:^{
//            [tDel tapitInterstitialAdDidUnload:nil];
//            [tDel release];
//        }];
//        return;
//    }
//    
//    // Present ad browser.
//    self.browserController = [[[TapItBrowserController alloc] init] autorelease];
////    [self presentModalViewController:browserController animated:self.animated];
////    [self presentModalViewController:browserController animated:NO];
////    [browserController release];
//}

- (void)openURLInFullscreenBrowser:(NSURL *)url {
//    TILog(@"Banner->openURLInFullscreenBrowser: %@", url);
    self.browserController = [[[TapItBrowserController alloc] init] autorelease];
    self.browserController.presentingController = self.presentingController;
    self.browserController.delegate = self;
    self.browserController.showLoadingOverlay = self.showLoadingOverlay;
    [self.browserController loadUrl:url];
    [self.adController showLoading];

    self.adController.closeButton.hidden = YES;
}

- (BOOL)browserControllerShouldLoad:(TapItBrowserController *)theBrowserController willLeaveApp:(BOOL)willLeaveApp {
//    TILog(@"************* browserControllerShouldLoad:willLeaveApp:%d, (%@)", willLeaveApp, theBrowserController.url);
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapitInterstitialAdActionShouldBegin:willLeaveApplication:)]) {
        [self.delegate tapitInterstitialAdActionShouldBegin:self willLeaveApplication:willLeaveApp];
    }
    return YES;
}

- (void)browserControllerLoaded:(TapItBrowserController *)theBrowserController willLeaveApp:(BOOL)willLeaveApp {
//    TILog(@"************* browserControllerLoaded:willLeaveApp:");
    [self.adController dismissModalViewControllerAnimated:NO];
    [self.browserController showFullscreenBrowserAnimated:NO];
    self.adController = nil;
}

-(void)browserControllerWillDismiss:(TapItBrowserController *)browserController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapitInterstitialAdActionWillFinish:)]) {
        [self.delegate tapitInterstitialAdActionWillFinish:self];
    }
}

- (void)browserControllerDismissed:(TapItBrowserController *)theBrowserController {
//    TILog(@"************* browserControllerDismissed:");
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapitInterstitialAdActionDidFinish:)]) {
        [self.delegate tapitInterstitialAdActionDidFinish:self];
    }
    [self tapitInterstitialAdDidUnload:self];
}

- (void)browserControllerFailedToLoad:(TapItBrowserController *)theBrowserController withError:(NSError *)error {
//    TILog(@"************* browserControllerFailedToLoad:withError: %@", error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapitInterstitialAdActionDidFinish:)]) {
        [self.delegate tapitInterstitialAdActionDidFinish:self];
    }
    [self.adController hideLoading];
}

#pragma mark -


- (void)timerElapsed {
    // This method should be overridden by child class
}

- (UIViewController *)getDelegate {
    return (UIViewController *)self.delegate;
}

- (void)dealloc {
    self.adRequest = nil;
    self.adView = nil;
    self.adManager = nil;
    self.bannerView = nil;
    self.presentingView = nil;
    
    [super dealloc];
}

@end
