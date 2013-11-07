//
//  TapitSdkHandler.h
//  TapitPG
//
//  Created 
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "TapItAdDelegates.h"

@class TapItBannerAdView;
@class TapItInterstitialAd;
@class TapItAdPrompt;

@interface TapitSdkHandler : CDVPlugin <CLLocationManagerDelegate,TapItBannerAdViewDelegate,TapItInterstitialAdDelegate,TapItAdPromptDelegate> {
    NSString* callbackID;
    TapItAdPrompt *tapitAdPrompt;
}

@property (nonatomic, copy) NSString* callbackID;
@property (retain, nonatomic) CLLocationManager *locationManager;

@property (retain, nonatomic) TapItBannerAdView *bannerAd;
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

+ (TapitSdkHandler *)sharedInstance;
- (void) initalizePlugin;

- (void) showBannerAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) hideBannerAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void) showInterstitialAd:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
