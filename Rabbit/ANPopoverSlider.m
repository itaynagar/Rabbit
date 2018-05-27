//
//  ANPopoverSlider.m
//  CustomSlider
//
//  Created by Gabriel  on 30/1/13.
//  Copyright (c) 2013 App Ninja. All rights reserved.
//

#import "ANPopoverSlider.h"

@implementation ANPopoverSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self constructSlider];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self constructSlider];
    }
    return self;
}

#pragma mark - UIControl touch event tracking
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade in and update the popup view
    CGPoint touchPoint = [touch locationInView:self];
    // Check if the knob is touched. If so, show the popup view
    if(CGRectContainsPoint(CGRectInset(self.thumbRect, -12.0, -12.0), touchPoint)) {
        [self positionAndUpdatePopupView];
        [self fadePopupViewInAndOut:YES];
    }
    

    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Update the popup view as slider knob is being moved
  //  [self positionAndUpdatePopupView];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Fade out the popup view
    [self fadePopupViewInAndOut:NO];
    [super endTrackingWithTouch:touch withEvent:event];
}


#pragma mark - Helper methods
-(void)constructSlider {
}

-(void)fadePopupViewInAndOut:(BOOL)aFadeIn {
}

-(void)positionAndUpdatePopupView {
}


#pragma mark - Property accessors
-(CGRect)thumbRect {
    CGRect trackRect = [self trackRectForBounds:self.bounds];

    CGRect thumbR = [self thumbRectForBounds:self.bounds trackRect:trackRect value:self.value];
    
    return thumbR;
}
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    float valueRatio = ( value - self.minimumValue ) / 1;
    return CGRectMake(valueRatio * (bounds.size.width - 26) + 3, 7, 20, 20);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
