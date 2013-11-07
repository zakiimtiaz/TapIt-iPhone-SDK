//
//  TapItAdMobileInterstitialView.h
//  TapItAdMobile
//
//  Copyright 2012 TapIt! All rights reserved.
//
//  version: 1.5.3
//

#import <UIKit/UIKit.h>
#import "TapItAdMobileView.h"

/** The TapItAdMobileInterstitialView class is subclassing of TapItAdMobileView with advanced customization parameters. An instance of TapItAdMobileInterstitialView is a means for full-screen displaying ads with specific closing. 
 */
@interface TapItAdMobileInterstitialView : TapItAdMobileView {
    
}


/** @name Customizing TapItAdMobileInterstitialView Closing */


/** Show close button delay time interval, in seconds.
 
 Setting to 0 will show close button immediately.
 
 The default value is 0.
 */
@property NSTimeInterval showCloseButtonTime;

/** Auto close interstitial time interval, in seconds.
 
 Setting to 0 will disable auto closing interstitial.
 
 The default value is 0.
 */
@property NSTimeInterval autocloseInterstitialTime;

/** Interstitial close button.
 
 Set this value to customize close button appearance.
 */
@property (retain) UIButton* closeButton;


/** @name Setting the Delegate */


/** The receiver's delegate.
 
 The TapItAdMobileInterstitialView is sent messages when content is processing. The delegate must adopt the TapItAdMobileInterstitialViewDelegate protocol.
 The delegate is not retained.
 
 @see TapItAdMobileInterstitialViewDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <TapItAdMobileInterstitialViewDelegate>	delegate;

@end
