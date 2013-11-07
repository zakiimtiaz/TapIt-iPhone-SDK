//
//  FirstViewController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TapItBannerAdView.h"

@interface BannerAdController : UIViewController <TapItBannerAdViewDelegate>

@property (retain, nonatomic) IBOutlet TapItBannerAdView *tapitAd;

@end
