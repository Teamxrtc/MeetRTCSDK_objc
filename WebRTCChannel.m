//
//  WebRTCChannel.m
//  xfinity-webrtc-sdk
//
//  Created by Pankaj on 03/07/14.
//  Copyright (c) 2014 Comcast. All rights reserved.
//

#import "WebRTCChannel.h"
#import "WebRTCError.h"
#import "WebRTCLogHandler.h"
#import "WebRTCLogging.h"
#define CHANNEL_STATECHNG_TIMEOUT 60

@interface WebRTCChannel()
@property (nonatomic) channelState state;
@property (nonatomic) NSString *instanceId;
@property (nonatomic) NSString *rtcgSessionId;
@property (nonatomic) NSString *clientSessionId;
@property (nonatomic) NSString *from;
@property (nonatomic) NSString *to;
@property (nonatomic) NSInteger MessageId;
@property (nonatomic) NSString *callbackUrl;
@property (nonatomic) NSMutableArray *targets;
@property (nonatomic) NSString *eligibilityToken;
@property (nonatomic) NSString *sessionType;
@property (nonatomic) NSString *STBID;

@end


@implementation WebRTCChannel

NSString* const TAG2 = @"WebRTCChannel";

//- (id)initWithDefaultValue:(NSString*)clientSessionId instanceId:(NSString*)deviceId target:(NSString*)to source:(NSString*)from eligibilityToken:(NSDictionary*)token appID:(NSString *)sType STBID:(NSString*)STBID
//{
//    self = [super init];
//    if(self!=nil){
//    _clientSessionId = clientSessionId;
//    _to = to;
//    _from = from;
//    _eligibilityToken = token;
//    _instanceId = deviceId;
//    _callbackUrl = @"";
//    _rtcgSessionId = @"";
//    _targets = nil;
//    _sessionType = sType;
//    _STBID = STBID;
//    //[self sendCreate];
//    [self startStateCheckTime];
//       
//    }
//    _MessageId = 1;
//    return self;
//    
//}


//- (id)initAfterChannelCreationValue:(NSString*)clientSessionId rtcgSessionId:(NSString*)rtcgSessionId instanceId:(NSString*)deviceId target:(NSString*)to source:(NSString*)from
//{
//    self = [super init];
//    if(self!=nil){
//        _clientSessionId = clientSessionId;
//        _rtcgSessionId = rtcgSessionId;
//        _instanceId = deviceId;
//        _to = to;
//        _from = from;
//        //[self sendCreate];
//        [self startStateCheckTime];
//    }
//    
//    return self;
//}

//-(void)closeInUnlessAtState:(channelState)goalState
//{
//    if(_state ==goalState)
//    {
//        LogDebug(@"In goal state .... ");
//    }
//    else
//    {
//        //_state = chnlclosed;
//        //[self.delegate onChannelClosed];
//    }
//}

//-(void)startStateCheckTime
//{
//     NSTimer *_icetimer;
//    _icetimer = [NSTimer scheduledTimerWithTimeInterval:CHANNEL_STATECHNG_TIMEOUT
//                                                 target:self
//                                               selector:@selector(closeInUnlessAtState:)
//                                               userInfo:nil
//                                                repeats:NO
//                 ];
//}

//-(void) sendCreate
//{
//    NSMutableDictionary* reqCreateChannelD = [[NSMutableDictionary alloc]init];
//
//    //NSDictionary *reqCreateChannelD = @{ @"type" : @"createChannel" };
//    [reqCreateChannelD setValue:@"createChannel" forKey:@"type"];
//    [reqCreateChannelD setValue:[NSNumber numberWithInteger:_MessageId] forKey:@"messageId"];
//    [reqCreateChannelD setValue:_instanceId forKey:@"instanceId"];
//    [reqCreateChannelD setValue:_sessionType forKey:@"sType"];
//    [reqCreateChannelD setValue:_STBID forKey:@"STBID"];
//
//    if(_eligibilityToken != nil)
//    {
//        [reqCreateChannelD setValue:_eligibilityToken forKey:@"channelToken"];
//    }
//    _MessageId++;
//    
//   
//    [self.delegate sendChannelRTCMessage: reqCreateChannelD];
//    _state = createSent;
//}

