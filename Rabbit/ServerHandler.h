//
//  ServerHanlder.h
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RealmManager.h"
#import "RUser.h"

@protocol ServerProtocol <NSObject>

- (void)didGetCodeFromServer;
- (void)didFailGetCodeFromServer;

- (void)didActivateUser;
- (void)didFailActivateUser;

- (void)didGetUser;
- (void)didFailGetUser;

- (void)didRegisterUser;
- (void)didFailRegisterUser;

- (void)didSwitchToOnWithMeetingId:(int)meetingId;
- (void)didFailSwitchToOn;

- (void)didFindMeetings;
- (void)didFailFindMeetings;

@end

@interface ServerHandler : NSObject
{
    id <ServerProtocol> _delegate;
}

@property (nonatomic, strong) id _delegate;

- (id)initWithDelegate:(id)delegate;
- (void)createUserConfimationCodeWithPhoneNumber:(NSString *)phoneString;
- (void)activateUserNumber:(NSString *)phoneString andCode:(NSString *)code;
- (void)registerNewUser:(RUser *)user andRegOrUp:(BOOL)regOrUp;
- (void)switchToOn:(RUser *)user andMeetType:(int)meetType andLat:(float)lat andLong:(float)longt;
- (void)findMeetingsWithMeetingId:(int)meetingType andUserToken:(NSString *)userToken andLat:(float)lat andLong:(float)longt;

@end
