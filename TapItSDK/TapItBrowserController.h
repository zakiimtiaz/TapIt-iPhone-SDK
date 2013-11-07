//
//  TapItBrowserController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/26/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#ifndef DISABLE_NEW_FEATURES
    #import <StoreKit/StoreKit.h>
#endif

#import "TapItBrowserControllerDelegate.h"

@protocol TapItBrowserControllerDelegate;

@interface TapItBrowserController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (assign, nonatomic) id<TapItBrowserControllerDelegate> delegate;
@property (readonly) NSURL *url;
@property (assign, nonatomic) UIViewController *presentingController;
@property (assign) BOOL showLoadingOverlay;

- (void)loadUrl:(NSURL *)url;
- (void)showFullscreenBrowser;
- (void)showFullscreenBrowserAnimated:(BOOL)animated;

@end
