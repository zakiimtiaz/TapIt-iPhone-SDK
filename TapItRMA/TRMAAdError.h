//
//  TRMAAdError.h
//  TapIt Rich Meda Ads SDK
//
//  Copyright 2013 TapIt by Phunware Inc. All rights reserved.
//
//  This file provides error codes that are raised internally by the SDK and
//  declares the TRMAAdError instance.

#import <Foundation/Foundation.h>

/// Possible error types while loading or playing ads.
typedef enum {
  /// An unexpected error occured while loading or playing the ads.
  //
  /// This may mean that the SDK wasn't loaded properly.
  kTRMAAdUnknownErrorType,
  /// An error occured while loading the ads.
  kTRMAAdLoadingFailed,
  /// An error occured while playing the ads.
  kTRMAAdPlayingFailed,
} TRMAErrorType;

/// Possible error codes raised while loading or playing ads.
typedef enum {
  /// Unknown error occured while loading or playing the ad.
  kTRMAUnknownErrorCode = 0,
  /// There was an error playing the video ad.
  kTRMAVideoPlayError = 1003,
  /// There was a problem requesting ads from the server.
  kTRMAFailedToRequestAds = 1004,
  /// There was an internal error while loading the ad.
  kTRMAInternalErrorWhileLoadingAds = 2001,
  /// No supported ad format was found.
  kTRMASupportedAdsNotFound = 2002,
  /// At least one VAST wrapper ad loaded successfully and a subsequent wrapper
  /// or inline ad load has timed out.
  kTRMAVastLoadTimeout = 3001,
  /// At least one VAST wrapper loaded and a subsequent wrapper or inline ad
  /// load has resulted in a 404 response code.
  kTRMAVastInvalidUrl = 3002,
  /// The ad response was not recognized as a valid VAST ad.
  kTRMAVastMalformedResponse = 3003,
  /// A media file of a VAST ad failed to load or was interrupted mid-stream.
  kTRMAVastMediaError = 3004,
  /// The maximum number of VAST wrapper redirects has been reached.
  kTRMAVastTooManyRedirects = 3005,
  /// Assets were found in the VAST ad response, but none of them matched the
  /// video player's capabilities.
  kTRMAVastAssetMismatch = 3006,
  /// No assets were found in the VAST ad response.
  kTRMAVastAssetNotFound = 3007,
  /// Invalid arguments were provided to SDK methods.
  kTRMAInvalidArguments = 3101,
  /// A companion ad failed to load or render.
  kTRMACompanionAdLoadingFailed = 3102,
  /// The ad response was not understood and cannot be parsed.
  kTRMAUnknownAdResponse = 3103,
  /// An unexpected error occurred while loading the ad.
  kTRMAUnexpectedLoadingError = 3104,
  /// An overlay ad failed to load.
  kTRMAOverlayAdLoadingFailed = 3105,
  /// An overlay ad failed to render.
  kTRMAOverlayAdPlayingFailed = 3106,
} TRMAErrorCode;

#pragma mark -

/// Surfaces an error that occured during ad loading or playing.
@interface TRMAAdError : NSError

/// The |errorType| accessor provides information about whether the error
/// occured during ad loading or ad playing.
@property (nonatomic, readonly) TRMAErrorType errorType;


@end
