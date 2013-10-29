//
//  TapItVideoInterstitialAd.h
//  TapIt-iOS-Sample
//
//  Created by Carl Zornes on 10/29/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
#import "TVASTAdsRequest.h"
#import "TVASTVideoAdsManager.h"
#import "TVASTAdsLoader.h"
#import "TVASTClickTrackingUIView.h"
#import "TVASTClickThroughBrowser.h"
#import "FullScreenVC.h"

@protocol TapItVideoInterstitialAdDelegate <NSObject>
@required

/**
 Called when an the adsLoader receives a video and is ready to play. (required)
*/
- (void)didReceiveVideoAd;
@end

@interface TapItVideoInterstitialAd : NSObject <TVASTAdsLoaderDelegate,
TVASTClickTrackingUIViewDelegate, TVASTVideoAdsManagerDelegate,
TVASTClickThroughBrowserDelegate>

@property (assign, nonatomic) id<TapItVideoInterstitialAdDelegate> delegate;
// The loader of ads.
@property(nonatomic, retain) TVASTAdsLoader *adsLoader;
// The manager of video ads.
@property(nonatomic, retain) TVASTVideoAdsManager *videoAdsManager;
// The invisible view that tracks clicks on the video.
@property(nonatomic, retain) TVASTClickTrackingUIView *clickTrackingView;
@property (nonatomic, retain) AVPlayer              *adPlayer;
@property (nonatomic, retain) FullScreenVC          *landscapeVC;
@property (nonatomic, retain) UIViewController      *presentingViewController;

- (void)unloadAdsManager;
- (void)playVideoFromAdsManager;
@end
