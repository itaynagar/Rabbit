//
// Created by Dan Kuida on 12/26/14.
// Copyright (c) 2014 Team Red I. All rights reserved.
//

#import "CircleButtonWithBorder.h"


@implementation CircleButtonWithBorder

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height /2;
    self.layer.masksToBounds = YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       self.layer.borderColor = [[UIColor colorWithRed:1.0f green:213.0f/255 blue:189.0f/255 alpha:1.0f] CGColor];
        self.layer.borderWidth =1.0f;
    }
    return self;
}

@end