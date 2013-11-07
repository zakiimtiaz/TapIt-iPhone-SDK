//
//  TapItAppTracker__Private.h
//  TapIt iOS SDK
//
//  Created by Carl Zornes on 10/23/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface TapItAppTracker ()

- (NSString *)deviceIFA;
- (NSInteger)advertisingTrackingEnabled;
- (NSString *)deviceUDID;
- (NSString *)userAgent;
- (CLLocation *)location;
- (NSInteger)networkConnectionType;
- (NSString *)carrier;
- (NSString *)carrierId;

@end
