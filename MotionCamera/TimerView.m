//
//  TimerView.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-16.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "TimerView.h"
#import "ArcLayer.h"

@interface TimerView() {
    ArcLayer *arcLayer;
    UILabel *timerLabel;
}

@end

@implementation TimerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(100, 140);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    timerLabel.frame = CGRectMake(0, 0, 100, 40);
    arcLayer.frame = CGRectMake(0, 40, 100, 100);
}

- (void)setup {
    arcLayer = [ArcLayer layer];
    arcLayer.color = [UIColor colorWithRed:236 / 255.0 green:138 / 255.0 blue:40 / 255.0 alpha:1.0];
    
    [self.layer addSublayer:arcLayer];
    
    timerLabel = [[UILabel alloc] init];
    timerLabel.text = @"Timer";
    timerLabel.textColor = [UIColor whiteColor];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.shadowColor = [UIColor blackColor];
    timerLabel.shadowOffset = CGSizeMake(1, 1);
    timerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self addSubview:timerLabel];
    
    self.hidden = YES;
}

- (void)animateWithDuration:(NSTimeInterval)duration {
    self.hidden = NO;
    
    arcLayer.textForPercentage = ^NSString *(float percentage) {
        return [NSString stringWithFormat:@"%.1fs", duration - percentage * duration];
    };
    
    arcLayer.percentage = 1.0;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    animation.keyPath = @"percentage";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    
    [arcLayer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
