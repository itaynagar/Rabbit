//
//  RMatchUser.m
//  Rabbit
//
//  Created by Moveo Software on 18/07/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "RMatchUser.h"

@implementation RMatchUser

+ (NSString *)primaryKey {
    return @"objectId";
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
