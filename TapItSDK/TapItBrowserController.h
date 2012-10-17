//
//  TapItBrowserController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/26/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    #import <StoreKit/StoreKit.h>
#endif

#import "TapItAdDelegates.h"

@protocol TapItBrowserControllerDelegate;

@interface TapItBrowserController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (assign, nonatomic) id<TapItBrowserControllerDelegate> delegate;
@property (readonly) NSURL *url;
@property (assign, nonatomic) UIViewController *presentingController;

- (void)loadUrl:(NSURL *)url;
- (void)showFullscreenBrowser;
- (void)showFullscreenBrowserAnimated:(BOOL)animated;

@end
