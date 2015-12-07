//
//  SignalHandler.m
//  XfinityVideoShare


#import "SignalHandler.h"
#import "SocketIOPacket.h"
#import "WebRTCError.h"
#import "WebRTCLogHandler.h"
#import "WebRTCLogging.h"

NSString* const Socket = @"Socket";

@implementation SignalHandler
@synthesize gatewayUrl;
@synthesize portNum;

NSString* const TAG3 = @"SignalHandler";

// Creation of signal handler
- (id)initWithDefaultValue:(NSString*)server_url port:(NSInteger)port secure:(BOOL)secure statscollector:(WebRTCStatsCollector*)_statscollector
{
    // Error check for server url
    if (server_url == nil)
    {
        LogDebug(@"Webrtc:SignalHandler:: Server url is nil");
        return nil;
        //return ERR_INCORRECT_PARAMS;
    }

    // Error check for port
    if (( port < 1 ) || (port > 65535))
    {
        LogDebug(@"Webrtc:SignalHandler:: port not in range (1-65535)");
        return nil;
        //return ERR_INCORRECT_PARAMS;
    }
    
    // Initialise
    self = [super init];
    if(self!=nil){
        gatewayUrl = server_url;
        portNum = port;
        secureEnabled = secure;
        statscollector = _statscollector;
    }
    
    return self;
}

// Connect to the signalling gateway using socket io
- (void)connectToSignallingServer
{
    LogInfo(@"Webrtc:SignalHandler:: Connecting to server:: %@",gatewayUrl );
    
    [statscollector startMetric:@"wsConnectTime"];
    
    // Allocate memory
    socket = [[SocketIO alloc] initWithDelegate:self];
    NSAssert(socket!=NULL, @"Webrtc:SignalHandler:: socket is null, this is not supposed to happen");
    NSAssert(gatewayUrl!=NULL, @"Webrtc:SignalHandler:: gateway url is null, this is not supposed to happen");
    NSAssert(portNum!=0, @"Webrtc:SignalHandler:: port number is szero, this is not supposed to happen");
    
    if (secureEnabled)
    {
        socket.useSecure = true;
    }
    // 162.150.2.108 8080 RTCGWS-1.0
    //[socket setResourceName:@"RTCGWS-1.0"];
    
    //NSDictionary *queryparams = @{@"userName": @"bala:1407429292", @"credential": @"cW2bHL8HcBgeFB2vgF2pk9pCbek="};
    // NSDictionary *queryparams = @{@"userName": @"temp123:1407256177", @"credential": @"Upd0cO2NlIk6PxPCjbolbtcXzr4="};
    
 
    // Connect using socket io
    //[socket connectToHost:gatewayUrl onPort:portNum withParams:queryparams];
    [socket connectToHost:gatewayUrl onPort:portNum ];

    // TBD: Enable SSL/TLS?
    // TBD: Enable metrics for connection time, disconnect reasons etc
}
- (void)connectToSignallingServer:(NSString*)username credentials:(NSString*)credentials resource:(NSString*)resource
{
    LogInfo(@"Webrtc:SignalHandler:: Connecting to server:: %@",gatewayUrl);

    // Allocate memory
    socket = [[SocketIO alloc] initWithDelegate:self];
    NSAssert(socket!=NULL, @"Webrtc:SignalHandler:: socket is null, this is not supposed to happen");
    NSAssert(gatewayUrl!=NULL, @"Webrtc:SignalHandler:: gateway url is null, this is not supposed to happen");
    NSAssert(portNum!=0, @"Webrtc:SignalHandler:: port number is szero, this is not supposed to happen");
    
    if (secureEnabled)
    {
        socket.useSecure = true;
    }
    if ([resource length] != 0)
        [socket setResourceName:resource];
    //gatewayUrl = @"10.36.84.178";
    //portNum = 8080;
    //socket.useSecure = false;
    NSDictionary *queryparams = @{@"username": username, @"credential": credentials};
    
    // Connect using socket io
    [socket connectToHost:gatewayUrl onPort:portNum withParams:queryparams];

}

 //Send a RTC message to signaling server
- (void)sendClientRTCMessage:(id) msg
{
    NSAssert(msg!=NULL, @"Webrtc:SignalHandler:: Sending null RTC message !!!");
    [socket sendEvent:@"rtc_client_message" withData:msg];
    if ([[msg objectForKey:@"type"]  isEqual: @"bye"]) {
        [socket disconnect];
    }
    
}

