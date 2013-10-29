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

@interface TapItVideoInterstitialAd : NSObject <TVASTAdsLoaderDelegate,
TVASTClickTrackingUIViewDelegate, TVASTVideoAdsManagerDelegate,
TVASTClickThroughBrowserDelegate>

// The loader of ads.
@property(nonatomic, retain) TVASTAdsLoader *adsLoader;
// The manager of video ads.
@property(nonatomic, retain) TVASTVideoAdsManager *videoAdsManager;
// The invisible view that tracks clicks on the video.
@property(nonatomic, retain) TVASTClickTrackingUIView *clickTrackingView;
@property (nonatomic, retain) AVPlayer              *adPlayer;
@property (nonatomic, retain) FullScreenVC          *landscapeVC;
@property (nonatomic, retain) IBOutlet UIButton     *adRequestButton;
@property (nonatomic, retain) UIViewController      *presentingViewController;

- (void)setUpAdPlayer;
- (void)unloadAdsManager;
@end
