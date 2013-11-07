//
//  TapItVideoAdViewController.h
//  TapItAdMobile
//
//  Copyright 2012 TapIt! All rights reserved.
//
//  version: 1.5.3
//

#import <UIKit/UIKit.h>

@class TapItVideoAdViewController;

/** The TapItVideoAdViewControllerDelegate protocol defines methods that a delegate of a TapItVideoAdViewController object can optionally implement to receive notifications from the video ad.
 */
@protocol TapItVideoAdViewControllerDelegate <NSObject>
@optional

/** Sent before dismissing animation starts.
 
 @param sender The TapItVideoAdViewController instance.
 */
- (void) willDismissVideoAdViewController:(TapItVideoAdViewController*)sender;

/** Sent after the video ad was dismissed and tracks the time passed between appearing video ad and disappearing it.
 
 @param sender The TapItVideoAdViewController instance.
 @param afterTimeInterval Time interval passed between appearing video ad and disappearing it.
 */
- (void) didDismissVideoAdViewController:(TapItVideoAdViewController*)sender afterTimeInterval:(NSTimeInterval)afterTimeInterval;
@end


/** You use the TapItVideoAdViewController (or simply, video ad) class for full-screen displaying video ads with specific closing behavior.
 
 After video playing is finished or playing timeout expires user will be able to close video ad or go to the publisher's site.
 
 Set the delegate property to an object conforming to the TapItVideoAdViewControllerDelegate protocol if you want to track events from the video ad.
 */
@interface TapItVideoAdViewController : UIViewController

/** @name Initializing an TapItVideoAdViewController Object */

/** Initializes and returns an TapItVideoAdViewController object having the given zone.
 
 @param zone A value that specifies the id of ad publisher zone.
 
 @return Returns an initialized TapItVideoAdViewController object or nil if the object could not be successfully initialized.
 */
-(id)initWithZone:(NSString*)zone;

/** @name Setting the Delegate */

/** The receiver's delegate.
 The TapItVideoAdViewController sends some messages. The delegate must adopt the TapItVideoAdViewControllerDelegate protocol.
 The delegate is not retained.
 
 @see TapItVideoAdViewControllerDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <TapItVideoAdViewControllerDelegate>	delegate;

@end