//-(void) sendOpen
//{
//    NSMutableDictionary* reqChannelOpenD = [[NSMutableDictionary alloc]init];
//
//    //NSDictionary *reqChannelOpenD = @{ @"type" : @"openChannel",
//    //                                   @"_rtcgSessionId" : _rtcgSessionId
//    //                                   };
//    if (_MessageId == 0)
//        _MessageId = 2;
//    [reqChannelOpenD setValue:@"openChannel" forKey:@"type"];
//    [reqChannelOpenD setValue:_rtcgSessionId forKey:@"rtcgSessionId"];
//    [reqChannelOpenD setValue:[NSNumber numberWithInteger:_MessageId] forKey:@"messageId"];
//    [reqChannelOpenD setValue:_callbackUrl forKey:@"callbackUrl"];
//    [reqChannelOpenD setValue:_instanceId forKey:@"instanceId"];
//
//    _MessageId++;
//
//    [self.delegate sendChannelRTCMessage:reqChannelOpenD];
//    _state = openSent;
//}

-(void) sendReconnect
{
    NSMutableDictionary* reqChannelReconnectD = [[NSMutableDictionary alloc]init];

   // NSDictionary *reqChannelReconnectD = @{ @"type" : @"openChannel" };
    [reqChannelReconnectD setValue:@"reconnectToChannel" forKey:@"type"];
    [reqChannelReconnectD setValue:_rtcgSessionId forKey:@"rtcgSessionId"];
    [reqChannelReconnectD setValue:[NSNumber numberWithInteger:_MessageId] forKey:@"messageId"];
    [reqChannelReconnectD setValue:_callbackUrl forKey:@"callbackUrl"];
    [reqChannelReconnectD setValue:_instanceId forKey:@"instanceId"];

    _MessageId++;
    
    [self.delegate sendChannelRTCMessage:reqChannelReconnectD];
    _state = reconnecting;
}

-(void) sendClose
{
	if(_state == chnlclosed)
    {
    LogDebug(@"Channel Already Closed !!");
        
        return;
    }
	
    NSMutableDictionary* reqChannelCloseD = [[NSMutableDictionary alloc]init];

    //NSDictionary *reqChannelCloseD = @{ @"type" : @"closeChannel",
    //                                   @"_rtcgSessionId" : _rtcgSessionId
    //                                   };
    
    [reqChannelCloseD setValue:@"closeChannel" forKey:@"type"];
    [reqChannelCloseD setValue:_rtcgSessionId forKey:@"rtcgSessionId"];
    [reqChannelCloseD setValue:[NSNumber numberWithInteger:_MessageId] forKey:@"messageId"];
    [reqChannelCloseD setValue:_callbackUrl forKey:@"callbackUrl"];
    [reqChannelCloseD setValue:_instanceId forKey:@"instanceId"];

    _MessageId++;
    
    [self.delegate sendChannelRTCMessage:reqChannelCloseD];
    _state = chnlclosed;
}

///ccc
//-(void) sendChannelMessage:(NSDictionary*)payload
//{
//    //NSDictionary *channelMsgD = @{ @"type" : @"channelMessage" };
//    NSMutableDictionary* channelMsgD = [[NSMutableDictionary alloc]init];
//
//   // NSDictionary* payloadMsg =[WebRTCJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&jsonError];
//   // NSDictionary *channelMsgD = @{ @"type" : @"channelMessage",
//   //                                 @"_rtcgSessionId" : _rtcgSessionId,
//   //                                 @"payload" : payload
//   //                                    };
//    [channelMsgD setValue:@"channelMessage" forKey:@"type"];
//    [channelMsgD setValue:_rtcgSessionId forKey:@"rtcgSessionId"];
//    [channelMsgD setValue:payload forKey:@"payload"];
//    [channelMsgD setValue:_instanceId forKey:@"instanceId"];
//
//    if ([_callbackUrl length] != 0)
//    {
//        [channelMsgD setValue:_callbackUrl forKey:@"callbackUrl"];
//
//    }
//    
//    [channelMsgD setValue:payload forKey:@"payload"];
//
//    if(_targets != nil)
//    {
//    
//		[channelMsgD setObject:_targets forKey:@"targets"];
//    }
//
//    [channelMsgD setValue:[NSNumber numberWithInteger:_MessageId] forKey:@"messageId"];
//    _MessageId++;
//
//    [self.delegate sendChannelRTCMessage:channelMsgD];
//
//}

-(void)onChannelCreated:(NSDictionary*)msg
{
   /* NSError *error = nil;
    NSDictionary* json =[WebRTCJSONSerialization JSONObjectWithData:msg options:kNilOptions error:&error];
    NSMutableDictionary* jsonm = [NSMutableDictionary dictionaryWithDictionary:json];
    // Check for errors
    NSAssert(!error, @"%@", [NSString stringWithFormat:@"Error handling message: %@", error.description]);*/

    LogDebug(@"onChannelCreated");
    _rtcgSessionId = [msg objectForKey:@"rtcgSessionId"];
}

