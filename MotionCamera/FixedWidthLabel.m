//
//  FixedWidthLabel.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-14.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

/**
 This class fixes issues with multi-line labels on iOS 7 and below
 */

#import "FixedWidthLabel.h"

@implementation FixedWidthLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}
- (void)layoutSubviews {
    // For some reason, this is never called in iOS 8
    // But iOS 8 lets you set the preferredMaxLayoutWidth in interface builder anyways
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = self.bounds.size.width;
    
    [super layoutSubviews];
}

@end
