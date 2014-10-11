//
//  Camera.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-11.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "Camera.h"

// Reference: https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVCaptureDevice_Class/index.html
// Reference: https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVFoundationFramework/index.html#//apple_ref/doc/uid/TP40008072

@interface Camera() {
    AVCaptureDevice *_inputCamera;
    AVCaptureDeviceInput *_videoInput;
}

@end

@implementation Camera

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Setup capture session
    _captureSession = [[AVCaptureSession alloc] init];
    
    // Find the camera
    _inputCamera = [self findCaptureDeviceForPosition:AVCaptureDevicePositionBack];
    assert(_inputCamera);
    
    // Setup input
    NSError *error = nil;
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_inputCamera error:&error];
    
    assert(!error);
    assert([_captureSession canAddInput:_videoInput]);
    
    [_captureSession addInput:_videoInput];
    
    // Configure the capture session
    [_captureSession beginConfiguration];
    
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_captureSession commitConfiguration];
}

#pragma mark - Helpers

- (AVCaptureDevice *)findCaptureDeviceForPosition:(AVCaptureDevicePosition)cameraPosition {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == cameraPosition)
        {
            return device;
        }
    }
    
    return nil;
}
#pragma mark - Camera Controls

- (void)startCamera {
    [_captureSession startRunning];
}

- (void)stopCamera {
    [_captureSession stopRunning];
}

- (void)flipCamera {
    // Get new position
    AVCaptureDevicePosition newPosition = (_inputCamera.position == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    
    
    [_captureSession beginConfiguration];
    
    // Remove the current input
    [_captureSession removeInput:_videoInput];
    
    // Find camera
    _inputCamera = [self findCaptureDeviceForPosition:newPosition];
    assert(_inputCamera);
    
    // Add new input
    NSError *error = nil;
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_inputCamera error:&error];
    
    assert(!error);
    assert([_captureSession canAddInput:_videoInput]);
    
    [_captureSession addInput:_videoInput];

    [_captureSession commitConfiguration];
}

- (void)setZoom:(float)zoom {
    assert(zoom >= 0.0);
    assert(zoom <= 1.0);
    
    AVCaptureDeviceFormat *format = _inputCamera.activeFormat;
    
    NSError *error = nil;
    [_inputCamera lockForConfiguration:&error];
    assert(!error);
    
    _inputCamera.videoZoomFactor = 1.0 + zoom * (format.videoMaxZoomFactor - 1.0);
    
    [_inputCamera unlockForConfiguration];
}

- (void)capturePhoto {
    // TODO
}

- (void)startVideoRecording {
    // TODO
}

- (void)stopVideoRecording {
    // TODO
}

@end
