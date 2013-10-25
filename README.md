TapIt iOS SDK
=============

Version 3.0.8

This is the iOS SDK for the TapIt! mobile ad network.  Go to http://tapit.com/ for more details and to sign up.


Usage:
------
To install, unzip the sdk archive(https://github.com/tapit/TapIt-iPhone-SDK/raw/master/dist/TapItSDK.zip) into your Xcode project.

The following frameworks are required:
````
SystemConfiguration.framework
QuartsCore.framework
CoreTelephony.framework
AdSupport.framework - enable support for IDFA
StoreKit.framework - enable use of SKStoreProductViewController, displays app store ads without leaving your app

CoreLocation.framework - Optional *
````
*Note: CoreLocation is optional, and is used for Geo-targeting ads.  Apple mandates that your app have a good reason for enabling Location services... Apple will deny your app if location is not a core feature for your app.

You're all set!

To build from source, follow these instructions:
https://github.com/tapit/TapIt-iPhone-SDK/raw/master/SOURCE.md


AdPrompt Usage
--------------
AdPrompts are a simple ad unit designed to have a native feel.  The user is given the option to download an app, and if they accept, they are taken to app store.

````objective-c
// in your .m file
#import "TapIt.h"
...
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
TapItAdPrompt *prompt = [[[TapItAdPrompt alloc] initWithRequest:request] autorelease];
[prompt showAsAlert];
````

For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/AdPromptDemoController.m



Banner Usage
------------
````objective-c
// in your .h file
@class TapItBannerAdView; // forward class declaration

@property (retain, nonatomic) TapItBannerAdView *tapitAd;

...

// in your .m file
#import "TapIt.h"
...
// init banner and add to your view
tapitAd = [[TapItBannerAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
[self.view addSubview:self.tapitAd];

// kick off banner rotation!
[self.tapitAd startServingAdsForRequest:[TapItRequest requestWithAdZone:@"YOUR ZONE ID"]];

...

// We don't want to show ads any more...
[self.tapitAd hide];
[self.tapitAd cancelAds];
````

For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/BannerAdController.m


Listen for location updates
---------------------------
If you want to allow for geo-targeting, listen for location updates:
````objective-c
@property (retain, nonatomic) CLLocationManager *locationManager;

...

// start listening for location updates
self.locationManager = [[CLLocationManager alloc] init];
self.locationManager.delegate = self;
[self.locationManager startMonitoringSignificantLocationChanges];

...

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // Notify the TapIt! banner when the location changes.  New location will be used the next time an ad is requested
    [self.tapitAd updateLocation:newLocation];
}

...

// Stop monitoring location when done to conserve battery life
[self.locationManager stopMonitoringSignificantLocationChanges];
````



Interstitial Usage
------------------
Show modally
````objective-c
// in your .h file
@class TapItInterstitialAd; // forward class declaration
...
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

...

// in your .m file
#import "TapIt.h"
...
// init and load interstitial
self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
self.interstitialAd.delegate = self; // notify me of the interstitial's state changes
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
[self.interstitialAd loadInterstitialForRequest:request];

...

- (void)tapitInterstitialAdDidLoad:(TapItInterstitialAd *)interstitialAd {
    // Ad is ready for display... show it!
    [self.interstitialAd presentFromViewController:self];
}
````
For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/InterstitialController.m

Include in paged navigation
    
````objective-c
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

...

// init and load interstitial
self.interstitialAd = [[[TapItInterstitialAd alloc] init] autorelease];
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];
[self.interstitialAd loadInterstitialForRequest:request];

...

// if interstitial is ready, show
if( self.interstitialAd.isLoaded ) {
    [self.interstitialAd presentInView:self.view];
}
````



Delegate Callbacks
------------------
TapIt! ad units follow the delegate pattern to notify your app of state changes.  For details on the delegate methods called by the TapIt! iOS SDK, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapItSDK/Headers/TapItAdDelegates.h



Video Ads Usage
----------------

For sample video ads integration code, please see the VideoAdController.m and VideoAdController.h
files for working example of video ads in an app.  You can find VideoAdController in the 
TapIt-iOS-Sample directory of the iOS SDK package.

In requesting for a video ad from the server, a VASTAdsRequest object needs to be instantiated 
and its zoneId and videotype parameters specified.  These parameters are required for a successful
retrieval of the ad.  The value of the videotype parameter must match the "type" of the video ad 
for which the request is making.  Available types are "all", "pre-roll", "mid-roll", and "post-roll"
and they have to be literally matched. Please see example code below.


    // Create an adsRequest object and request ads from the ad server with your own zone_id
    TVASTAdsRequest *request = [TVASTAdsRequest requestWithAdZone: ZONE_ID_VIDEO];
    [request setCustomParameter:@"pre-roll" forKey:@"videotype"];
    [_adsLoader requestAdsWithRequestObject:request];



Essentially, what needs to be included in the code are as follows:
Note: the following uses Automatic Reference Counting so there will not be any object releases shown.

````objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

	//
	// Other initializations here.
	//

    [self setUpAdsLoader];
    [self setUpAdPlayer];
    
    NSLog(@"SDK Version: %@", [TVASTAd getSDKVersionString]);
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //
    // Clean up video ads here.
    //
    
    [self.adPlayer pause];
    [self.clickTrackingView removeFromSuperview];
    self.clickTrackingView.delegate = nil;
    self.clickTrackingView = nil;
    [self unloadAdsManager];
    self.adsLoader = nil;
    self.adPlayer = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0f)
        [self.landscapeAdVC dismissModalViewControllerAnimated:NO];
    else
        [self.landscapeAdVC dismissViewControllerAnimated:NO completion:^(){}];
    self.landscapeAdVC = nil;

    [super viewDidUnload];
}


