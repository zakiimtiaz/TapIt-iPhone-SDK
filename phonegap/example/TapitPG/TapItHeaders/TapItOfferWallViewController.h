//
//  TapItOfferWallViewController.h
//  TapItAdMobile
//
//  Copyright 2012 TapIt! All rights reserved.
//
//  version: 1.5.3
//

#import <UIKit/UIKit.h>

@class TapItOfferWallViewController;

/** The TapItOfferWallViewControllerDelegate protocol defines methods that a delegate of a TapItOfferWallViewController object can optionally implement to receive notifications from the offer wall.
 */
@protocol TapItOfferWallViewControllerDelegate <NSObject>
@optional

/** Sent before dismissing animation starts.
 
 @param sender The TapItOfferWallViewController instance.
 */
- (void) willDismissOfferWallViewController:(TapItOfferWallViewController*)sender;

/** Sent after an offer wall was closed and tracks the time passed between appearing offer wall and disappearing it.
 
 @param sender The TapItOfferWallViewController instance.
 @param afterTimeInterval Time interval passed between appearing offer wall and disappearing it.
 */
- (void) didDismissOfferWallViewController:(TapItOfferWallViewController*)sender afterTimeInterval:(NSTimeInterval)afterTimeInterval;
@end


/** You use the TapItOfferWallViewController (or simply, an offer wall) class for full-screen displaying list of the offers with specific closing behavior.
 
 After an offer wall became visible, user is able to click on one or more offer links he interested in or just close an offer wall.
 
 Set the delegate property to an object conforming to the TapItOfferWallViewControllerDelegate protocol if you want to track events from the offer wall.
 */
@interface TapItOfferWallViewController : UIViewController

/** @name Initializing an TapItOfferWallViewController Object */

/** Initializes and returns a TapItOfferWallViewController object having the given zone.
 
 @param zone A value that specifies the id of ad publisher zone.
 
 @return Returns an initialized TapItOfferWallViewController object or nil if the object could not be successfully initialized.
 */
-(id)initWithZone:(NSString*)zone;

/** @name Configuring the TapItOfferWallViewController */

/** 
 Property to customize Close button title. Default value is "Close".
 */
@property (copy) NSString* closeButtonTitle;

/** @name Setting the Delegate */

/** The receiver's delegate.
 
 The TapItOfferWallViewController is sent message when offer wall closes. The delegate must adopt the TapItOfferWallViewControllerDelegate protocol.
 The delegate is not retained.
 
 @see TapItOfferWallViewControllerDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id<TapItOfferWallViewControllerDelegate> delegate;

@end

