//
//  WebRTCStackConfig.h
//  xfinity-webrtc-sdk
//
//  Created by Pankaj on 26/08/14.
//  Copyright (c) 2014 Comcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SignalHandler;

@interface WebRTCStackConfig : NSObject

@property (nonatomic) NSData *wsToken;
@property (nonatomic) NSString *serverURL;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *userName;

@property (nonatomic) NSInteger portNumber;
@property (nonatomic) BOOL isChannelAPIEnable;
@property (nonatomic) BOOL isSecure;
@property (nonatomic) NSString *statsURL;
@property (nonatomic) BOOL DtlsOn;
@property (nonatomic) BOOL isNwSwitchEnable;
@property (nonatomic) BOOL doManualDns;
@property (nonatomic) NSString *userId;


//RTC-2.0
@property (nonatomic) BOOL usingRTC20;
//create room request http headers
@property (nonatomic) NSString* trackingIdHeader;
@property (nonatomic) NSString* serverNameHeader;
@property (nonatomic) NSString* clientNameHeader;
@property (nonatomic) NSString* sourceIdHeader;
@property (nonatomic) NSString* deviceIdHeader;- (id)initWithDefaultValue:(NSData*)token _serverURL:(NSString*)serverURL _portNumber:(NSInteger)portNumber _secure:(BOOL)secure _statsURL:(NSString*)statsURL;
- (id)initRTCGWithDefaultValue:(NSData*)token _httpRequestURL:(NSString*)serverURL _userId:(NSString *)userId _statsURL:(NSString*)statsURL _usingRTC20:(BOOL)usingRTC20;


@end
