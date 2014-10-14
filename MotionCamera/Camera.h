//
//  Camera.h
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-11.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface Camera : NSObject

@property (nonatomic, readonly, strong) AVCaptureSession *captureSession;

/**
 Starts the camera
 */
- (void)startCamera;

/**
 Stops the camera
 */
- (void)stopCamera;

/**
 Switches between the front facing and back facing camera
 */
- (void)flipCamera;

/**
 Adjusts the zoom level of the camera
 @param zoom A value between 0.0 (no zoom) and 1.0 (maximum zoom)
 */
@property (nonatomic) float zoom;

/**
 Captures a photo and saves it to the user's photo album
 @param handler Called after capture
 @param delay Time in seconds to wait before capturing
 */
- (void)capturePhotoWithCompletionHandler:(void (^)())handler afterDelay:(NSTimeInterval)delay;

/**
 Starts recording video
 */
- (void)startVideoRecording;

/**
 Stops recording video and saves it to the user's albums
 */
- (void)stopVideoRecording;

@end
