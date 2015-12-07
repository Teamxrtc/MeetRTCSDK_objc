//
//  WebRTCStackConfig.m
//  xfinity-webrtc-sdk
//
//  Created by Pankaj on 26/08/14.
//  Copyright (c) 2014 Comcast. All rights reserved.
//

#import "WebRTCStackConfig.h"

@implementation WebRTCStackConfig


@synthesize wsToken = _wsToken;
@synthesize isChannelAPIEnable = _isChannelAPIEnable;
@synthesize serverURL = _serverURL;
@synthesize usingRTC20 = _usingRTC20;

//headers for create room http request
@synthesize trackingIdHeader = _trackingIdHeader;
@synthesize serverNameHeader = _serverNameHeader;
@synthesize clientNameHeader = _clientNameHeader;
@synthesize sourceIdHeader = _sourceIdHeader;
@synthesize deviceIdHeader = _deviceIdHeader;
- (id)initWithDefaultValue:(NSData*)token _serverURL:(NSString*)serverURL _portNumber:(NSInteger)portNumber _secure:(BOOL)secure  _statsURL:(NSString*)statsURL
{
    self = [super init];
    if (self!=nil) {
        
        _wsToken = token;
        _serverURL = serverURL;
        _portNumber = portNumber;
        _statsURL = statsURL;
        _isChannelAPIEnable = false;
        _isSecure = secure;
        _isNwSwitchEnable = false;
        _doManualDns = false;
	_usingRTC20 = false;
    }
    return self;
}

- (id)initRTCGWithDefaultValue:(NSData*)token _httpRequestURL:(NSString*)serverURL _userId:(NSString *)userId _statsURL:(NSString*)statsURL _usingRTC20:(BOOL)usingRTC20
{
    self = [super init];
    if (self!=nil) {
        
        _wsToken = token;
        _serverURL = serverURL;
        _statsURL = statsURL;
        _isChannelAPIEnable = !usingRTC20;
        _isNwSwitchEnable = false;
        _doManualDns = false;
        userId = [userId lowercaseString]; // US491798
        _usingRTC20 = usingRTC20;
        
        _trackingIdHeader = @"2971c7e0-e839-11e4"; //need to remove the hardcoded value
        _serverNameHeader = @"RTCGSM";
        _clientNameHeader = @"Mobile";
        _sourceIdHeader = @"PBA";
        _deviceIdHeader = @"2971c7e0-e839-11e40"; //need to remove the hardcoded value
            }
    
    return self;
}


@end
