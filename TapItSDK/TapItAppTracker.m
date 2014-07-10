//
//  TapItAppTracker.m
//  TapIt iOS SDK
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 TapIt!. All rights reserved.
//

#import "TapItPrivateConstants.h"
#import "TapItAppTracker.h"
#import "TapItAppTracker_Private.h"
#import "TapItOpenUDID.h"
#import "TapItReachability.h"
#import "TapItDefines.h"
//#import <MaaSCore/MaaSCore.h>
//#import "MaaSCoreLogger.h"
//#import "MaaSCore_Private.h"
//#import "MaaSCoreDevice_Private.h"

@interface TapItAppTracker ()
{
    //id<MaaSCoreLogger> _log;
}
    - (void)reportApplicationOpenInBackground;
@end

@implementation TapItAppTracker

+ (TapItAppTracker *)sharedAppTracker {
	static TapItAppTracker *sharedAppTracker;
	
	@synchronized(self)
	{
		if (!sharedAppTracker)
			sharedAppTracker = [[TapItAppTracker alloc] init];
		return sharedAppTracker;
	}
}

//-(id)init
//{
//    if(self = [super init])
//    {
//        [self commonSetup];
//    }
//    
//    return self;
//}
//
//- (void)commonSetup
//{
//    // Dependency checking
//    [self moduleDependencyCheck];
//    
//    _log = [MaaSCore loggerForService:[TapItAppTracker serviceName]];
//    
//    [MaaSCore registerModule:[TapItAppTracker serviceName]];
//    
//}
//
//- (void)moduleDependencyCheck
//{
//    BOOL dependencyOK = [MaaSCore coreDependencyCheck:kMaaSAdvertisingMaaSCoreVersionMinimum];
//    
//    NSString *assertionMessage = [NSString stringWithFormat:@"[MaaSAdvertising] Unable to load MaaSAdvertising. MaaSAdvertising has a dependency on MaaSCore v%@", kMaaSAdvertisingMaaSCoreVersionMinimum];
//    NSAssert(dependencyOK, assertionMessage);
//}

- (NSString *)deviceIFA {
#ifndef DISABLE_NEW_FEATURES
    NSString *identifier;
    
    Class clsIdManager = NSClassFromString(@"ASIdentifierManager");
    if(clsIdManager) {
        id idManager = [clsIdManager performSelector:@selector(sharedManager)];
        identifier = [[idManager performSelector:@selector(advertisingIdentifier)] UUIDString];
        return identifier;
    }
#endif
    return nil;
}

- (NSInteger)advertisingTrackingEnabled {
    NSInteger retval = -1; // data not available
#ifndef DISABLE_NEW_FEATURES
    Class clsIdManager = NSClassFromString(@"ASIdentifierManager");
    if(clsIdManager) {
        id idManager = [clsIdManager performSelector:@selector(sharedManager)];
        retval = (BOOL)[idManager performSelector:@selector(isAdvertisingTrackingEnabled)] ? 1 : 0; // 1 == enabled, 0 == disabled
    }
#endif
    return retval;
}

- (NSString *)deviceUDID {
    return [TapItOpenUDID value];
}

- (NSString *)userAgent {
	static NSString *userAgent = nil;
	
    if (!userAgent) {
		if(![NSThread isMainThread]){
			dispatch_sync(dispatch_get_main_queue(), ^{
				UIWebView *webview = [[UIWebView alloc] init];
				userAgent = [[webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] copy];
				[webview release];
			});
		}else{
			UIWebView *webview = [[UIWebView alloc] init];
			userAgent = [[webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] copy];
			[webview release];
		}
    }
    return userAgent;
}

- (void)reportApplicationOpen {
    [self performSelectorInBackground:@selector(reportApplicationOpenInBackground) withObject:nil];
    
}

- (NSString *)carrier {
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *c = [netinfo subscriberCellularProvider];
    NSString *cName = c.carrierName;
//    if (!cName) {
//        cName = @"unknown";
//    }
    [netinfo release];
    return cName;
}

- (NSString *)carrierId {
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *c = [netinfo subscriberCellularProvider];
    NSString *cNId = c.mobileNetworkCode;
    [netinfo release];
    return cNId;
}

- (CLLocation *)location {
    return nil;
}

/**
 0 - low speed network
 1 - Wifi network
 */
- (NSInteger)networkConnectionType {
    TapItReachability *reachability = [TapItReachability reachabilityForInternetConnection];
    return reachability.isReachableViaWiFi;
}

- (void)reportApplicationOpenInBackground {
    @autoreleasepool {
        NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *appInstalledLogPath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-installed.log",[[NSBundle mainBundle] bundleIdentifier]]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isNewInstall = ![fileManager fileExistsAtPath:appInstalledLogPath];

        if (isNewInstall){
            NSString *appId = [[NSBundle mainBundle] bundleIdentifier];
            NSString *udid = [self deviceUDID];
            NSString *ua = [self userAgent];
            NSString *deviceIFA = [self deviceIFA];
            
            NSMutableString *reportUrlString = [NSMutableString stringWithFormat:@"%@/adconvert.php?appid=%@&udid=%@",
                                                TAPIT_REPORTING_SERVER_URL,
                                                appId,
                                                udid
                                                ];
            if (ua && [ua length] > 0) {
                [reportUrlString appendFormat:@"&ua=%@",ua];
            }
            
            if (deviceIFA && [deviceIFA length] > 0) {
                [reportUrlString appendFormat:@"&ifa=%@", deviceIFA];
            }
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[reportUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

            unsigned int tries = 0;
            while (tries < 5) {
                NSURLResponse *response;
                NSError *error = nil;

                [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                if ((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200)) {
                    [fileManager createFileAtPath:appInstalledLogPath contents:nil attributes:nil];
                    
                    break;
                }
                
                sleep(10);
                tries++;
            }
        }
    } // end @autoreleasepool
}

//+ (NSString *)serviceName
//{
//    return @"MaaSAdvertising";
//}

@end
