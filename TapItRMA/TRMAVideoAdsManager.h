//
//  TRMAVideoAdsManager.h
//  TapIt Rich Meda Ads SDK
//
//  Copyright 2013 TapIt by Phunware Inc. All rights reserved.
//
//  Declares TRMAVideoAdsManager interface that manages playing and unloading
//  video ads.

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TRMAAdError.h"
#import "TRMAClickTrackingUIView.h"

/// Supported AdsManager Types
typedef enum {
    kTRMAAdsManagerTypeVideo,
} TRMAAdsManagerType;

@class TRMAVideoAdsManager;

/// Delegate object that gets state change callbacks from TRMAVideoAdsManager.
@protocol TRMAVideoAdsManagerDelegate<NSObject>

/// Called when content should be paused. This usually happens right before a
/// an ad is about to cover the content.
- (void)contentPauseRequested:(TRMAVideoAdsManager *)adsManager;

/// Called when content should be resumed. This usually happens when ad ad
/// finishes or collapses.
- (void)contentResumeRequested:(TRMAVideoAdsManager *)adsManager;

@optional
/// Called when an error occured while loading or playing the ad.
- (void)didReportAdError:(TRMAAdError *)error;

@end

#pragma mark -
#pragma mark TRMAVastEventNotifications

/// Start Vast event broadcasted by the ads manager.
//
/// This happens when video ad starts to play.
extern NSString * const TRMAVastEventStartNotification;

/// First quartile Vast event broadcasted by the ads manager.
//
/// This happens when ad crosses first quartile boundary.
extern NSString * const TRMAVastEventFirstQuartileNotification;

/// Midpoint Vast event broadcasted by the ads manager.
//
/// This happens when ad crosses midpoint boundary.
extern NSString * const TRMAVastEventMidpointNotification;

/// Third quartile Vast event broadcasted by the ads manager.
//
/// This happens when ad crosses third quartile boundary.
extern NSString * const TRMAVastEventThirdQuartileNotification;

/// Complete Vast event broadcasted by the ads manager.
//
/// This happens when video ad completes playing successfully.
extern NSString * const TRMAVastEventCompleteNotification;

/// Pause Vast event broadcasted by the Video ads manager.
//
/// This happens when video ad pauses.
extern NSString * const TRMAVastEventPauseNotification;

/// Click event broadcasted by the Video ads manager.
//
/// This happens when user clicks on the click tracking element overlayed on
/// the video ad.
extern NSString * const TRMAVastEventClickNotification;

/// Rewind event broadcasted by the Video ads manager.
//
/// This happens when user rewinds the video ad.
extern NSString * const TRMAVastEventRewindNotification;

/// \memberof TRMAVideoAdsManager
/// Skip event broadcast by the Video ads manager.
//
/// This happens when user skips the current ad.
extern NSString * const TRMAVastEventSkipNotification;

/// Impression broadcast by the Video ads manager.
//
extern NSString * const TRMAVastImpressionNotification;

/// Linear ad createevent broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventCreativeViewNotification;

/// Linear ad error event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventLinearErrorNotification;

/// Linear ad mute event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventMuteNotification;

/// Linear ad unmute event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventUnmuteNotification;

/// Linear ad resume event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventResumeNotification;

/// Linear ad fullscreen event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventFullscreenNotification;

/// Linear ad expand event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventExpandNotification;

/// Linear ad collapse event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventCollapseNotification;

/// Linear ad accept invitation event broadcast by the Video ads manager.
//
extern NSString * const TRMAVastEventAcceptInvitationLinearNotification;

extern NSString * const TRMAVastEventAcceptInvitationNotification;

extern NSString * const TRMAVastEventCloseNotification;

extern NSString * const TRMAVastEventCloseLinearNotification;

#pragma mark -

/// The TRMAVideoAdsManager class is responsible for playing video ads.
@interface TRMAVideoAdsManager : NSObject <UIGestureRecognizerDelegate>

/// Stops playing the ad and unloads the ad asset.
//
/// Removes ad assets at runtime that need to be properly removed at the time
/// of ad completion amd stops the ad and removes tracking.
- (void)unload;

/// Returns the AdsManager type.
@property(readonly, assign) TRMAAdsManagerType adsManagerType;

/// List of ads managed by the ads manager.
@property(readonly, retain) NSArray *ads;


/// Play the loaded ad in the provided |player|.
//
/// The caller should implement TRMAVideoAdsManagerDelegate and set the delegate
/// before calling this method so the SDK can send notifications about state
/// changes that require player attention.

- (void)playWithAVPlayer:(AVPlayer *)player;

/// Sets the click tracking view which will tracks clicks on the player.
//
/// Click tracking must be enabled on the video player area before the ad can be
/// played. Create an instance that is of type TRMAClickTrackingUIView and set it
/// as a transparent view on top of the video player. If this is not set clicks
/// will not be tracked by the SDK.
@property(nonatomic, retain) TRMAClickTrackingUIView *clickTrackingView;

@property(nonatomic, assign) BOOL showFullScreenAd;

/// Delegate object that receives state change notifications.
//
/// The caller should implement TRMAVideoAdsManagerDelegate to get state change
/// notifications from the ads manager. Remember to nil the delegate before
/// deallocating this object.
@property(nonatomic, assign) NSObject<TRMAVideoAdsManagerDelegate> *delegate;

@end
