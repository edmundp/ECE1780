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
@synthesize photoCaptured;
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
    //[motionManager startGyroUpdates];
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    
    // TODO: setup detection
}

- (void)beginMotionSensing {
    tiltPerformed = NO;
    photoCaptured = NO;
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
    }/*
        if([motionManager isAccelerometerActive]){
            CMAccelerometerData *data = [motionManager accelerometerData];
            NSLog(@"X: %f,Y: %f,Z: %f", data.acceleration.x, data.acceleration.y,data.acceleration.z);
            if(data.acceleration.x >20 || data.acceleration.y>20 || data.acceleration.z>20){
                [self.delegate motionDetectorUserPerformedShake];
            }
        }
        else{
            NSLog(@"Accelerometer not available!");
        }*/

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
        /*
        if([motionManager isAccelerometerActive]){
            CMAccelerometerData *data = [motionManager accelerometerData];
            NSLog(@"X: %f,Y: %f,Z: %f", data.acceleration.x, data.acceleration.y,data.acceleration.z);
            if(data.acceleration.x >20 || data.acceleration.y>20 || data.acceleration.z>20){
                [self.delegate motionDetectorUserPerformedShake];
            }
        }
        else{
            NSLog(@"Accelerometer not available!");
        }*/


    }
    if([motionManager isAccelerometerActive]){
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                   withHandler:^(CMAccelerometerData *data, NSError *error)
         {

        NSLog(@"X: %f,Y: %f,Z: %f", data.acceleration.x, data.acceleration.y,data.acceleration.z);
        if(!(photoCaptured) && (data.acceleration.x >0.8 || data.acceleration.y>0.8 || data.acceleration.z>0.8)){
            [self.delegate motionDetectorUserPerformedShake];
        }
         }];
         }
    else{
        NSLog(@"Accelerometer not available!");
    }

}

- (void)stopMotionSensing {
    [motionManager stopGyroUpdates];
    [motionManager stopDeviceMotionUpdates];
}
@end
