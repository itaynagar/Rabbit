//
//  RMatchUser.h
//  Rabbit
//
//  Created by Moveo Software on 18/07/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <Realm/Realm.h>


@interface RMatchUser : RLMObject

@property long objectId;
@property NSString *creator;
@property NSString *nickName;
@property int age;
@property float Distance;
@property NSString *about;
@property int height;
@property NSString *meetingType;
@property int relationshipStatus;
@property NSString *relationshipStatusDescription;
@property int weight;
@property BOOL isOn;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RMatchUser>
RLM_ARRAY_TYPE(RMatchUser)
