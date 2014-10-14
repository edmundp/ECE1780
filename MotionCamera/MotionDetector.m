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
@synthesize tiltPerformed;
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
    //[motionManager startAccelerometerUpdates];
    
    // Setup gyroscope
    motionManager.gyroUpdateInterval = kGyroscopeUpdateInterval;
    //[motionManager startGyroUpdates];
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    
    // TODO: setup detection
}

- (void)beginMotionSensing {
    tiltPerformed = NO;
    if( UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
    if([motionManager isGyroAvailable])
    {
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                                toQueue:[[NSOperationQueue alloc] init]
                                                            withHandler:^(CMDeviceMotion *motion, NSError *error)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                float x = motion.gravity.x;
                float y = motion.gravity.y;
                float z = motion.gravity.z;
                float angle = atan2(y, x) + M_PI_2;           // in radians
                float angleDegrees = angle * 180.0f / M_PI;   // in degrees
                //NSLog(@"degree: %f", angleDegrees);
                float r = sqrtf(x*x + y*y + z*z);
                float tiltForwardBackward = acosf(z/r) * 180.0f / M_PI - 90.0f;

                if(!(tiltPerformed) && (tiltForwardBackward> 70 || tiltForwardBackward<-70)){
                    [self.delegate motionDetectorUserPerformedVerticalTilt];
                    [[NSOperationQueue mainQueue]  cancelAllOperations];
                    [self stopMotionSensing];
                }
                
                    }];
        }];

        if([motionManager isGyroActive] == NO)
        {
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error)
             {
                 float x = gyroData.rotationRate.x;
                 //NSLog(@"X: %f", x);
                 float y = gyroData.rotationRate.y;
                 //NSLog(@"Y: %f", y);
                 float z = gyroData.rotationRate.z;
                 //NSLog(@"Z: %f", z);
                 if((x>=0.5) && abs(y)< 0.1 && abs(z)<0.1){
                     [self.delegate motionDetectorUserIsPerformingHorizontalRotate:x/20];
                     //[motionManager stopGyroUpdates];
                 }
                 if((x<=-0.5) && abs(y)< 0.1 && abs(z)<0.1){
                     [self.delegate motionDetectorUserIsPerformingHorizontalRotate:x/20];
                     //[motionManager stopGyroUpdates];
                 }
             }];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }
    }
    else{
        if([motionManager isGyroAvailable])
        {
            [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                               toQueue:[[NSOperationQueue alloc] init]
                                                           withHandler:^(CMDeviceMotion *motion, NSError *error)
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     float x = motion.gravity.x;
                     float y = motion.gravity.y;
                     float z = motion.gravity.z;
                     float angle = atan2(y, x) + M_PI_2;           // in radians
                     float angleDegrees = angle * 180.0f / M_PI;   // in degrees
                     //NSLog(@"degree: %f", angleDegrees);
                     float r = sqrtf(x*x + y*y + z*z);
                     float tiltForwardBackward = acosf(z/r) * 180.0f / M_PI - 90.0f;
                     
                     if(!(tiltPerformed) && (tiltForwardBackward> 70 || tiltForwardBackward<-70)){
                         [self.delegate motionDetectorUserPerformedVerticalTilt];
                         [[NSOperationQueue mainQueue]  cancelAllOperations];
                         [self stopMotionSensing];
                     }
                     
                 }];
             }];
            
            if([motionManager isGyroActive] == NO)
            {
                [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMGyroData *gyroData, NSError *error)
                 {
                     float x = gyroData.rotationRate.x;
                     //NSLog(@"X: %f", x);
                     float y = gyroData.rotationRate.y;
                     //NSLog(@"Y: %f", y);
                     float z = gyroData.rotationRate.z;
                     //NSLog(@"Z: %f", z);
                     if((y>=0.5) && abs(x)< 0.1 && abs(z)<0.1){
                         [self.delegate motionDetectorUserIsPerformingHorizontalRotate:y/20];
                         //[motionManager stopGyroUpdates];
                     }
                     if((y<=-0.5) && abs(x)< 0.1 && abs(z)<0.1){
                         [self.delegate motionDetectorUserIsPerformingHorizontalRotate:y/20];
                         //[motionManager stopGyroUpdates];
                     }
                 }];
            }
        }
        else
        {
            NSLog(@"Gyroscope not Available!");
        }

    }
}

- (void)stopMotionSensing {
    [motionManager stopGyroUpdates];
}
@end
