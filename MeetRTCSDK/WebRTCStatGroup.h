//
//  WebRTCStatGroup.h
//  xfinity-webrtc-sdk
//
//  Created by Pankaj on 16/07/14.
//  Copyright (c) 2014 Comcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebRTCStatGroup : NSObject
{
    NSMutableDictionary *stats;
    NSMutableDictionary *streamInfo;
}

@property(nonatomic ) NSDateFormatter* dateFormatter;

-(id)init;
-(NSMutableDictionary*)getAllStats;
-(NSMutableDictionary*)getStat:(NSString*)statName;
-(void)startMetric:(NSString*)statName;
-(void)stopMetric:(NSString*)statName;
-(void)storeReaccuring:(NSString*)statName _values:(NSDictionary*)values;
-(void)writeStat:(NSString*)statName _key:(NSString*)key _value:(NSString*)value;
-(void)writeArrayStat:(NSString*)statName  _value:(NSDictionary*)value;
-(NSMutableDictionary*)streamInfo;

@end
