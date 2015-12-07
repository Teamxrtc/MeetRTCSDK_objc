//
//  WebRTCFactory.h
//  XfinityVideoShare
//
//  Created by Ganvir, Manish (Contractor) on 5/29/14.
//  Copyright (c) 2014 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCPeerConnectionFactory.h"

@interface WebRTCFactory : NSObject

// Call this to get access to the factory
+ (RTCPeerConnectionFactory *)getPeerConnectionFactory;

// Call this to shutdown the factory
+ (void)DestroyPeerConnectionFactory;
@end
