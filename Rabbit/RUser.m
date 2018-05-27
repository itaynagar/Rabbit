//
//  RUser.m
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "RUser.h"

@implementation RUser

+ (NSString *)primaryKey {
    return @"userFbId";
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
