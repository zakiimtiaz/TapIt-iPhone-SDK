//
//  TRMAAdsLoader.h
//  TapIt Rich Meda Ads SDK
//
//  Created by Kevin Truong on 4/30/13.
//
//  Copyright 2013 TapIt by Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMAVideoAdsManager.h"
#import "TRMAAdsRequest.h"
#import "TRMAAdError.h"

/// Ad loaded data that is returned when the adsLoader loads the ad.
@interface TRMAAdsLoadedData : NSObject

/// The ads manager returned by the adsLoader.
@property(nonatomic, retain) TRMAVideoAdsManager *adsManager;
/// Other user context object returned by the adsLoader.
@property(nonatomic, retain) id userContext;

@end

/// Ad error data that is returned when the adsLoader failed to load the ad.
@interface TRMAAdLoadingErrorData : NSObject

/// The ad error that occured while loading the ad.
@property(nonatomic, retain) TRMAAdError *adError;
/// Other user context object returned by the adsLoader.
@property(nonatomic, retain) id userContext;

@end

@class TRMAAdsLoader;

/// Delegate object that receives state change callbacks from IMAAdsLoader.
@protocol TRMAAdsLoaderDelegate<NSObject>

/// Called when ads are successfully loaded from the ad servers by the loader.
- (void)adsLoader:(TRMAAdsLoader *)loader
    adsLoadedWithData:(TRMAAdsLoadedData *)adsLoadedData;

/// Error reported by the ads loader when ads loading failed.
- (void)adsLoader:(TRMAAdsLoader *)loader
    failedWithErrorData:(TRMAAdLoadingErrorData *)adErrorData;

@end

/// The TRMAAdsLoader class allows requesting ads from various ad servers.
//
/// To do so, IMAAdsLoaderDelegate must be implemented and then ads should
/// be requested.
@interface TRMAAdsLoader : NSObject

/// Request ads by providing the ads |request| object with properties populated
/// with parameters to make an ad request to Google or DoubleClick ad server.
/// Optionally, |userContext| object that is associated with the ads request can
/// be provided. This can be retrieved when the ads are loaded.
- (void)requestAdsWithRequestObject:(TRMAAdsRequest *)request
                        userContext:(id)context;

/// Request ads from a adsserver by providing the ads request object.
- (void)requestAdsWithRequestObject:(TRMAAdsRequest *)request;

/// Delegate object that receives state change notifications from this
/// IMAAdsLoader. Remember to nil the delegate before releasing this
/// object.
@property(nonatomic, assign) NSObject<TRMAAdsLoaderDelegate> *delegate;

@end
