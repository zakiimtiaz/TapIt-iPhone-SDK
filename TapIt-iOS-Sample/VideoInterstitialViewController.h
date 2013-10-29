//
//  VideoInterstitialrViewController.h
//  TapIt-iOS-Sample
//
//  Created by Carl Zornes on 10/28/13.
//
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
#import "TVASTAdsRequest.h"
#import "TVASTVideoAdsManager.h"
#import "TVASTAdsLoader.h"
#import "TVASTClickTrackingUIView.h"
#import "TVASTClickThroughBrowser.h"
#import "FullScreenVC.h"

@interface VideoInterstitialViewController : UIViewController<TVASTAdsLoaderDelegate,
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

- (IBAction)onRequestAds;
@end