#pragma mark -
#pragma mark Initialize the ad player
- (void)setUpAdPlayer {
    self.adPlayer = [[AVPlayer alloc] init];
    
    AVPlayerLayer *adPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_adPlayer];
    [adPlayerLayer setName:@"AdPlayerLayer"];

	// This is the setup for display the ad fullscreen landscape.  You code can be different.    
    /***/
    NSString *nibName = [NSString stringWithFormat:@"FullScreenVC_%@",
                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?@"iPad":@"iPhone"];
    self.landscapeAdVC = [[FullScreenVC alloc] initWithNibName:nibName bundle:nil];
    [_landscapeAdVC.view setHidden:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = CGRectMake(0, 0, CGRectGetHeight(window.frame), CGRectGetWidth(window.frame));
    adPlayerLayer.frame = frame;
    [_landscapeAdVC.view.layer addSublayer:adPlayerLayer];
    
    /***/
    
    // Create a click tracking view
    self.clickTrackingView = [[TVASTClickTrackingUIView alloc] initWithFrame:frame];
    [_clickTrackingView setDelegate:self];
    [_landscapeAdVC.view addSubview:_clickTrackingView];
    
    // preload a video ad.
    [self requestAds];
}

// set up an ads loader with callbacks delegate.
- (void)setUpAdsLoader {
    self.adsLoader = [[TVASTAdsLoader alloc] init];
    _adsLoader.delegate = self;
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
    TVASTAdsRequest *request = [TVASTAdsRequest requestWithAdZone: ZONE_ID_VIDEO];
    [request setCustomParameter:@"pre-roll" forKey:@"videotype"];
    [_adsLoader requestAdsWithRequestObject:request];
}

#pragma mark -
#pragma mark Vast Event Notification implementation

// Get VAST event notifications from the ads manager.
- (void)didReceiveVastEvent:(NSNotification *)notification {
    NSLog(@"Received: %@\n", notification.name);
}

// Set the VAST event notification observer.
- (void)addObserverForVastEvent:(NSString *)vastEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveVastEvent:)
                                                 name:vastEvent
                                               object:_videoAdsManager];
}

#pragma mark -
#pragma mark TVASTClickTrackingUIViewDelegate implementation

- (void)clickTrackingView:(TVASTClickTrackingUIView *)view didReceiveTouchEvent:(UIEvent *)event {
    NSLog(@"Ad view clicked on.\n");
}

#pragma mark -
#pragma mark TVASTAdsLoaderDelegate implementation

