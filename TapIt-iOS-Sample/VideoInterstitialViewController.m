//
//  VideoInterstitialrViewController.m
//  TapIt-iOS-Sample
//
//  Created by Carl Zornes on 10/28/13.
//
//

#import "VideoInterstitialViewController.h"
#import "TVASTAd.h"

//*************************************
// Replace with your valid ZoneId here.
NSString *const kZoneIdVideo         = @"22219";     // 24839, 22219
NSString *const kCreativeVideoID     = @"128681";
@interface VideoInterstitialViewController ()

@end

@implementation VideoInterstitialViewController

@synthesize adsLoader       = _adsLoader;
@synthesize videoAdsManager = _videoAdsManager;
@synthesize clickTrackingView=_clickTrackingView;
@synthesize landscapeVC=_landscapeVC;

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
    [self setUpAdPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// unload the ad manager after use.
- (void)unloadAdsManager {
    if (_videoAdsManager != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_videoAdsManager unload];
        _videoAdsManager.delegate = nil;
        self.videoAdsManager = nil;
    }
}

- (void)requestAds {
    [self unloadAdsManager];
    
    // Create an adsRequest object and request ads from the ad server with your own zone_id
    TVASTAdsRequest *request = [TVASTAdsRequest requestWithAdZone: kZoneIdVideo];
    [request setCustomParameter:kCreativeVideoID forKey:@"cid"];
    [request setCustomParameter:@"preroll" forKey:@"videotype"];
    [_adsLoader requestAdsWithRequestObject:request];
}

#pragma mark -
#pragma mark TVASTAdsLoaderDelegate implementation

// Sent when ads are successfully loaded from the ad servers
- (void)adsLoader:(TVASTAdsLoader *)loader adsLoadedWithData:(TVASTAdsLoadedData *)adsLoadedData {
    //[self logMessage:@"Ads have been loaded.\n"];
    
    TVASTVideoAdsManager *adsManager = adsLoadedData.adsManager;
    
    if (adsManager) {
        self.videoAdsManager = adsManager;
        // Set delegate to receive callbacks.
        _videoAdsManager.delegate = self;
        // Set the click tracking view.
        _videoAdsManager.clickTrackingView = _clickTrackingView;
        
        [TVASTClickThroughBrowser enableInAppBrowserWithViewController:nil delegate:self];
        
        // set show ad full-screen or not.
        _videoAdsManager.showFullScreenAd = TRUE;
        
        // Add notification observer for all VAST events.
//        [self addObserverForVastEvent:TVASTVastEventStartNotification];
//        [self addObserverForVastEvent:TVASTVastEventFirstQuartileNotification];
//        [self addObserverForVastEvent:TVASTVastEventMidpointNotification];
//        [self addObserverForVastEvent:TVASTVastEventThirdQuartileNotification];
//        [self addObserverForVastEvent:TVASTVastEventCompleteNotification];
//        [self addObserverForVastEvent:TVASTVastEventClickNotification];
//        [self addObserverForVastEvent:TVASTVastEventPauseNotification];
//        [self addObserverForVastEvent:TVASTVastEventRewindNotification];
//        [self addObserverForVastEvent:TVASTVastEventClickNotification];
//        [self addObserverForVastEvent:TVASTVastEventSkipNotification];
//        [self addObserverForVastEvent:TVASTVastEventCreativeViewNotification];
//        [self addObserverForVastEvent:TVASTVastEventLinearErrorNotification];
//        [self addObserverForVastEvent:TVASTVastEventMuteNotification];
//        [self addObserverForVastEvent:TVASTVastEventUnmuteNotification];
//        [self addObserverForVastEvent:TVASTVastEventResumeNotification];
//        [self addObserverForVastEvent:TVASTVastEventFullscreenNotification];
//        [self addObserverForVastEvent:TVASTVastEventExpandNotification];
//        [self addObserverForVastEvent:TVASTVastEventCollapseNotification];
//        [self addObserverForVastEvent:TVASTVastEventAcceptInvitationLinearNotification];
//        [self addObserverForVastEvent:TVASTVastEventAcceptInvitationNotification];
//        [self addObserverForVastEvent:TVASTVastEventCloseNotification];
//        [self addObserverForVastEvent:TVASTVastEventCloseLinearNotification];
        
        // Tell the adsManager to play the ad.
        [_videoAdsManager playWithAVPlayer:_adPlayer];
        _landscapeVC.view.hidden = NO;
        // use appropriate undeficated method based on the iOS version
        if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0f) {
            [self presentModalViewController:_landscapeVC animated:YES];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_adPlayer];
        } else {
            [self presentViewController:_landscapeVC animated:YES completion:^(){}];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_adPlayer];
        }
        // Show a few attributes of one of the loaded ads
        //TVASTAd *videoAd = [_videoAdsManager.ads objectAtIndex:0];
        //NSLog(@"Ad ID is %@", videoAd.adId);
        //NSLog(@"Ad Type is %d", videoAd.adType);
        //NSLog(@"Ad URL is %@", videoAd.mediaUrl);
       //NSLog(@"Ad Duration is %2f", videoAd.duration);
    }
}

