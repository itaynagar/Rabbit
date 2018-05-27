//
//  ServerHanlder.m
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "ServerHandler.h"

@implementation ServerHandler

@synthesize _delegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - Login

- (void)createUserConfimationCodeWithPhoneNumber:(NSString *)phoneString
{
    NSString *urlString = @"http://www.rabbit.cool/api/api/user/CreateUserConfimationCode";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phoneString, @"PhoneNum", @"", @"Code", nil];
//    NSString *paramsString = [NSString stringWithFormat:@"{\"PhoneNum\":\"%@\"}", phoneString];
    //    NSLog(@"Login params: %@",params);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSLog(@"login to server SUCCESS with user: %@", responseObject);
                  if ([_delegate respondsToSelector:@selector(didGetCodeFromServer)]) {
                      [_delegate didGetCodeFromServer];
                  }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if ([_delegate respondsToSelector:@selector(didFailGetCodeFromServer)]) {
                  [_delegate didFailGetCodeFromServer];
              }
          }];
}

- (void)activateUserNumber:(NSString *)phoneString andCode:(NSString *)code
{
    NSString *urlString = @"http://www.rabbit.cool/api/api/user/ActivateUserNumber";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phoneString, @"PhoneNum", code, @"Code", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([_delegate respondsToSelector:@selector(didActivateUser)]) {
                  [_delegate didActivateUser];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if ([_delegate respondsToSelector:@selector(didFailActivateUser)]) {
                  [_delegate didFailActivateUser];
              }
          }];
}

# pragma mark - User

- (void)getUserWithToken:(NSString *)token
{
    NSString *urlString = @"http://www.rabbit.cool/api/api/user/GetUser";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token, @"Token", nil];
    //    NSLog(@"Login params: %@",params);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //              NSLog(@"login to server SUCCESS with user: %@", responseObject);
              if ([_delegate respondsToSelector:@selector(didGetUser)]) {
                  [_delegate didGetCodeFromServer];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if ([_delegate respondsToSelector:@selector(didFailGetUser)]) {
                  [_delegate didFailGetCodeFromServer];
              }
          }];
}

- (void)registerNewUser:(RUser *)user andRegOrUp:(BOOL)regOrUp
{
    NSString *urlString = @"http://www.rabbit.cool/api/api/user/RegisterUser";
    
    int maxAge = [user.userAge intValue] + 10;
    if ([user.userAge intValue] > 60) {
        maxAge = 60;
    }
    int minAge = [user.userAge intValue] - 10;
    if (minAge < 18) {
        minAge = 18;
    }
    if (!regOrUp) {
        urlString = @"http://www.rabbit.cool/api/api/user/UpdateUser";
    }
    NSString *myPhoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyPhoneNumber"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:myPhoneNum, @"Mobile",user.userFullName, @"Username", user.userEmail, @"Email" ,user.isMale ? @"1" : @"2", @"Gender", user.userAge, @"Age", [NSString stringWithFormat:@"%d",user.relationshipStatus], @"RelationshipStatus", user.lookingForABoy ? @"1" : @"2", @"LookingFor", user.userHeight, @"Height", user.userWeight, @"Weight", [NSString stringWithFormat:@"%d",maxAge], @"MaxAge", [NSString stringWithFormat:@"%d",minAge], @"MinAge", [NSString stringWithFormat:@"%d",maxAge], @"MaxAge", [NSString stringWithFormat:@"50"], @"maxDist", user.userImageUrl, @"UserImage", nil];
    if (!regOrUp) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:myPhoneNum, @"Mobile", user.userFullName, @"Username", user.userEmail, @"Email" ,user.isMale ? @"1" : @"2", @"Gender", user.userAge, @"Age", [NSString stringWithFormat:@"%d",user.relationshipStatus], @"RelationshipStatus", user.lookingForABoy ? @"1" : @"2", @"LookingFor", user.userHeight, @"Height", user.userWeight, @"Weight", [NSString stringWithFormat:@"%d",maxAge], @"MaxAge", [NSString stringWithFormat:@"%d",minAge], @"MinAge", [NSString stringWithFormat:@"%d",maxAge], @"MaxAge", [NSString stringWithFormat:@"50"], @"maxDist", user.userImageUrl, @"UserImage", nil];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *responDict = (NSDictionary *)responseObject;
              if ([responDict objectForKey:@"userToken"]) {
                  [[RealmManager getRealmManager] updateUserToken:[responDict objectForKey:@"userToken"]];
                  if ([_delegate respondsToSelector:@selector(didRegisterUser)]) {
                      [_delegate didRegisterUser];
                  }
              } else {
                  if ([_delegate respondsToSelector:@selector(didFailRegisterUser)]) {
                      [_delegate didFailRegisterUser];
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if ([_delegate respondsToSelector:@selector(didFailRegisterUser)]) {
                  [_delegate didFailRegisterUser];
              }
          }];
}

# pragma mark - Meeting

- (void)switchToOn:(RUser *)user andMeetType:(int)meetType andLat:(float)lat andLong:(float)longt
{
    NSString *urlString = @"http://www.rabbit.cool/api/api/meeting/SwitchToOn";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user.userToken, @"Creator", [NSString stringWithFormat:@"%d",meetType], @"Type" ,[NSString stringWithFormat:@"%f",lat], @"latCoordinate", [NSString stringWithFormat:@"%f",longt], @"longCoordinate", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *responsDict = (NSDictionary *)responseObject;
              int meetingId = [[responsDict objectForKey:@"resultMsg"]intValue];
              if ([_delegate respondsToSelector:@selector(didSwitchToOnWithMeetingId:)]) {
                  [_delegate didSwitchToOnWithMeetingId:meetingId];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if ([_delegate respondsToSelector:@selector(didFailSwitchToOn)]) {
                  [_delegate didFailSwitchToOn];
              }
          }];
}

- (void)findMeetingsWithMeetingId:(int)meetingType andUserToken:(NSString *)userToken andLat:(float)lat andLong:(float)longt
{
    NSString *urlString = @"http://www.rabbit.cool/api/api/meeting/FindMeetings";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userToken, @"Creator", [NSString stringWithFormat:@"%d",meetingType], @"Type" ,[NSString stringWithFormat:@"%f",lat], @"latCoordinate", [NSString stringWithFormat:@"%f",longt], @"longCoordinate", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *responsDict = (NSDictionary *)responseObject;
              int meetingId = [[responsDict objectForKey:@"resultMsg"]intValue];
              if ([_delegate respondsToSelector:@selector(didSwitchToOnWithMeetingId:)]) {
                  [_delegate didSwitchToOnWithMeetingId:meetingId];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if ([_delegate respondsToSelector:@selector(didFailSwitchToOn)]) {
                  [_delegate didFailSwitchToOn];
              }
          }];
}



@end
