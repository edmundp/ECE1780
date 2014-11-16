//
//  CircleLayer.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-15.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "CircleLayer.h"

@implementation CircleLayer

- (instancetype)initWithCenter:(CGPoint)center andRadius:(CGFloat)radius {
    self = [super init];
    
    if (self) {
        self.cornerRadius = radius;
        self.position = center;
        self.bounds = CGRectMake(0, 0, 2 * radius, 2 * radius);
        self.borderColor = [UIColor whiteColor].CGColor;
        self.borderWidth = 3.0;
        self.actions = @{@"position": [NSNull null], @"opacity": [NSNull null]};
    }
    
    return self;
}

- (void)animateFromRadius:(CGFloat)radius1 toRadius:(CGFloat)radius2 {
    CABasicAnimation *boundsAnim = [CABasicAnimation animation];
    boundsAnim.keyPath = @"bounds";
    boundsAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2 * radius1, 2 * radius1)];
    boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2 * radius2, 2 * radius2)];
    
    CABasicAnimation *cornerRadAnim = [CABasicAnimation animation];
    cornerRadAnim.keyPath = @"cornerRadius";
    cornerRadAnim.fromValue = @(radius1);
    cornerRadAnim.toValue = @(radius2);
    
    CABasicAnimation *borderColorAnim = [CABasicAnimation animation];
    borderColorAnim.keyPath = @"borderColor";
    borderColorAnim.fromValue = (id)[UIColor whiteColor].CGColor;
    borderColorAnim.toValue = (id)[UIColor colorWithWhite:0.9 alpha:1.0].CGColor;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.repeatCount = HUGE_VALF;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = @[boundsAnim, cornerRadAnim, borderColorAnim];
    
    [self addAnimation:group forKey:@"radiusAnim"];
}

- (void)fadeOutAndRemove {
    self.opacity = 0.0;
    
    CABasicAnimation *alphaAnim = [CABasicAnimation animation];
    alphaAnim.keyPath = @"opacity";
    alphaAnim.fromValue = @(1.0);
    alphaAnim.toValue = @(0.0);
    alphaAnim.delegate = self;
    
    [self addAnimation:alphaAnim forKey:@"alphaAnim"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    [self removeAllAnimations];
    [self removeFromSuperlayer];
}

@end
