//
//  WebRTCConsoleLogger.h
//  xfinity-webrtc-sdk
//
//  Created by Pankaj on 06/04/15.
//  Copyright (c) 2015 Comcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRTCLogging.h"

@interface WebRTCConsoleLogger : NSObject<WebRTCLogger>

+ (instancetype)sharedInstance;

@property(nonatomic,assign) id<WebRTCLogDelegate> delegate;

@end