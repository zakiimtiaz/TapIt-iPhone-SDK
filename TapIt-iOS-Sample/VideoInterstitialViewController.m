//
//  VideoInterstitialrViewController.m
//  TapIt-iOS-Sample
//
//  Created by Carl Zornes on 10/28/13.
//
//

#import "VideoInterstitialViewController.h"
#import "TVASTAd.h"
#import "TapItVideoInterstitialAd.h"

//*************************************
// Replace with your valid ZoneId here.
NSString *const kZoneIdVideo         = @"22219";     // 24839, 22219
@interface VideoInterstitialViewController ()

@end

@implementation VideoInterstitialViewController

@synthesize videoAd = _videoAd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _videoAd = [[TapItVideoInterstitialAd alloc] init];
    _videoAd.delegate = self;
    
    //Optional... override the presentingViewController (defaults to the delegate)
    //_videoAd.presentingViewController = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestAds {    
    // Create an adsRequest object and request ads from the ad server with your own kZoneIdVideo
    TVASTAdsRequest *request = [TVASTAdsRequest requestWithAdZone:kZoneIdVideo];
    [_videoAd requestAdsWithRequestObject:request];
    
    //If you want to specify the type of video ad you are requesting, use the call below.
    //[_videoAd requestAdsWithRequestObject:request andVideoType:TapItVideoTypeMidroll];
}

- (IBAction)onRequestAds {
    [self requestAds];
}

- (void)tapitVideoInterstitialAdDidFinish:(TapItVideoInterstitialAd *)videoAd {
    NSLog(@"Override point for resuming your app's content.");
    [_videoAd unloadAdsManager];
}

- (void)viewDidUnload {
    [_videoAd unloadAdsManager];
    [super viewDidUnload];
}

- (void)tapitVideoInterstitialAdDidLoad:(TapItVideoInterstitialAd *)videoAd {
    NSLog(@"We received an ad... now show it.");
    [videoAd playVideoFromAdsManager];
}

- (void)tapitVideoInterstitialAdDidFail:(TapItVideoInterstitialAd *)videoAd withErrorString:(NSString *)error {
    NSLog(@"%@", error);
}
@end
