//
//  TRMAClickTrackingUIView.h
//  TapIt Rich Meda Ads SDK
//
//  Copyright 2013 TapIt by Phunware Inc. All rights reserved.
//
//  Declares TRMAClickTrackingUIView instance that is set to track clicks on the
//  ad. Also defines a delegate protocol for click tracking view to get
//  clicks from the view.
//

#import <UIKit/UIKit.h>

#pragma mark TRMAClickTrackingUIViewDelegate

@class TRMAClickTrackingUIView;

/// Delegate protocol for TRMAClickTrackingUIView.
//
/// The publisher can adopt this protocol to receive touch events from the
/// TRMAClickTrackingUIView instance.
@protocol TRMAClickTrackingUIViewDelegate

 @required
/// Received when the user touched the click tracking view.
- (void)clickTrackingView:(TRMAClickTrackingUIView *)view
    didReceiveTouchEvent:(UIEvent *)event;

@end

#pragma mark -

/// A UIView instance that is used as the click tracking element.
//
/// In order for the SDK to track clicks on the ad, a transparent click tracking
/// should be added on the video player and should be added as the tracking
/// element by setting click tracking view on TRMAVideoAdsManager.
@interface TRMAClickTrackingUIView : UIView <UIGestureRecognizerDelegate>

/// Delegate object that receives touch notifications.
//
/// The caller should implement TRMAClickTrackingUIViewDelegate to get touch
/// events from the view. Remember to nil the delegate before deallocating
/// this object.
@property (nonatomic, assign) id<TRMAClickTrackingUIViewDelegate> delegate;


@end
