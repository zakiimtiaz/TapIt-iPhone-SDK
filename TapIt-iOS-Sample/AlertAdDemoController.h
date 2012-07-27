//
//  AlertAdDemoController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TapItAdDelegates.h"

@class TapItAlertAd;

@interface AlertAdDemoController : UIViewController <TapItAlertAdDelegate> {
    TapItAlertAd *tapitDialogAd;
}

//@property (retain, nonatomic) CLLocationManager *locationManager;

-(IBAction)showDialogAd:(id)sender;

@end
