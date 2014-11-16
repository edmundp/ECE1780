//
//  CircleLayer.h
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-15.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CircleLayer : CALayer

- (instancetype)initWithCenter:(CGPoint)center andRadius:(CGFloat)radius;
- (void)animateFromRadius:(CGFloat)radius1 toRadius:(CGFloat)radius2;
- (void)fadeOutAndRemove;

@end
