    //
//  WebRTCFactory.m
//  XfinityVideoShare
//
//  Created by Ganvir, Manish (Contractor) on 5/29/14.
//  Copyright (c) 2014 Infosys. All rights reserved.
//

#import "WebRTCFactory.h"
#import "RTCPeerConnectionFactory.h"

@implementation WebRTCFactory

// Shared factory for all the classes
static RTCPeerConnectionFactory *FactoryInstance = nil;

+ (RTCPeerConnectionFactory *)getPeerConnectionFactory{
    
    if (FactoryInstance == nil)
    {
        FactoryInstance = [[RTCPeerConnectionFactory alloc] init];
        [RTCPeerConnectionFactory initializeSSL];
    }
    return FactoryInstance;
}

+ (void)DestroyPeerConnectionFactory
{
    if (FactoryInstance != nil)
    {
        [RTCPeerConnectionFactory deinitializeSSL];
        FactoryInstance = nil;
    }
}



@end
