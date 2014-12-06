//
//  ZoomView.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-16.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "ZoomView.h"
#import "ArcLayer.h"

@interface ZoomView() {
    ArcLayer *arcLayer;
    NSTimer *hideTimer;
    UILabel *zoomLabel;
}

@end

@implementation ZoomView

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
    
    zoomLabel.frame = CGRectMake(0, 0, 100, 40);
    arcLayer.frame = CGRectMake(0, 40, 100, 100);
}

- (void)setup {
    arcLayer = [ArcLayer layer];
    arcLayer.color = [UIColor colorWithRed:46 / 255.0 green:65 / 255.0 blue:114 / 255.0 alpha:1.0];
    
    [self.layer addSublayer:arcLayer];
    
    zoomLabel = [[UILabel alloc] init];
    zoomLabel.text = @"Zoom";
    zoomLabel.textColor = [UIColor whiteColor];
    zoomLabel.textAlignment = NSTextAlignmentCenter;
    zoomLabel.shadowColor = [UIColor blackColor];
    zoomLabel.shadowOffset = CGSizeMake(1, 1);
    zoomLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self addSubview:zoomLabel];
    
    self.alpha = 0.0;
}

- (void)animationToPercentage:(CGFloat)percentage {
    self.alpha = 1.0;
    
    arcLayer.textForPercentage = ^NSString *(float percentage) {
        return [NSString stringWithFormat:@"%d%%", (int)(100 * percentage)];
    };
    
    arcLayer.percentage = percentage;
    [arcLayer setNeedsDisplay];
    
    [hideTimer invalidate];
    hideTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerDone) userInfo:nil repeats:NO];
}

- (void)timerDone {
    hideTimer = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
