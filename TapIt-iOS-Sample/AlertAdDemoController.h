//
//  AlertAdDemoController.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TapItAdDelegates.h"

@class TapItDialogAd;

@interface AlertAdDemoController : UIViewController <TapItDialogAdDelegate> {
    TapItDialogAd *tapitDialogAd;
}

//@property (retain, nonatomic) CLLocationManager *locationManager;

-(IBAction)showDialogAd:(id)sender;

@end
