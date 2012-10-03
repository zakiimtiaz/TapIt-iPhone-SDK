//
//  TapItFullscreenAdViewController.h
//  TapItAdMobile
//
//  Copyright 2012 TapIt! All rights reserved.
//
//  version: 1.5.3
//

#import <UIKit/UIKit.h>

@class TapItFullscreenAdViewController;

/** The TapItFullscreenAdViewControllerDelegate protocol defines methods that a delegate of a TapItFullscreenAdViewController object can optionally implement to receive notifications from the full-screen ad.
 */
@protocol TapItFullscreenAdViewControllerDelegate <NSObject>
@optional

/** Sent before dismissing animation starts.
 
 @param sender The TapItFullscreenAdViewController instance.
 */
- (void) willDismissFullscreenAdViewController:(TapItFullscreenAdViewController*)sender;

/** Sent after the full-screen ad was dismissed and tracks the time passed between appearing full-screen ad view controller and disappearing it.
 
 @param sender The TapItFullscreenAdViewController instance.
 @param afterTimeInterval Time interval passed between appearing full-screen ad view controller and disappearing it.
 */
- (void) didDismissFullscreenAdViewController:(TapItFullscreenAdViewController*)sender afterTimeInterval:(NSTimeInterval)afterTimeInterval;
@end


/** You use the TapItFullscreenAdViewController (or simply, full-screen ad) class for full-screen displaying ads with specific closing behavior.
 
 After ad became visible, user is able to click on it to go to the publisher's site. The full-screen ad dismisses automatically after the autoclose timeout expires.
 
 Set the delegate property to an object conforming to the TapItFullscreenAdViewControllerDelegate protocol if you want to track events from the full-screen ad.
 */
@interface TapItFullscreenAdViewController : UIViewController <TapItFullscreenAdViewControllerDelegate>

/** @name Initializing an TapItFullscreenAdViewController Object */

/** Initializes and returns a TapItFullscreenAdViewController object having the given zone and autoclose time interval.
 
 @param zone A value that specifies the id of ad publisher zone.
 @param autocloseTimeInterval A value for auto close time interval in seconds.
 The default value is 10. Even if time interval is set to zero, the default value will be used.
 
 @return Returns an initialized TapItFullscreenAdViewController object or nil if the object could not be successfully initialized.
 */
-(id)initWithZone:(NSString*)zone autocloseTimeInterval:(NSTimeInterval)autocloseTimeInterval;

/** @name Setting the Delegate */

/** The receiver's delegate.
 
 The TapItFullscreenAdViewControllerDelegate sends some messages. The delegate must adopt the TapItFullscreenAdViewControllerDelegate protocol.
 The delegate is not retained.
 
 @see TapItFullscreenAdViewControllerDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <TapItFullscreenAdViewControllerDelegate>	delegate;

@end