-(void)onChannelCreatedAck:(NSDictionary*)msg
{
    /*NSError *error = nil;
    NSDictionary* json =[WebRTCJSONSerialization JSONObjectWithData:msg options:kNilOptions error:&error];
    NSMutableDictionary* jsonm = [NSMutableDictionary dictionaryWithDictionary:json];
    // Check for errors
    NSAssert(!error, @"%@", [NSString stringWithFormat:@"Error handling message: %@", error.description]);*/
    LogDebug(@"onChannelCreatedAck");

    _rtcgSessionId = [msg objectForKey:@"rtcgSessionId"];
    _callbackUrl   = [msg objectForKey:@"callbackUrl"];

    _state = created;
    //Need to remove this
    //[self sendOpen];
    
    [self.delegate onChannelAck:_rtcgSessionId];
}


-(void)onChannelCreateFailed:(NSDictionary*)msg
{
    LogDebug(@"onChannelCreateFailed");

    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"Channel Creation Failed!!" forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:Session code:ERR_CREATECHANNEL_FAILED userInfo:details];
    [self.delegate onChannelError:error.description errorCode:error.code];
    _state = chnlclosed;
}


-(void)onChannelReconnectAck:(NSDictionary*)msg
{
    LogDebug(@"Channel Reconnected Acknowledgment Received");
    _state = chnlopen;
}

-(void)onChannelOpened:(id)msg
{
    LogDebug(@"onChannelOpened");

    _state = chnlopen;
   
    _targets = [msg objectForKey:@"targets"];
    [self.delegate onChannelOpened];
}

-(void)onChannelOpenedAck:(NSDictionary*)msg
{
    LogDebug(@"onChannelOpenedAck");

    _state = chnlopen;
    _targets = [msg objectForKey:@"targets"];
    _rtcgSessionId = [msg objectForKey:@"rtcgSessionId"];
    [self.delegate onChannelAck:_rtcgSessionId];
    [self.delegate onChannelOpened];
}

-(void)onChannelMessage:(NSDictionary*)msg
{
    LogDebug(@"onChannelMessage");

   if(_state == chnlopen)
    {
        NSDictionary* payload = [msg objectForKey:@"payload"];
        if (![payload isKindOfClass:[NSDictionary class]])
        {
            for(NSDictionary *pD in payload)
            {
                [self.delegate onChannelMessage:pD];
            }
        }
        else{
                [self.delegate onChannelMessage:payload];
        }
    }
}
///ccc
//-(void)onChannelClosed:(NSData*)msg
//{
//    _state = chnlclosed;
//    [self.delegate onChannelClosed];
//}

-(void)onChannelClosedAck:(NSData*)msg
{
    _state = chnlclosed;
    [self.delegate onChannelClosed];
}
///ccc
//-(void)handleChannelEvent:(NSDictionary*)objects
//{
//    NSString *type;
//    
//    type = [[objects objectForKey:@"type"] lowercaseString];
//    
//    LogInfo(@"Received Channel event of type = %@",type );
//    
//    if (![type compare:@"channelcreated"])
//    {
//        [self onChannelCreated:objects];
//    }
//    else if (![type compare:@"channelcreatedack"])
//    {
//        [self onChannelCreatedAck:objects];
//    }
//    else if (![type compare:@"createchannelerror"])
//    {
//        [self onChannelCreateFailed:objects];
//    }
//    else if (![type compare:@"channelopenednotification"])
//    {
//        [self onChannelOpened:objects];
//    }
//    else if (![type compare:@"channelopenedack"])
//    {
//        [self onChannelOpenedAck:objects];
//    }
//    else if (![type compare:@"channelmessage"])
//    {
//        [self onChannelMessage:objects];
//    }
//    else if (![type compare:@"channelclosed"])
//    {
//        [self onChannelClosed:objects];
//    }
//    else if (![type compare:@"channelclosedack"])
//    {
//        [self onChannelClosedAck:objects];
//    }
//    else if (![type compare:@"reconnecttochannelack"])
//    {
//        [self onChannelReconnectAck:objects];
//    }
//    // Pass through to session
//    // Kind of hacky maybe there should be a outOfBand channel message type instead
//    else if (![type compare:@"iceservers"])
//    {
//        [self.delegate onChannelMessage:objects];
//    }
//    
//}
///ccc
//-(void)sendSessionMessage:(NSDictionary*)msg
//{
//    if(_state == chnlopen)
//    {
//        [self sendChannelMessage:msg];
//    }
//    else
//    {
//        LogInfo(@"State is %d Can not send message right now " , _state);
//
//    }
//}

@end