// Sent when ads are successfully loaded from the ad servers
- (void)adsLoader:(TVASTAdsLoader *)loader adsLoadedWithData:(TVASTAdsLoadedData *)adsLoadedData {
    NSLog(@"Ads have been loaded.\n");
    
    TVASTVideoAdsManager *adsManager = adsLoadedData.adsManager;
    
    if (adsManager) {
        self.videoAdsManager = adsManager;
        // Set delegate to receive callbacks.
        _videoAdsManager.delegate = self;
        // Set the click tracking view.
        _videoAdsManager.clickTrackingView = _clickTrackingView;
        
        // use in-app browser for view ad's destination url.
        [TVASTClickThroughBrowser enableInAppBrowserWithViewController:nil delegate:self];
        // or use mobile safari to view ad's destination url.
        //[TVASTClickThroughBrowser disableInAppBrowser];
        
        // set show ad full-screen or not.
        _videoAdsManager.showFullScreenAd = YES;
        
        // Add notification observer for all VAST events.
        [self addObserverForVastEvent:TVASTVastEventStartNotification];
        [self addObserverForVastEvent:TVASTVastEventFirstQuartileNotification];
        [self addObserverForVastEvent:TVASTVastEventMidpointNotification];
        [self addObserverForVastEvent:TVASTVastEventThirdQuartileNotification];
        [self addObserverForVastEvent:TVASTVastEventCompleteNotification];
        [self addObserverForVastEvent:TVASTVastEventClickNotification];
        [self addObserverForVastEvent:TVASTVastEventLinearErrorNotification];
		//.... and other VAST tracking events you wish to track.

        // Show a few attributes of one of the loaded ads
        TVASTAd *videoAd = [_videoAdsManager.ads objectAtIndex:0];
        NSLog(@"VideoAdId: %@\n", videoAd.adId);
        NSLog(@"VideoAdUrl: %@\n", videoAd.mediaUrl);
        NSLog(@"VideoAdDuration: %f\n", videoAd.duration);
        NSLog(@"VideoAdHeight: %f\n", videoAd.creativeHeight);
        NSLog(@"VideoAdWidth: %f\n", videoAd.creativeWidth);
    }
}

// Set when ads loading failed.
- (void)adsLoader:(TVASTAdsLoader *)loader failedWithErrorData:(TVASTAdLoadingErrorData *)errorData {
    NSLog(@"Encountered Error: code:%d,message:%@\n", errorData.adError.code,
     [errorData.adError localizedDescription]);
}

#pragma mark -
#pragma mark TVASTClickThroughBrowserDelegate implementation

- (void)browserDidOpen {
    NSLog(@"In-app browser opened.\n");
}

- (void)browserDidClose {
    NSLog(@"In-app browser closed.\n");
}

#pragma mark -
#pragma mark TVASTVideoAdsManagerDelegate implementation

// Called when content should be paused. This usually happens right before a
// an ad is about to cover the content.
- (void)contentResumeRequested:(TVASTVideoAdsManager *)adsManager {
    [self logMessage:@"Content resume requested.\n"];
    
    // first, pause the ad player
    [_adPlayer pause];

    [_landscapeAdVC dismissViewControllerAnimated:YES completion:^(){}];
    [_landscapeAdVC.view setHidden:YES];
    
    //
	// Code here to resume your game here
	//
    
    [self setUpAdPlayer];
}

// Called when content should be resumed. This usually happens when an ad
// finishes or collapses.
- (void)contentPauseRequested:(TVASTVideoAdsManager *)adsManager {
    [self logMessage:@"Content pause requested.\n"];
    
    _landscapeAdVC.view.hidden = NO;
    // use appropriate undeficated method based on the iOS version
    if ([[UIDevice currentDevice].systemVersion floatValue] < 5.0f)
        [self presentModalViewController:_landscapeAdVC animated:YES];
    else
        [self presentViewController:_landscapeAdVC animated:YES completion:^(){}];
    
    //
	// Code here to pause your game here
	//

}

- (void)didReportAdError:(TVASTAdError *)error {
    NSLog(@"Error encountered while playing:%@\n.",
                      [error localizedDescription]);
}
````