// Send a registration message to signaling server
- (void)sendClientRegMessage:(id) msg
{
    NSAssert(msg!=NULL, @"Webrtc:SignalHandler:: Sending null registration message !!!");
    [socket sendEvent:@"reg_client_message" withData:msg];
}

// Send a auth message to signaling server
- (void)sendClientAuthMessage:(id) msg
{
    NSAssert(msg!=NULL, @"Webrtc:SignalHandler:: Sending null auth message !!!");
    [socket sendEvent:@"auth_client_message" withData:msg];
}

// disconnect
- (void)disconnect
{
    [socket disconnect];
}

- (void)disconnectForce
{
    [socket onDisconnect:nil];
}

# pragma mark socket.IO-objc delegate methods

// Called when socket.io is connected
- (void) socketIODidConnect:(SocketIO *)socket
{
    LogDebug(@"Webrtc:SignalHandler:: Connected to signaling server");
    [statscollector stopMetric:@"wsConnectTime"];
    
    // Called the delegate if it exits to inform that the socket is connected
    if (self.delegate != nil)
    {
      [self.delegate onConnected];
    }
    else
    {
      LogDebug(@"Webrtc:SignalHandler:: No delegate exists to post the message");
    }
}

// Called when socket is disconnected
- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    LogDebug(@"Webrtc:SignalHandler:: Disconnnected from server");
    
    // Let the delegate know that we are disconnected
    if (self.delegate != nil)
    {
        // Check if we have any error
        if (error != nil)
        {
            LogError(@"Webrtc:SignalHandler:: Disconnnected because of reason : %@",error.description );
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"websocket connection has been closed by the gateway/server" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:Socket code:ERR_WEBSOCKET_DISCONNECT userInfo:details];
            [self.delegate onSignalHandlerError:error.description Errorcode:error.code];
        }
        
        //[self.delegate onDisconnected: error.description];
    }
    else
    {
        LogDebug(@"Webrtc:SignalHandler:: No delegate exists to post the message");
    }

}

// A message was received over the socket.io
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{

    LogInfo(@"Webrtc:SignalHandler:: Message received from server : %@",packet.data);
    
}

// A JSON message was received over the socket.io
- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet
{
    LogInfo(@"Webrtc:SignalHandler:: JSON Message received from server %@", packet.data);
}

// A socket.io event was received
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    LogDebug(@"Webrtc:SignalHandler:: Received event from socket");
    [self.delegate onSignallingMessage:packet.name msg:packet.data];
}

// Called when message was sent
- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet
{
    
}

// Called when an error was received
- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    LogDebug(@"Webrtc:SignalHandler:: socket.io error");
    
    // Check if we have any error
    if (error != nil)
    {
        LogError(@"Webrtc:SignalHandler:: error: %@",error.description);

    }
    
    // Let the delegate know that we have an error
    if (self.delegate != nil)
    {
        if(error.code == SocketIOHandshakeFailed)
        {
            LogDebug(@"SocketIOHandshakeFailed");
        }
        else if(error.code == SocketIOServerRespondedWithInvalidConnectionData)
        {
            LogDebug(@"SocketIOServerRespondedWithInvalidConnectionData");
        }
        else if(error.code == SocketIOServerRespondedWithDisconnect)
        {
            LogDebug(@"SocketIOServerRespondedWithDisconnect");
        }
        else if(error.code == SocketIOHeartbeatTimeout)
        {
            LogDebug(@"SocketIOHeartbeatTimeout");
        }
        else if(error.code == SocketIOWebSocketClosed)
        {
            LogDebug(@"SocketIOWebSocketClosed");
        }
        else if(error.code == SocketIOTransportsNotSupported)
        {
            LogDebug(@"SocketIOTransportsNotSupported");
        }
        else if(error.code == SocketIODataCouldNotBeSend)
        {
            LogDebug(@"SocketIODataCouldNotBeSend");
        }
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"The server does not support websockets or it does not exist" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:Socket code:ERR_NO_WEBSOCKET_SUPPORT userInfo:details];
        [self.delegate onSignalHandlerError: error.description Errorcode:error.code];
    }
    else
    {
        LogDebug(@"Webrtc:SignalHandler:: No delegate exists to post the message");
    }
}

@end
