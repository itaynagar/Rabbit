//
//  RealmManager.m
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "RealmManager.h"

@implementation RealmManager

@synthesize _delegate;

+ (id)getRealmManager
{
    static RealmManager *realmManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        realmManager = [[self alloc] init];
    });
    return realmManager;
}

#pragma mark - My User

- (RUser *)getMyUser
{
    RLMResults<RUser *> *results = [RUser allObjects];
    if (results.count > 0) {
        return results[0];
    }
    return nil;
}

- (void)saveUser:(RUser *)realmUser
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:realmUser];
    [realm commitWriteTransaction];
}

- (void)updateMyUserWithName:(NSString *)name andDescription:(NSString *)description andAge:(NSString *)age andIsMale:(BOOL)isMale andLookingFor:(BOOL)lookingFor andRelationshipStatus:(int)relationstatus andWeight:(NSString *)weight andHeight:(NSString *)height
{
    RLMResults<RUser *> *results = [RUser allObjects];
    if (results.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        RUser *myUser = results[0];
        [realm beginWriteTransaction];
        if (description.length > 0) {
            myUser.userDescription = description;
        }
        if (name.length > 0) {
            myUser.userFullName = name;
        }
        myUser.userAge = age;
        myUser.isMale = isMale;
        myUser.lookingForABoy = lookingFor;
        myUser.relationshipStatus = relationstatus;
        myUser.userWeight = weight;
        myUser.userHeight = height;
        [realm commitWriteTransaction];
    }
}

- (void)updateUserToken:(NSString *)token
{
    RLMResults<RUser *> *results = [RUser allObjects];
    if (results.count > 0) {
        RUser *meUser = results[0];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        meUser.userToken = token;
        [realm commitWriteTransaction];
    }
}

- (NSString *)getMyUserTitleWithAge
{
    RLMResults<RUser *> *results = [RUser allObjects];
    if (results.count > 0) {
        RUser *meUser = results[0];
        return [NSString stringWithFormat:@"%@,%@",meUser.userFirstName, meUser.userAge];
    }
    return @"";
}

- (void)saveMatchUser:(RMatchUser *)realmUser
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:realmUser];
    [realm commitWriteTransaction];
}

- (NSMutableArray *)getMatches
{
    RLMResults<RMatchUser *> *results = [RMatchUser objectsWhere:[NSString stringWithFormat:@"isOn == YES"]];
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    for (RMatchUser *rMatch in results) {
        [resultsArray addObject:rMatch];
    }
    return resultsArray;
}

@end
