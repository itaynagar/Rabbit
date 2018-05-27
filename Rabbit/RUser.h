//
//  RUser.h
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <Realm/Realm.h>

@interface RUser : RLMObject
@property NSString *userToken;
@property NSString *userFbId;
@property NSString *userFirstName;
@property NSString *userLastName;
@property NSString *userFullName;
@property NSString *userImageUrl;
@property NSString *userEmail;
@property NSString *userAge;
@property NSString *userStatus;
@property NSString *userWeight;
@property NSString *userHeight;
@property NSString *userDescription;
@property BOOL isMale;
@property BOOL lookingForABoy;
@property int relationshipStatus;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<RUser>
RLM_ARRAY_TYPE(RUser)
