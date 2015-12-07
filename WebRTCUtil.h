//
//  WebRTCUtil.h
//  XfinityVideoShare
//


#ifndef XfinityVideoShare_WebRTCUtil_h
#define XfinityVideoShare_WebRTCUtil_h
typedef enum
{
    outgoing,
    incoming,
    dataoutgoing,
    dataincoming
}WebrtcSessionCallTypes;


typedef struct
{
    BOOL EnableDataSend;
    BOOL EnableDataRecv;
    BOOL EnableVideoSend;
    BOOL EnableVideoRecv;
    BOOL EnableAudioSend;
    BOOL EnableAudioRecv;
    
    BOOL EnableOneWay;
    BOOL EnableBroadcast;
    
}WebrtcSessionOptions_t;



#endif
