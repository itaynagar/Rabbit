//
//  SignalRManager.h
//  Rabbit
//
//  Created by Moveo Software on 04/07/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalR.h"
#import "RUser.h"
#import "RMatchUser.h"

@protocol SignalRProtocol <NSObject>

- (void)didConnect;
- (void)didGotMatches;

@end

@interface SignalRManager : NSObject <SRConnectionDelegate>
{
    id <SignalRProtocol> _delegate;
}

@property (nonatomic,strong)id _delegate;

+ (id)getSignalRManager;
- (void)sendJoinRequest:(RUser *)user andMeetType:(int)meetType andLat:(float)lat andLong:(float)longt;
- (void)findMeetingsRequest;
- (void)sendLogOffMeeting;

@end
