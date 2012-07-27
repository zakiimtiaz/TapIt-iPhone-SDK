//
//  TapItBrowserController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TapItBrowserControllerDelegate;

@interface TapItBrowserController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (assign, nonatomic) id<TapItBrowserControllerDelegate> delegate;
@property (readonly) NSURL *url;

- (void)loadUrl:(NSURL *)url;
- (void)showFullscreenBrowser;
- (void)showFullscreenBrowserAnimated:(BOOL)animated;

@end


@protocol TapItBrowserControllerDelegate <NSObject>
@required
- (void)browserControllerFailedToLoad:(TapItBrowserController *)browserController withError:(NSError *)error;
- (BOOL)browserControllerShouldLoad:(TapItBrowserController *)browserController willLeaveApp:(BOOL)willLeaveApp;
- (void)browserControllerLoaded:(TapItBrowserController *)browserController willLeaveApp:(BOOL)willLeaveApp;
- (void)browserControllerDismissed:(TapItBrowserController *)browserController;
@end