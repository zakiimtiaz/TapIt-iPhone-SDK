//
//  TapItAppTracker.h
//  TapItAdMobile
//
//  Copyright 2012 TapIt! All rights reserved.
//
//  version: 1.5.3
//

#import <Foundation/Foundation.h>

/** You use the TapItAppTracker class to track installations of your application and other custom events, occurred while application is running.
 */
@interface TapItAppTracker : NSObject {
    
}

/** @name Getting instance */

/** Initializes TapItAppTracker object if needed and returns it's instance.
 
 @return Returns shared instance of TapItAppTracker object.
 */
+ (TapItAppTracker*)sharedInstance;

/** @name Reporting */

/** Notifies TapIt! about the installation of an application. Report is sent only at first application's run. Method will attempt to send report only five times, if all attempts are not successful, attempts will be continued at the next application's run.
 */
- (void)reportInstallation;

/** Notifies TapIt! about the custom user event.

 @param eventTag A value of custom user event.
 */
- (void)reportEvent:(NSString*)eventTag;

@end
