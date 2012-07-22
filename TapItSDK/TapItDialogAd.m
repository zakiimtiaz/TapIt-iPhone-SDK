//
//  TapItPopupAd.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapItPrivateConstants.h"
#import "TapItDialogAd.h"
#import "TapItAdManager.h"
#import "TapItAdBrowserController.h"
#import "TapItRequest.h"


@interface TapItDialogAd () <TapItAdManagerDelegate, TapItAdBrowserControllerDelegate> {
    BOOL isAlertType;
}
@property (retain, nonatomic) TapItRequest *adRequest;
@property (retain, nonatomic) TapItAdManager *adManager;
@property (retain, nonatomic) NSString *clickUrl;

- (void)performRequest;
- (void)displayAlertWithData:(NSDictionary *)data;
- (void)displayActionSheetWithData:(NSDictionary *)data;
- (void)performAdAction;
@end

@implementation TapItDialogAd

@synthesize delegate, adRequest, adManager, clickUrl;

- (id)initWithRequest:(TapItRequest *)request {
    self = [super init];
    if (self) {
        self.adManager = [[[TapItAdManager alloc] init] autorelease];
        self.adManager.delegate = self;
        self.adRequest = request;
    }
    return self;
}

#pragma mark -
#pragma mark DialogAd Methods

- (void)showAsAlert {
    isAlertType = YES;
    [self performRequest];
}

- (void)displayAlertWithData:(NSDictionary *)data {
    NSString *title = [data objectForKey:@"title"];
    NSString *callToAction = [data objectForKey:@"calltoaction"];
    NSString *declineString = [data objectForKey:@"declinestring"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:title 
                                                   delegate:self 
                                          cancelButtonTitle:declineString
                                          otherButtonTitles:callToAction, nil];
    [alert show];
    [alert release];
}

- (void)showAsActionSheet {
    isAlertType = NO;
    [self performRequest];
}

- (void)displayActionSheetWithData:(NSDictionary *)data {
    NSString *title = [data objectForKey:@"title"];
    NSString *callToAction = [data objectForKey:@"calltoaction"];
    NSString *declineString = [data objectForKey:@"declinestring"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                    delegate:self 
                                           cancelButtonTitle:nil 
                                      destructiveButtonTitle:nil 
                                           otherButtonTitles:callToAction, declineString, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"UIAlertView: dismissed with button: %d", buttonIndex);
    if (buttonIndex == 1) { // second button is the call to action...
        [self performAdAction];
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapitDialogWasDeclined:)]) {
            [self.delegate tapitDialogWasDeclined:self];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"UIActionSheet: dismissed with button: %d", buttonIndex);
    if (buttonIndex == 0) { // top button is the call to action...
        [self performAdAction];
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapitDialogWasDeclined:)]) {
            [self.delegate tapitDialogWasDeclined:self];
        }
    }
}

- (void)performRequest {
    [self.adRequest setCustomParameter:TAPIT_AD_TYPE_DIALOG forKey:@"adtype"];
    [self.adManager fireAdRequest:self.adRequest];
}

- (void)performAdAction {
    NSLog(@"Performing Action!!!");
    [self openURLInFullscreenBrowser:[NSURL URLWithString:self.clickUrl]];
}

#pragma mark -
#pragma mark TapItAdBrowserController Delegate methods

- (void)openURLInFullscreenBrowser:(NSURL *)url {
    // Present ad browser.
    TapItAdBrowserController *browserController = [[TapItAdBrowserController alloc] initWithURL:url delegate:self];
    UIViewController *theDelegate = (UIViewController *)self.delegate; //TODO probably a bad assumption...
    if (theDelegate) {
        [theDelegate presentModalViewController:browserController animated:YES];
    }
    [browserController release];
}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController {
    [self dismissBrowserController:browserController animated:YES];
}

- (void)dismissBrowserController:(TapItAdBrowserController *)browserController animated:(BOOL)isAnimated {
    [browserController dismissModalViewControllerAnimated:YES];
	[self.delegate tapitDialogAdActionDidFinish:self];
}

#pragma mark -
#pragma mark TapItAdManager Delegate methods

- (void)willLoadAdWithRequest:(TapItRequest *)request {
    
}

- (void)didLoadAdView:(TapItAdView *)adView {
    // noop
}

- (void)adView:(TapItAdView *)adView didFailToReceiveAdWithError:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(tapitDialogAd:didFailWithError:)]) {
        [self.delegate tapitDialogAd:self didFailWithError:error];
    }
}

- (BOOL)adActionShouldBegin:(NSURL *)actionUrl willLeaveApplication:(BOOL)willLeave {
    if ([self.delegate respondsToSelector:@selector(tapitDialogAdActionShouldBegin:willLeaveApplication:)]) {
        return [self.delegate tapitDialogAdActionShouldBegin:self willLeaveApplication:willLeave];
    }
    return YES;
}

- (void)adViewActionDidFinish:(TapItAdView *)adView {
    if ([self.delegate respondsToSelector:@selector(tapitDialogAdActionDidFinish:)]) {
        [self.delegate tapitDialogAdActionDidFinish:self];
    }    
}

- (void)didReceiveData:(NSDictionary *)data {
    NSLog(@"Received data: %@", data);
    self.clickUrl = [data objectForKey:@"clickurl"];
    if (isAlertType) {
        [self displayAlertWithData:data];
    }
    else {
        [self displayActionSheetWithData:data];
    }
    
    if ([self.delegate respondsToSelector:@selector(tapitDialogAdDidLoad:)]) {
        [self.delegate tapitDialogAdDidLoad:self];
    }    
}

#pragma mark -

- (void)dealloc {
    self.delegate = nil;
    self.adRequest = nil;
    self.adManager = nil;
    self.clickUrl = nil;
    [super dealloc];
}
@end
