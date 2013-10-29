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
#import "TapItVideoInterstitialAd.h"

@interface VideoInterstitialViewController : UIViewController<TapItVideoInterstitialAdDelegate>

@property (nonatomic, retain) IBOutlet UIButton     *adRequestButton;
@property (nonatomic, retain) TapItVideoInterstitialAd *videoAd;

- (IBAction)onRequestAds;
@end
