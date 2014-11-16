//
//  TimerView.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-16.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "TimerView.h"

@interface ArcLayer : CALayer

@property (nonatomic) float percentage;
@property (nonatomic) NSTimeInterval totalDuration;

@end

@implementation ArcLayer

@dynamic percentage;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[ArcLayer class]]) {
            self.totalDuration = ((ArcLayer *)layer).totalDuration;
        }
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString*)key {
    if ([key isEqualToString:@"percentage"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)context {
    CGContextClearRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(context, self.bounds);
    
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
    
    CGContextBeginPath(context);
    
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius, -M_PI_2, -M_PI_2 + self.percentage * 2 * M_PI, NO);

    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:236 / 255.0 green:138 / 255.0 blue:40 / 255.0 alpha:1.0].CGColor);
    CGContextFillPath(context);
    
    float thickness = 6.0;
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillEllipseInRect(context, CGRectMake(thickness, thickness, self.bounds.size.width - 2 * thickness, self.bounds.size.height - 2 * thickness));
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //Draw the text
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByClipping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowColor = [UIColor blackColor];
    
    NSDictionary *attribs = @{
                              NSFontAttributeName: font,
                              NSForegroundColorAttributeName: [UIColor whiteColor],
                              NSParagraphStyleAttributeName: textStyle,
                              NSShadowAttributeName: shadow
                              };
    
    NSString *string = [NSString stringWithFormat:@"%.1fs", self.totalDuration - self.percentage * self.totalDuration];
    CGSize textRect = [string sizeWithAttributes:attribs];
    
    CGRect rect = CGRectMake(0, self.bounds.size.height / 2 - textRect.height / 2, self.bounds.size.width, textRect.height);
    
    UIGraphicsPushContext(context);
    [string drawInRect:rect withAttributes:attribs];
    UIGraphicsPopContext();
}

@end

@interface TimerView() {
    ArcLayer *arcLayer;
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

- (void)layoutSubviews {
    arcLayer.frame = self.bounds;
}

- (void)setup {
    arcLayer = [ArcLayer layer];
    [self.layer addSublayer:arcLayer];
    
    self.hidden = YES;
}

- (void)animateWithDuration:(NSTimeInterval)duration {
    self.hidden = NO;
    
    arcLayer.totalDuration = duration;
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
