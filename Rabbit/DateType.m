//
// Created by Dan Kuida on 12/4/14.
// Copyright (c) 2014 Team Red I. All rights reserved.
//

#import "DateType.h"

@implementation DateType

- (instancetype)initWithStatusId:(int)statusId statusName:(NSString *)statusName {
    self = [super init];
    if (self) {
        self.statusId = statusId;
        self.statusName = statusName;
    }
    return self;
}

+ (instancetype)typeWithStatusId:(int)statusId statusName:(NSString *)statusName {
    return [[self alloc] initWithStatusId:statusId statusName:statusName];
}

@end