//
//  TapItAdPrompt.h
//  TapIt iOS SDK
//
//  Created by Nick Penteado on 7/20/12.
//  Updated by Carl Zornes on 10/23/13.
//  Copyright (c) 2013 TapIt!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TapItRequest;
@protocol TapItAdPromptDelegate;

/**
 `TapItAdPrompt` implements a standard `TapItAdPrompt` into your app.
 */

@interface TapItAdPrompt : NSObject <UIActionSheetDelegate>

///-----------------------
/// @name Required Methods
///-----------------------

/**
 Once a `TapItRequest` object is created, this function should be called to begin requesting ads for your app.
 @param request The ad request with zone information and any custom parameters.
 */
- (id)initWithRequest:(TapItRequest *)request;

///---------------
/// @name Optional
///---------------

/**
 Preloads the ad for the current `TapItRequest`.
 */
- (void)load;

/**
 Shows the current `TapItRequest` as a `UIAlertView`.
 */
- (void)showAsAlert;

/**
 Shows the current `TapItRequest` as a `UIActionSheet`.
 */
- (void)showAsActionSheet;

/**
 An `id` that is used to identify the 'TapItAdPromptDelegate' delegate.
 */
@property (assign, nonatomic) id<TapItAdPromptDelegate> delegate;

/**
 A readonly `BOOL` to signify whether or not the ad has loaded.
 */
@property (readonly) BOOL loaded;

/**
 A `BOOL` to signify whether or not you want the ad to show a loading overlay once the ad is tapped. The default value is `TRUE`.
 */
@property (assign) BOOL showLoadingOverlay;

@end

@protocol TapItAdPromptDelegate <NSObject>
@required

/**
 Called when an AdPrompt fails to load a new advertisement. (required)
 
 @param adPrompt The AdPrompt that received the error.
 @param error The error object that describes the problem.
 
 Although the error message informs your application about why the error occurred, normally your application does not need to display the error to the user.
 
 When an error occurs, your delegate should release the ad object.
 */
- (void)tapitAdPrompt:(TapItAdPrompt *)adPrompt didFailWithError:(NSError *)error;

@optional
/**
 Called after an AdPrompt is declined
 
 @param adPrompt The AdPrompt that was declined.
 */
- (void)tapitAdPromptWasDeclined:(TapItAdPrompt *)adPrompt;

/**
 Called after the AdPrompt is loaded
 
 @param adPrompt The AdPrompt that loaded a new advertisement.
 */
- (void)tapitAdPromptDidLoad:(TapItAdPrompt *)adPrompt;


/**
 Called after the AdPrompt is displayed
 
 @param adPrompt The AdPrompt that was shown.
 */
- (void)tapitAdPromptWasDisplayed:(TapItAdPrompt *)adPrompt;

/**
 Called before an AdPrompt executes an action.
 
 @param adPrompt The AdPrompt that the user tapped.
 @param willLeave YES if another application will be launched to execute the action; NO if the action is going to be executed inside your appliaction.
 
 @return Your delegate returns YES if the action should execute; NO to prevent the banner action from executing.
 
 When the user taps a presented advertisement, the ad’s delegate is called to inform your application that the user wants to interact with the ad.
 To allow the action to be triggered, your method should return YES; to suppress the action, your method returns NO. Your application should almost
 always allow actions to be triggered; preventing actions may alter the advertisements your application sees and reduce the revenue your application earns through TapIt.
 
 If the value of the willLeave parameter is YES and your delegate allows the advertisement to execute its action, then your application is moved to
 the background shortly after the call to this method completes.
 
 If the value of the willLeave parameter is NO, the advertisement’s interactive experience will run inside your application. To accomodate the advertisement,
 your application should disable activities that require user interaction as well as disabling any tasks or behaviors that may interfere with the advertisement.
 For example, a game might pause its game play and turn off sound effects until the user finishes interacting with the advertisement. Further, while the
 action is running, your application should also be prepared to respond to low-memory warnings by disposing of objects it can easily recreate after the
 advertisement completes its action.
 */
- (BOOL)tapitAdPromptActionShouldBegin:(TapItAdPrompt *)adPrompt willLeaveApplication:(BOOL)willLeave;

/**
 Called after a AdPrompt finishes executing an action that covered your application's user interface.
 
 @param adPrompt The AdPrompt that finished executing an action.
 */
- (void)tapitAdPromptActionDidFinish:(TapItAdPrompt *)adPrompt;

@end