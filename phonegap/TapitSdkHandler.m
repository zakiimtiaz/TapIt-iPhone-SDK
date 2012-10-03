//
//  TapitSdkHandler.m
//  TapitPG
//
//  Created 
//  Copyright (c) 2012 . All rights reserved.
//

#import "TapitSdkHandler.h"
#import "TapIt.h"
#import "TapItAppTracker.h"

#define ZONE_ID @"7527"

@implementation TapitSdkHandler

@synthesize callbackID;

@synthesize bannerAd;
@synthesize interstitialAd;

@synthesize locationManager;

+ (TapitSdkHandler *)sharedInstance
{
    static TapitSdkHandler *singleton = nil;
    
    if (singleton == nil) {
        singleton = [[TapitSdkHandler alloc] init];
    }
    return singleton;
}

- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (void) initalizePlugin {
    TapItAppTracker *appTracker = [TapItAppTracker sharedAppTracker];
    [appTracker reportApplicationOpen];
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
}

/*
- (UIImage*) imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
*/


#pragma mark -
#pragma mark CoreLocation delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}


#pragma mark -
#pragma mark TapItBannerAdView Handler

- (BOOL)initBannerSimple {
    bannerAd = [[TapItBannerAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.viewController.view addSubview:self.bannerAd];
    BOOL check = [self.bannerAd startServingAdsForRequest:[TapItRequest requestWithAdZone:ZONE_ID]];
    return check;
}

- (BOOL)initBannerAdvanced:(NSString*)zoneIdVal {
    bannerAd = [[TapItBannerAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.viewController.view addSubview:self.bannerAd];
    self.bannerAd.delegate = self;
    //self.bannerAd.presentingController = self;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:zoneIdVal andCustomParameters:params];
    [request updateLocation:self.locationManager.location];
    
    BOOL check = [self.bannerAd startServingAdsForRequest:request];
    return check;
}

- (void) showBannerAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
    self.callbackID = [arguments pop];
    NSString *zoneStr = [arguments pop];
    
    BOOL check = NO;
    
    if ([zoneStr length] > 0) {
        check = [self initBannerAdvanced:zoneStr];
    }
    
    // Create Plugin Result
    NSString *stringToReturn = @"showBannerAd Callback";
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (check == YES)
    {
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else
    {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
}

- (void) hideBannerAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];
    
    BOOL check = NO;
    
    if (bannerAd) {
       [self.bannerAd hide];
        check = YES;
    }
    
    // Create Plugin Result
    NSString *stringToReturn = @"hideBannerAd Callback";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (check == YES)
    {
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else
    {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
}

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
    NSLog(@"Banner failed to load with the following error: %@", error);
    // Banner view will hide automatically if docking is enabled
    // if disabled, you'll want to hide bannerView
}

- (BOOL)tapitBannerAdViewActionShouldBegin:(TapItBannerAdView *)bannerView willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Banner was tapped, your UI will be covered up. %@", (willLeave ? @" !!LEAVING APP!!" : @""));
    // minimise app footprint for a better ad experience.
    // e.g. pause game, duck music, pause network access, reduce memory footprint, etc...
    return YES;
}

- (void)tapitBannerAdViewActionWillFinish:(TapItBannerAdView *)bannerView {
    NSLog(@"tapitBannerAdViewActionWillFinish");
    
}

- (void)tapitBannerAdViewActionDidFinish:(TapItBannerAdView *)bannerView {
    NSLog(@"Banner is done covering your app, back to normal!");
    // resume normal app functions
}

#pragma mark -
#pragma mark TapItBannerAdView Handler

- (BOOL)initInterstitial:(NSString*)zoneStrVal {
    self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
    self.interstitialAd.delegate = self;
    self.interstitialAd.animated = YES;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:zoneStrVal andCustomParameters:params];
    [request updateLocation:self.locationManager.location];
    BOOL check = [self.interstitialAd loadInterstitialForRequest:request];
    return check;
}

- (void) showInterstitialAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options 
{
    self.callbackID = [arguments pop];
    NSString *zoneStr = [arguments pop];
    
    BOOL check = NO;
    
    if ([zoneStr length] > 0) {
        check = [self initInterstitial:zoneStr];
    }
    
    // Create Plugin Result
    NSString *stringToReturn = @"showInterstitialAd Callback";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (check == YES)
    {
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else
    {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
}

#pragma mark TapItInterstitialAdDelegate methods

- (void)tapitInterstitialAd:(TapItInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)tapitInterstitialAdDidUnload:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad did unload");
    self.interstitialAd = nil; // don't reuse interstitial ad!
}

- (void)tapitInterstitialAdWillLoad:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad will load");
}

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad did load");
    [self.interstitialAd presentFromViewController:self.viewController];
}

- (BOOL)tapitInterstitialAdActionShouldBegin:(TapItInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Ad action should begin");
    return YES;
}

- (void)tapitInterstitialAdActionDidFinish:(TapItInterstitialAd *)interstitialAd {
    NSLog(@"Ad action did finish");
}

#pragma mark -
#pragma mark TapItAlertAdView Handler

- (BOOL)initAlertAd:(NSInteger)type forZone:(NSString*)zoneVal {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:zoneVal andCustomParameters:params];
    [request updateLocation:self.locationManager.location];
    tapitAdPrompt = [[TapItAdPrompt alloc] initWithRequest:request];
    tapitAdPrompt.delegate = self;
    
    if (type == 1) {
        [tapitAdPrompt showAsActionSheet];
    }
    else {
        [tapitAdPrompt showAsAlert];
    }
    //    [tapitAlertAd release];
    return YES;
}

- (void) showAlertAdAsAlert:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options 
{
    self.callbackID = [arguments pop];
    NSString *zoneStr = [arguments pop];
    
    BOOL check = NO;
    
    if ([zoneStr length] > 0) {
        check = [self initAlertAd:0 forZone:zoneStr];
    }
    
    // Create Plugin Result
    NSString *stringToReturn = @"showAlertAdAsAlert Callback";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (check == YES)
    {
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else
    {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
}

- (void) showAlertAdAsPrompt:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options 
{
    self.callbackID = [arguments pop];
    NSString *zoneStr = [arguments pop];
    
    BOOL check = NO;
    
    if ([zoneStr length] > 0) {
        check = [self initAlertAd:1 forZone:zoneStr];
    }
    
    // Create Plugin Result
    NSString *stringToReturn = @"showAlertAdAsPrompt Callback";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (check == YES)
    {
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else
    {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
}

#pragma mark TapItAlertAdDelegate methods

- (void)tapitAdPrompt:(TapItAdPrompt *)adPrompt didFailWithError:(NSError *)error {
    NSLog(@"Error showing AdPrompt: %@", error);
}

- (void)tapitAdPromptWasDeclined:(TapItAdPrompt *)adPrompt {
    NSLog(@"AdPrompt was DECLINED!");
}

- (void)tapitAdPromptDidLoad:(TapItAdPrompt *)adPrompt {
    NSLog(@"AdPrompt loaded!");
}

- (BOOL)tapitAdPromptActionShouldBegin:(TapItAdPrompt *)adPrompt willLeaveApplication:(BOOL)willLeave {
    NSString *strWillLeave = willLeave ? @"Leaving app" : @"loading internally";
    NSLog(@"AdPrompt was accepted, loading app/advertisement... %@", strWillLeave);
    return YES;
}

- (void)tapitAdPromptActionDidFinish:(TapItAdPrompt *)adPrompt {
    NSLog(@"AdPrompt Action finished!");
}

@end
