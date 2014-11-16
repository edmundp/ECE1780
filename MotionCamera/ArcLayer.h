//
//  ArcLayer.h
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-16.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ArcLayer : CALayer

@property (nonatomic) float percentage;
@property (nonatomic, strong) NSString *(^textForPercentage)(float);
@property (nonatomic, strong) UIColor *color;

@end
