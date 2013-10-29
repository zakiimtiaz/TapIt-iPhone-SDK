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
NSString *const kCreativeVideoID     = @"128681";
@interface VideoInterstitialViewController ()

@end

@implementation VideoInterstitialViewController

@synthesize adsLoader = _adsLoader;
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
    [_videoAd setUpAdPlayer];
    self.adsLoader = [[TVASTAdsLoader alloc] init];
    _adsLoader.delegate = _videoAd;
    _videoAd.presentingViewController = self;
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
    [request setCustomParameter:kCreativeVideoID forKey:@"cid"];
    [request setCustomParameter:@"preroll" forKey:@"videotype"];
    [_adsLoader requestAdsWithRequestObject:request];
}

- (IBAction)onRequestAds {
    [self requestAds];
}

- (void)viewDidUnload {
    [_videoAd unloadAdsManager];
    self.adsLoader = nil;
    [super viewDidUnload];
}

@end
