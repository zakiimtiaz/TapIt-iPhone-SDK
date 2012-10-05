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

@class TapItAdPrompt;

@interface AdPromptDemoController : UIViewController <TapItAdPromptDelegate> {
    TapItAdPrompt *tapitAdPrompt;
}

//@property (retain, nonatomic) CLLocationManager *locationManager;

@property (retain, nonatomic) IBOutlet UIButton *preloadButton;

-(IBAction)preLoadAdPrompt:(id)sender;
-(IBAction)showAdPrompt:(id)sender;

@end
