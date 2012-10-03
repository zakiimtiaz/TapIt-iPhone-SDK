//
//  TapItAdMobileView.h
//  TapItAdMobile
//
//  Copyright 2012 TapIt! All rights reserved.
//
//  version: 1.5.3
//

#import <UIKit/UIKit.h>
#import "TapItAdMobileViewDelegate.h"

/** You use the TapItAdMobileView class to embed advertisement content in your application. To do so, you simply create an TapItAdMobileView object and add it to a UIView. An instance of TapItAdMobileView (or simply, an ad) is a means for displaying advertisement information from ad publisher site.
 
 Ad handles the rendering of any HTML content in its area.
 
 Ad always tries to load the content after creation. The time interval between load requests is managed using the property updateTimeInterval. Also you can update ad content immediately  using the update method. Use the isLoading property to find out if ad is in the process of loading.
 
 To configure ad visual appearance use the property defaultImage. To manage the ad animation use the property animateMode.
 
 To debug ad behavior use the property logMode.
 
 Set the delegate property to an object conforming to the TapItAdMobileViewDelegate protocol if you want to track the processing of ad content.
 */
@interface TapItAdMobileView : UIView {

}

/** @name Initializing an TapItAdMobileView Object */

/** Initializes and returns an TapItAdMobileView object having the given frame and zone.
 
 @param frame A rectangle specifying the initial location and size of the ad view in its superview's coordinates.
 @param zone A value that specifies the id of ad publisher zone.
 
 @return Returns an initialized TapItAdMobileView object or nil if the object could not be successfully initialized.
 */
- (id) initWithFrame:(CGRect)frame
				zone:(NSString*)zone;

/** @name Configuring the TapItAdMobileView */

/** Id of the publisher zone.
 
 Settings the value of this property determines the id of the publisher zone, so switching between publisher zones is possible. The default value is copied from parameter zone of ad initialization method.
 */
@property (retain) NSString*			zone;

/** Image for unloaded ad state.
 
 Settings the value of this property determines ad default image for unloaded state. In this state the content of ad is invisible and ad default image is displayed. Without connection to the internet default image also will be displayed.
 
 The default value is nil.
 */
@property (retain) UIImage*				defaultImage;

/** A Boolean value that determines whether ad animate mode is enabled.
 
 Setting the value of this property to YES enables ad animate mode and setting it to NO disables this mode.
 
 The default value is YES.

 @warning *Important:*  You need to disable animation if you specify your own.
*/
@property BOOL							animateMode;

/** @name Loading the TapItAdMobileView Content */


/** A Boolean value that determines whether ad is in the process of loading. */
@property (readonly) BOOL				isLoading;

/** Update time interval, in seconds.
 
 The value of this property determines time interval between ads updating. This interval is counted after finish loading content, so the ad will start updating only after loading is finished and time interval is passed.
 
 Setting value in range from 0 to 1 will apply 1 second to prevent too fast ad updates.
 
 Setting to 0 will stop updates. All positive values enable updates.
 
 The default value is 60.
 */
@property NSTimeInterval				updateTimeInterval;

/** Starts to update the ad content immediately.
 
 Call this method if you want update the ad content immediately. If ad is in the process of loading it will be interrupted.
 */
- (void)update;


/** @name Filtering the TapItAdMobileView Content*/

/** User location latitude value.
 
 Use this property to set latitude. The value @"" will stop coordinates auto-detection and coordinates  will not be sent to server. Any other values also will stop coordinates auto-detection but coordinates will be sent to server.
 
 By default location data will be sent to server.

 @warning *Note:* Location coordinates may not be sent to server during first ad request, because of location detection procedure may take a long time.
 */
@property (retain) NSString*            latitude;

/** User location longitude value.
 
 Use this property to set longitude. The value @"" will stop coordinates auto-detection and coordinates  will not be sent to server. Any other values also will stop coordinates auto-detection but coordinates will be sent to server.
 
 By default location data will be sent to server.
 */
@property (retain) NSString*            longitude;

/** @name Debug the TapItAdMobileView */

/** A Boolean value that determines whether ads log mode is enabled.
 
 Setting the value of this property to YES enables ads logging for this ad and setting it to NO disables logging.
 
 The default value is NO. */
@property BOOL							logMode;


/** @name Setting the Delegate */


/** The receiver's delegate.
 
 The TapItAdMobileView is sent messages when content is processing. The delegate must adopt the TapItAdMobileViewDelegate protocol.
 The delegate is not retained.
 
 @see TapItAdMobileViewDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <TapItAdMobileViewDelegate>	delegate;

@end
