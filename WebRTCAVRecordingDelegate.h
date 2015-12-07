//
//  WebRTCRecordingDelegate.m
//  xfinity-webrtc-sdk
//
//  Created by Gupta, Harish (Contractor) on 5/13/15.
//  Copyright (c) 2015 Comcast. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    WebRTCAVRecordingStarted,
    WebRTCAVRecordingEnded,
    WebRTCAVRecordingWarning,
} RecordingEventTypes;

extern NSString * const WebRTCRecordEventKey;
extern NSString * const WebRTCRecordEventDetailKey;

@protocol WebRTCAVRecordingDelegate <NSObject>
/** Recording state consist:
 *  Event: Type of event, e.g. WebRTCAVRecordingStarted
 *  Event Description: Reason for the event.
 **/
- (void) onRecordingEvent:(NSDictionary *)state;
- (void) onRecordingError:(NSString*)error errorCode:(NSInteger)code;
@end