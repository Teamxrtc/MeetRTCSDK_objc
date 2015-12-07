//
//  WebRTCChannel.h
//  xfinity-webrtc-sdk
//
//  Created by Pankaj on 03/07/14.
//  Copyright (c) 2014 Comcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    init,
    createSent,
    created,
    openSent,
    chnlopen,
    chnlclosed,
    disconnected,
    reconnecting
}channelState;

@protocol WebRTCChannelDelegate <NSObject>

- (void) onChannelOpened;
- (void) onChannelClosed;
- (void) onChannelAck:(NSString *)sessionId;
- (void) onChannelMessage:(NSDictionary*) msg;
- (void) sendChannelRTCMessage:(NSDictionary*) msg;
- (void) onChannelError:(NSString*)error errorCode:(NSInteger)code;
@end

@interface WebRTCChannel : NSObject


@property(nonatomic,assign) id<WebRTCChannelDelegate> delegate;

- (id)initWithDefaultValue:(NSString*)clientSessionId instanceId:(NSString*)deviceId target:(NSString*)to source:(NSString*)from eligibilityToken:(NSDictionary*)token appID:(NSString*)sType STBID:(NSString*)STBID;
- (id)initAfterChannelCreationValue:(NSString*)clientSessionId rtcgSessionId:(NSString*)rtcgSessionId instanceId:(NSString*)deviceId target:(NSString*)to source:(NSString*)from;
-(void)closeInUnlessAtState:(channelState)goalState;
-(void)startStateCheckTime;
-(void)sendCreate;
-(void)sendOpen;
-(void)sendReconnect;
-(void)sendClose;
-(void)sendChannelMessage:(NSDictionary*) payload;
-(void)onChannelCreated:(NSDictionary*) msg;
-(void)onChannelCreatedAck:(NSDictionary*) msg;
-(void)onChannelOpened:(id) msg;
-(void)onChannelOpenedAck:(NSDictionary*) msg;
-(void)onChannelMessage:(NSDictionary*) msg;
-(void)onChannelClosed:(NSDictionary*) msg;
-(void)onChannelClosedAck:(NSDictionary*) msg;
-(void)handleChannelEvent:(NSDictionary*) msg;
-(void)sendSessionMessage:(NSDictionary*) msg;
-(void)onChannelCreateFailed:(NSDictionary*)msg;
-(void)onChannelReconnectAck:(NSDictionary*)msg;
@end
