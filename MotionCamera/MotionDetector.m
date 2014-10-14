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
    if([motionManager isGyroAvailable])
    {
        /* Start the gyroscope if it is not active already */
        if([motionManager isGyroActive] == NO)
        {
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error)
             {
                 float x = gyroData.rotationRate.x;
                 //NSLog(@"X: %@", x);
                 float y = gyroData.rotationRate.y;
                 //NSLog(@"Y: %@", y);
                 float z = gyroData.rotationRate.z;
                 //NSLog(@"Z: %@", z);
                 if((x>=0.7) && abs(y)< 0.1 && abs(z)<0.1){
                     [self.delegate motionDetectorUserIsPerformingHorizontalRotate:x/15];
                     [motionManager stopGyroUpdates];
                 }
                 if((x<=-0.7) && abs(y)< 0.1 && abs(z)<0.1){
                     [self.delegate motionDetectorUserIsPerformingHorizontalRotate:x/15];
                     [motionManager stopGyroUpdates];
                 }
             }];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }
}

- (void)stopMotionSensing {
}
@end
