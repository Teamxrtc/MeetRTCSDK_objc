//
//  SignalHandler.h
//  XfinityVideoShare
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"
#import "WebRTCStatsCollector.h"

@class WebRTCStack,WebRTCStatsCollector;

@protocol SignalHandlerDelegate <NSObject>

- (void)onSignallingMessage:(NSString*) event msg:(NSString*) msg;
- (void)onConnected;
- (void)onDisconnected:(NSString*) error;
- (void)onSignalHandlerError:(NSString*) error Errorcode:(NSInteger)code;
@end

@interface SignalHandler : NSObject <SocketIODelegate>
{
    SocketIO *socket;
    BOOL      secureEnabled;
    WebRTCStatsCollector* statscollector;
}
@property (nonatomic,retain) NSString *gatewayUrl;
@property (nonatomic) NSInteger portNum;
@property (nonatomic,assign) id<SignalHandlerDelegate> delegate;

- (id)initWithDefaultValue:(NSString*)server_url port:(NSInteger)port secure:(BOOL)secure statscollector:(WebRTCStatsCollector*)_statscollector;
- (void)connectToSignallingServer;
- (void)connectToSignallingServer:(NSString*)username credentials:(NSString*)credentials resource:(NSString*)resource;
- (void)sendClientRTCMessage:(NSData*) msg;
- (void)sendClientRegMessage:(NSData*) msg;
- (void)sendClientAuthMessage:(NSData*) msg;
- (void)disconnect;
- (void)disconnectForce;

@end
