//
//  RealmManager.h
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "RUser.h"
#import "RMatchUser.h"

@protocol RealmProtocol <NSObject>

//- (void)

@end

@interface RealmManager : NSObject
{
    id <RealmProtocol> _delegate;
}

@property (nonatomic, strong)id _delegate;

+ (id)getRealmManager;
- (RUser *)getMyUser;
- (void)saveUser:(RUser *)realmUser;
- (NSString *)getMyUserTitleWithAge;
- (void)updateMyUserWithName:(NSString *)name andDescription:(NSString *)description andAge:(NSString *)age andIsMale:(BOOL)isMale andLookingFor:(BOOL)lookingFor andRelationshipStatus:(int)relationstatus andWeight:(NSString *)weight andHeight:(NSString *)height;
- (void)updateUserToken:(NSString *)token;
- (void)saveMatchUser:(RMatchUser *)realmUser;
- (NSMutableArray *)getMatches;

@end
