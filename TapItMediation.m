//
//  TapItMediation.m
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/17/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "TapItMediation.h"
#import "GADAdSize.h"
#import "GADCustomEventRequest.h"

@implementation TapItMediation

@synthesize delegate;

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request  {
    NSLog(@"00000000000000000000: %@", serverParameter);
    // TODO: Use the parameters and self.delegate to make a banner request to your
    // ad network. Remember to set this class to be your banner’s delegate.
}
@end
