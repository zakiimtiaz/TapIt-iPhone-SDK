//
//  AdPromptDemoController
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "AppDelegate.h"
#import "AdPromptDemoController.h"
#import "TapIt.h"
#import "TapItAdPrompt.h"

// This is the zone id for the AdPrompt Example
// go to http://ads.tapit.com/ to get your's
#define ZONE_ID @"7980"


@interface AdPromptDemoController ()

@end

@implementation AdPromptDemoController

@synthesize preloadButton;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
//    [self simpleExample];
    
}

#pragma mark -
#pragma mark TapItAdPrompt Example code
- (void)simpleExample:(id)sender {
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID];
    TapItAdPrompt *prompt = [[[TapItAdPrompt alloc] initWithRequest:request] autorelease];
    [prompt showAsAlert];
}


- (void)loadAdPrompt {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"test", @"mode", // enable test mode to test AdPrompts in your app
                            nil];
    TapItRequest *request = [TapItRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    AppDelegate *myAppDelegate = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [request updateLocation:myAppDelegate.locationManager.location];
    tapitAdPrompt = [[TapItAdPrompt alloc] initWithRequest:request];
    tapitAdPrompt.delegate = self;

    tapitAdPrompt.showLoadingOverlay = YES;
}

- (IBAction)preLoadAdPrompt:(id)sender {
    [self loadAdPrompt];
    [tapitAdPrompt load];
}

- (IBAction)showAdPrompt:(id)sender {
    if (!tapitAdPrompt) {
        [self loadAdPrompt];
    }
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        //[tapitAdPrompt showAsActionSheet];
    }
    else {
        [tapitAdPrompt showAsAlert];
    }
}

- (void)tapitAdPrompt:(TapItAdPrompt *)adPrompt didFailWithError:(NSError *)error {
    NSLog(@"Error showing AdPrompt: %@", error);
    [self cleanupAdPrompt];
}

- (void)tapitAdPromptWasDeclined:(TapItAdPrompt *)adPrompt {
    NSLog(@"AdPrompt was DECLINED!");
    [self cleanupAdPrompt];
}

- (void)tapitAdPromptDidLoad:(TapItAdPrompt *)adPrompt {
    NSLog(@"AdPrompt loaded!");
    self.preloadButton.enabled = NO;
}

- (void)tapitAdPromptWasDisplayed:(TapItAdPrompt *)adPrompt {
    NSLog(@"AdPrompt displayed!");
}

- (BOOL)tapitAdPromptActionShouldBegin:(TapItAdPrompt *)adPrompt willLeaveApplication:(BOOL)willLeave {
    NSString *strWillLeave = willLeave ? @"Leaving app" : @"loading internally";
    NSLog(@"AdPrompt was accepted, loading app/advertisement... %@", strWillLeave);
    return YES;
}

- (void)tapitAdPromptActionDidFinish:(TapItAdPrompt *)adPrompt {
    NSLog(@"AdPrompt Action finished!");
    [self cleanupAdPrompt];
}


- (void)cleanupAdPrompt {
    [tapitAdPrompt release]; tapitAdPrompt = nil;
    self.preloadButton.enabled = YES;
}

#pragma mark -

- (void)dealloc {
    [self cleanupAdPrompt];
    [super dealloc];
}

@end
