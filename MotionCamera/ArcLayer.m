//
//  ArcLayer.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-16.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "ArcLayer.h"

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
            self.textForPercentage = ((ArcLayer *)layer).textForPercentage;
            self.color = ((ArcLayer *)layer).color;
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
    if (!self.color) {
        return;
    }
    
    CGContextClearRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(context, self.bounds);
    
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
    
    CGContextBeginPath(context);
    
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius, -M_PI_2, -M_PI_2 + self.percentage * 2 * M_PI, NO);
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillPath(context);
    
    const CGFloat thickness = 10.0;
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillEllipseInRect(context, CGRectMake(thickness, thickness, self.bounds.size.width - 2 * thickness, self.bounds.size.height - 2 * thickness));
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //Draw the text
    if (self.textForPercentage) {
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
        
        NSString *string = self.textForPercentage(self.percentage);
        CGSize textRect = [string sizeWithAttributes:attribs];
        
        CGRect rect = CGRectMake(0, self.bounds.size.height / 2 - textRect.height / 2, self.bounds.size.width, textRect.height);
        
        UIGraphicsPushContext(context);
        [string drawInRect:rect withAttributes:attribs];
        UIGraphicsPopContext();
    }
    
}

@end
