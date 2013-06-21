//
//  TRMAAd.h
//  TapIt Rich Meda Ads SDK
//
//  Created by Kevin Truong on 4/30/13.
//
//  Copyright 2013 TapIt by Phunware Inc. All rights reserved.
//
//  Declares TRMAAd interface that has the general representation of an ad.

#import <Foundation/Foundation.h>

typedef enum {
  kTRMAAdTypeVideo,
} TRMAAdType;

@interface TRMAAd : NSObject {

}

@property(readonly, assign) TRMAAdType adType;
@property(readonly, retain) NSString *adId;
@property(readonly, assign) float creativeWidth;
@property(readonly, assign) float creativeHeight;

/// The length of the media file in seconds. Returns -1 if the duration value
/// is not available.
@property(readonly, assign) float duration;

/// The URL of the media file chosen from the ad to play. Returns null if the
/// information is not available.
@property(readonly, retain) NSString *mediaUrl;

@end

