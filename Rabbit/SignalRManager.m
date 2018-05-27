//
//  SignalRManager.m
//  Rabbit
//
//  Created by Moveo Software on 04/07/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "SignalRManager.h"
#import "RealmManager.h"

@implementation SignalRManager
{
    SRHubConnection *hubConnection;
    SRHubProxy *chat;
    NSMutableArray *registerInfo;
}

@synthesize _delegate;

#pragma mark - Init

+ (id)getSignalRManager
{
    static SignalRManager *signalRManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signalRManager = [[self alloc] init];
    });
    return signalRManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self connectToServer];
    }
    return self;
}

#pragma mark - Connect/Register

- (void)connectToServer
{
    hubConnection = [SRHubConnection connectionWithURLString:@"http://www.rabbit.cool/api/signalr/rabbithub"];
    [hubConnection setDelegate:self];
    chat = [hubConnection createHubProxy:@"rabbithub"];
    [chat on:@"callbackSwitchToOn" perform:self selector:@selector(handleSwitchToOn:)];
    [chat on:@"callbackFindMeetings" perform:self selector:@selector(handleFindMeetings:)];
    [chat on:@"callbackSendMeetingToClients" perform:self selector:@selector(newUserIsOnLine:)];
    [chat on:@"callbackLogOffMeeting" perform:self selector:@selector(logOffMeeting:)];
    
    [hubConnection setReceived:^(NSString *message) {
        NSLog(@"Connection Recieved Data: %@",message);
    }];
    
    [hubConnection setConnectionSlow:^{
        NSLog(@"Connection Slow");
    }];
    
    [hubConnection setReconnecting:^{
        NSLog(@"Connection Reconnecting");
    }];
    
//    __weak typeof(self) weakSelf = self;
    [hubConnection setReconnected:^{
        NSLog(@"Connection Reconnected");
    }];
    
    [hubConnection setClosed:^{
        NSLog(@"Connection Closed");
    }];
    
    [hubConnection setError:^(NSError *error) {
        NSLog(@"Connection Error %@",error);
    }];
    __weak typeof(self) weakSelf = self;
    [hubConnection setStarted:^{
        NSLog(@"Connection Started");
        if ([weakSelf._delegate respondsToSelector:@selector(didConnect)]) {
            [weakSelf._delegate didConnect];
        }
    }];
    [hubConnection start];
}

- (void)SRConnection:(id <SRConnectionInterface>)connection didReceiveData:(id)data
{
    NSLog(@"%@",data);
}

- (void)sendJoinRequest:(RUser *)user andMeetType:(int)meetType andLat:(float)lat andLong:(float)longt
{
    registerInfo = [[NSMutableArray alloc] init];
    [registerInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:user.userToken, @"Creator", [NSString stringWithFormat:@"%d",meetType], @"Type" ,[NSString stringWithFormat:@"%f",lat], @"latCoordinate", [NSString stringWithFormat:@"%f",longt], @"longCoordinate", nil]];
    [chat invoke:@"SwitchToOn" withArgs:registerInfo];
}

- (void)findMeetingsRequest
{
    [chat invoke:@"FindMeetings" withArgs:registerInfo];
}

- (void)newUserIsOnLine:(NSString *)message
{
    NSLog(@"%@",message);
}

- (void)handleSwitchToOn:(NSString *)message
{
    if (message) {
        NSLog(@"%@",message);
        NSDictionary *messageDict = (NSDictionary *)message;
//        [self findMeetingsRequest];
    }
}

- (void)handleFindMeetings:(NSString *)message
{
    NSLog(@"%@",message);
    NSMutableArray *resultsArray = (NSMutableArray *)message;
    for (NSDictionary *matchUserDict in resultsArray) {
        RMatchUser *newMatch = [[RMatchUser alloc]init];
        newMatch.Distance = [[matchUserDict objectForKey:@"Distance"]floatValue];
        newMatch.about = [matchUserDict objectForKey:@"about"];
        newMatch.age = [[matchUserDict objectForKey:@"age"]intValue];
        newMatch.creator = [matchUserDict objectForKey:@"creator"];
        newMatch.height = [[matchUserDict objectForKey:@"height"]intValue];
        newMatch.meetingType = [matchUserDict objectForKey:@"meetingType"];
        newMatch.nickName = [matchUserDict objectForKey:@"nickName"];
        newMatch.objectId = [[matchUserDict objectForKey:@"objectId"]longValue];
        newMatch.relationshipStatus = [[matchUserDict objectForKey:@"relationshipStatus"]intValue];
        newMatch.relationshipStatusDescription = [matchUserDict objectForKey:@"relationshipStatusDescription"];
        newMatch.weight = [[matchUserDict objectForKey:@"weight"]intValue];
        newMatch.isOn = YES;
        [[RealmManager getRealmManager] saveMatchUser:newMatch];
    }
    if (resultsArray.count > 0) {
        if ([_delegate respondsToSelector:@selector(didGotMatches)]) {
            [_delegate didGotMatches];
        }
    }
}

- (void)sendLogOffMeeting
{
    NSLog(@"LogOut");
    [chat invoke:@"LogOffMeeting" withArgs:registerInfo];
}

- (void)logOffMeeting:(NSString *)message
{
    NSMutableArray *resultsArray = (NSMutableArray *)message;
    for (NSDictionary *matchUserDict in resultsArray) {
        RMatchUser *newMatch = [[RMatchUser alloc]init];
        newMatch.Distance = [[matchUserDict objectForKey:@"Distance"]floatValue];
        newMatch.about = [matchUserDict objectForKey:@"about"];
        newMatch.age = [[matchUserDict objectForKey:@"age"]intValue];
        newMatch.creator = [matchUserDict objectForKey:@"creator"];
        newMatch.height = [[matchUserDict objectForKey:@"height"]intValue];
        newMatch.meetingType = [matchUserDict objectForKey:@"meetingType"];
        newMatch.nickName = [matchUserDict objectForKey:@"nickName"];
        newMatch.objectId = [[matchUserDict objectForKey:@"objectId"]longValue];
        newMatch.relationshipStatus = [[matchUserDict objectForKey:@"relationshipStatus"]intValue];
        newMatch.relationshipStatusDescription = [matchUserDict objectForKey:@"relationshipStatusDescription"];
        newMatch.weight = [[matchUserDict objectForKey:@"weight"]intValue];
        newMatch.isOn = NO;
        [[RealmManager getRealmManager] saveMatchUser:newMatch];
    }
    if ([_delegate respondsToSelector:@selector(didGotMatches)]) {
        [_delegate didGotMatches];
    }
}

@end
