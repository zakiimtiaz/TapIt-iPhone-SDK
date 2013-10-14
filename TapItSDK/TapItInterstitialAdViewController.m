//
//  TapItInterstitialAdViewController.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/3/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "TapItInterstitialAdViewController.h"
#import "TapItBrowserController.h"
#import "TapItAdView.h"

@interface TapItInterstitialAdViewController ()
@end

@implementation TapItInterstitialAdViewController {
    UIActivityIndicatorView *loadingSpinner;
}

@synthesize animated, autoReposition, adView, tapitDelegate, closeButton, tappedURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.closeButton = nil;
        loadingSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [loadingSpinner sizeToFit];
        loadingSpinner.hidesWhenStopped = YES;
        self.autoReposition = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.adView setCenter:self.view.center];
    [self.view addSubview:(UIView *)self.adView];
    self.view.backgroundColor = [UIColor blackColor];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    // set status bar text to light so that it shows up against a black baground
    return UIStatusBarStyleLightContent;
}



- (void)showCloseButton {
    if (!self.closeButton) {
        
        UIImage *closeButtonBackground = [UIImage imageNamed:@"TapIt.bundle/interstitial_close_button.png"];
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.closeButton.imageView.contentMode = UIViewContentModeCenter;
        [self.closeButton setImage:closeButtonBackground forState:UIControlStateNormal];
        
        [self.closeButton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.adView.superview addSubview:self.closeButton];
        self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        CGRect appFrame = TapItApplicationFrame(TapItInterfaceOrientation());
        
        NSInteger y = 0;
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
            // push the close button down slightly to clear the statusbar
            y = 20;
        }
        
        self.closeButton.frame = CGRectMake(appFrame.size.width - 50, y, 50, 50);
    }
    
    [self.adView bringSubviewToFront:self.closeButton];
}

- (void)hideCloseButton {
    if (!self.closeButton) {
        return;
    }
    [self.closeButton removeFromSuperview];
    self.closeButton = nil;
}

- (void)closeTapped:(id)sender {
    id<TapItInterstitialAdDelegate> tDel = [self.tapitDelegate retain];
    [tDel tapitInterstitialAdActionWillFinish:nil];
    [self dismissViewControllerAnimated:self.animated completion:^{
        [tDel tapitInterstitialAdActionDidFinish:nil];
        [tDel tapitInterstitialAdDidUnload:nil];
        [tDel release];
    }];
}

- (void)viewDidUnload
{
    self.closeButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)showLoading {
    loadingSpinner.center = self.adView.center;
    [self.view addSubview:loadingSpinner];
    [loadingSpinner startAnimating];
}

- (void)hideLoading {
    [loadingSpinner stopAnimating];
    [loadingSpinner removeFromSuperview];
}



#pragma mark -
#pragma mark Orientation code

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self repositionToInterfaceOrientation:toInterfaceOrientation];
}

- (void)repositionToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (!self.autoReposition) {
        return;
    }
    
    CGRect frame = TapItApplicationFrame(orientation);

    CGFloat x = 0, y = 0;
    CGFloat w = self.adView.frame.size.width, h = self.adView.frame.size.height;
    
    x = frame.size.width/2 - self.adView.frame.size.width/2;
    y = frame.size.height/2 - self.adView.frame.size.height/2;
    
    if(self.adView.isMRAID) {
        x = 0;
        y = 0;
        NSString *reqSysVer = @"7.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        int extraRoom = 0;
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
            extraRoom = 20;
        }
        w = frame.size.width;
        h = frame.size.height+extraRoom;
    }
    
    self.adView.center = self.view.center;
    
    if(self.animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.adView setFrame:CGRectMake(x, y, w, h)];
        }
                         completion:^(BOOL finished){}
         ];
    }
    else {
        [self.adView setFrame:CGRectMake(x, y, w, h)];
    }
}


#pragma mark -

- (void)dealloc
{
    self.adView = nil;
    self.closeButton = nil;
    self.tappedURL = nil;
    [super dealloc];
}

@end
