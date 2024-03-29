//
//  MotionDetector.h
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-11.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@protocol MotionDetectorDelegate <NSObject>
- (void)motionDetectorUserPerformedShake:(int)xx;
- (void)motionDetectorUserPerformedPush;
- (void)motionDetectorUserPerformedVerticalTilt;
- (void)motionDetectorUserPerformedHorizontalTilt;
- (void)motionDetectorUserIsPerformingHorizontalRotate:(float)amount;
@end

@interface MotionDetector : NSObject

@property (nonatomic, weak) id <MotionDetectorDelegate> delegate;
@property BOOL tiltPerformed;
@property BOOL photoCaptured;
@property BOOL performingState;

@property NSInteger shakeCount;
@property NSDate* lastShake;
@property float shakeDirectionX;
@property float initShakeDirectionX;
@property float shakeDirectionZ;
@property BOOL tiltInitialCheckForwardBackward;
@property BOOL tiltInitialCheckLeftwardRightward;

@property (nonatomic) BOOL isMotionSensing;

/**
 Start monitoring for motion gestures
 */
- (void)beginMotionSensing;

/**
 Stop monitoring for motion gestures
 */
- (void)stopMotionSensing;

@end
