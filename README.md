TapIt iOS SDK
=============

Version 3.0.10

This is the iOS SDK for the TapIt! mobile ad network.  Go to http://tapit.com/ for more details and to sign up.


Usage:
------
To install, unzip the sdk archive(https://github.com/tapit/TapIt-iPhone-SDK/raw/master/dist/TapItSDK.zip) into your Xcode project.

The following frameworks are required:
````
SystemConfiguration.framework
QuartsCore.framework
CoreTelephony.framework
MessageUI.framework
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
TapIt! ad units follow the delegate pattern to notify your app of state changes.



Video Ads Usage
----------------

For sample video ads integration code, please see the VideoInterstitialViewController.m and VideoInterstitialViewController.m
files for working example of video ads in an app.  You can find VideoInterstitialViewController in the 
TapIt-iOS-Sample directory of the iOS SDK package.

In requesting for a video ad from the server, a TVASTAdsRequest object needs to be instantiated 
and its zoneId parameter specified.  This parameter is required for a successful
retrieval of the ad.  
    
    // Create an adsRequest object and request ads from the ad server with your own kZoneIdVideo
    TVASTAdsRequest *request = [TVASTAdsRequest requestWithAdZone:kZoneIdVideo;
    [_videoAd requestAdsWithRequestObject:request];

If you want to specify the type of video ad you are requesting, use the call below.  
    
    TVASTAdsRequest *request = [TVASTAdsRequest requestWithAdZone:kZoneIdVideo];
    [_videoAd requestAdsWithRequestObject:request andVideoType:TapItVideoTypeMidroll];
    
Essentially, what needs to be included in the code is as follows:
Note: the following uses Automatic Reference Counting so there will not be any object releases shown.

````objective-c
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
````
