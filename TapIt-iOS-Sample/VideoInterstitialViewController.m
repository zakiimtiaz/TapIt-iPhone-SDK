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
    [_videoAd unloadAdsManager];
    
    // Create an adsRequest object and request ads from the ad server with your own zone_id
    TVASTAdsRequest *request = [TVASTAdsRequest requestWithAdZone: kZoneIdVideo];
    [request setCustomParameter:@"preroll" forKey:@"videotype"];
    [_videoAd.adsLoader requestAdsWithRequestObject:request];
}

- (IBAction)onRequestAds {
    [self requestAds];
}

- (void)viewDidUnload {
    [_videoAd unloadAdsManager];
    [super viewDidUnload];
}

- (void)didReceiveVideoAd {
    NSLog(@"We received an ad... now show it.");
    [_videoAd playVideoFromAdsManager];
}

@end