//#pragma mark -
//#pragma mark Vast Event Notification implementation
//
//// Get VAST event notifications from the ads manager.
//- (void)didReceiveVastEvent:(NSNotification *)notification {
//    //NSLog(@"Received: %@\n", notification.name);
//}
//
//// Set the VAST event notification observer.
//- (void)addObserverForVastEvent:(NSString *)vastEvent {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(didReceiveVastEvent:)
//                                                 name:vastEvent
//                                               object:_videoAdsManager];
//}

// Set when ads loading failed.
- (void)adsLoader:(TVASTAdsLoader *)loader failedWithErrorData:(TVASTAdLoadingErrorData *)errorData {
    //NSLog(@"Encountered Error: code:%d,message:%@\n", errorData.adError.code, [errorData.adError localizedDescription]);
}

#pragma mark -
#pragma mark Initialize the ad player
- (void)setUpAdPlayer {
    self.adsLoader = [[TVASTAdsLoader alloc] init];
    _adsLoader.delegate = self;
    self.adPlayer = [[AVPlayer alloc] init];
    
    AVPlayerLayer *adPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_adPlayer];
    [adPlayerLayer setName:@"AdPlayerLayer"];
    
    // This is the setup for display the ad fullscreen landscape.  Your code can be different.
    /***/
    NSString *nibName = [NSString stringWithFormat:@"FullScreenVC_%@",
                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?@"iPad":@"iPhone"];
    self.landscapeVC = [[FullScreenVC alloc] initWithNibName:nibName bundle:nil];
    [_landscapeVC.view setHidden:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = CGRectMake(0, 0, CGRectGetHeight(window.frame), CGRectGetWidth(window.frame));
    adPlayerLayer.frame = frame;
    [_landscapeVC.view.layer addSublayer:adPlayerLayer];
    
    /***/
    
    // Create a click tracking view
    self.clickTrackingView = [[TVASTClickTrackingUIView alloc] initWithFrame:frame];
    [_clickTrackingView setDelegate:self];
    [_landscapeVC.view addSubview:_clickTrackingView];

}

- (IBAction)onRequestAds {
    [self requestAds];
}

/// Called when content should be paused. This usually happens right before a
/// an ad is about to cover the content.
- (void)contentPauseRequested:(TVASTVideoAdsManager *)adsManager {
    NSLog(@"Pause requested.");
}

/// Called when content should be resumed. This usually happens when ad ad
/// finishes or collapses.
- (void)contentResumeRequested:(TVASTVideoAdsManager *)adsManager {
    NSLog(@"Resume requested.");
    [_landscapeVC dismissModalViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark TVASTClickTrackingUIViewDelegate implementation

- (void)clickTrackingView:(TVASTClickTrackingUIView *)view didReceiveTouchEvent:(UIEvent *)event {
    NSLog(@"Ad view clicked.");
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {

}

#pragma mark -
#pragma mark TVASTClickThroughBrowserDelegate implementation

- (void)browserDidOpen {
    NSLog(@"In-app browser opened.\n");
}

- (void)browserDidClose {
    NSLog(@"In-app browser closed.\n");
}

- (void)dealloc
{
    [_clickTrackingView setDelegate:nil];
    [_clickTrackingView release];
    [_adsLoader release];
    [_adPlayer release];
    [_landscapeVC release];
    
    [super dealloc];
}

- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_adPlayer];
    
    [self.clickTrackingView removeFromSuperview];
    self.clickTrackingView.delegate = nil;
    self.clickTrackingView = nil;
    [self unloadAdsManager];
    self.adsLoader = nil;
    self.adPlayer = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0f)
        [self.landscapeVC dismissModalViewControllerAnimated:NO];
    else
        [self.landscapeVC dismissViewControllerAnimated:NO completion:^(){}];
    self.landscapeVC = nil;
    [super viewDidUnload];
}

//- (void)didReportAdError:(TVASTAdError *)error {
//    UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle:@"Error Loading Video" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//    [errorAlert show];
//}

@end
