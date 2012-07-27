//
//  TapItPopupAd.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapItAdDelegates.h"

@class TapItRequest;

@interface TapItDialogAd : NSObject <UIActionSheetDelegate>

@property (assign, nonatomic) id<TapItDialogAdDelegate> delegate;

- (id)initWithRequest:(TapItRequest *)request;

- (void)showAsAlert;
- (void)showAsActionSheet;

@end
