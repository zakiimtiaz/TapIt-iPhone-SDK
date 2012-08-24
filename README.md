TapIt iOS SDK
=============

Version 2.0.1 (Beta)

This is the iOS SDK for the TapIt! mobile ad network.  Go to http://tapit.com/ for more details and to sign up.

***Cocos2d users go here: https://github.com/tapit/TapIt-iPhone-SDK/tree/master/cocos2d***


Get the code:
=============

This project includes JSONKit and Reachability as a git submodules.  Make sure you pull down submodules when cloning:

````
git clone --recursive https://github.com/tapit/TapIt-iPhone-SDK.git
````
-- or for older versions of git --
````
git clone https://github.com/tapit/TapIt-iPhone-SDK.git
git submodule init
git submodule update
````

Usage:
======
The TapIt! SDK's are distributed as source to minimise integration difficulties, and to increase transparency.  To install, simply copy the ```/Lib``` and ```/TapItSDK``` folders into your Xcode project.  The following frameworks are required:
````
SystemConfiguration.framework
QuartsCore.framework
CoreLocation.framework
CoreTelephony.framework
````

AdPrompt Usage
--------------
Alert ads are a simple ad unit designed to have a native feel.  The user is given the option to download an app, and if they accept, they are taken the app within the app store.

````objective-c
NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil]; // Alert ads only show in test mode during the beta...
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID" andCustomParameters:params];
TapItAlergAd *tapitAlertAd = [[TapItAlertAd alloc] initWithRequest:request];
// present as a UIAlertView
[tapitAlertAd showAsAlert];

// -- OR --

// alternatively present as a UIActionSheet
//[tapitAlertAd showAsActionSheet];
````

For a complete example, see https://github.com/tapit/TapIt-iPhone-SDK/blob/master/TapIt-iOS-Sample/AlertAdDemoController.m


Banner Usage
------------
````objective-c
@property (retain, nonatomic) TapItBannerAdView *tapitAd;

...

// if not passing in any params:
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID"];

// --OR--

// for test mode
NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"mode", nil];
TapItRequest *request = [TapItRequest requestWithAdZone:@"YOUR ZONE ID" andCustomParameters:params];

self.tapitAd.delegate = self; // notify me of the banner ad's state changes
[self.tapitAd startServingAdsForRequest:request];

...

// We don't want to show ads any more...
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
@property (retain, nonatomic) TapItInterstitialAd *interstitialAd;

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
