//
//  MotionDetector.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-11.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "MotionDetector.h"
#import <CoreMotion/CoreMotion.h>

// Reference: http://eencae.wordpress.com/ios-tutorials/coremotion/cmmotionmanager/
// Reference: https://developer.apple.com/library/prerelease/iOS/documentation/CoreMotion/Reference/CMMotionManager_Class/index.html

static NSTimeInterval const kAccelerometerUpdateInterval = 0.05;
static NSTimeInterval const kGyroscopeUpdateInterval = 0.05;

@interface MotionDetector() {
    CMMotionManager *motionManager;
}

@end

@implementation MotionDetector

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    motionManager = [[CMMotionManager alloc] init];
    
    // Setup accelerometer
    motionManager.accelerometerUpdateInterval = kAccelerometerUpdateInterval;
    [motionManager startAccelerometerUpdates];
    
    // Setup gyroscope
    motionManager.gyroUpdateInterval = kGyroscopeUpdateInterval;
    [motionManager startGyroUpdates];
    
    // TODO: setup detection
}

- (void)beginMotionSensing {
    // TODO
}

- (void)stopMotionSensing {
    // TODO
}

@end
