//
// Created by Dan Kuida on 12/4/14.
// Copyright (c) 2014 Team Red I. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateType : NSObject

@property int statusId;
@property NSString* statusName;

- (instancetype)initWithStatusId:(int)statusId statusName:(NSString *)statusName;

+ (instancetype)typeWithStatusId:(int)statusId statusName:(NSString *)statusName;


@end