//
//  ViewController.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-08.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController () {
    AVCaptureSession *captureSession;
    AVCaptureDevice *inputCamera;
    AVCaptureDeviceInput *videoInput;
    
    AVCaptureVideoPreviewLayer *previewLayer;
}

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCamera];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Camera Setup

- (void)setupCamera {
    // Setup capture session
    captureSession = [[AVCaptureSession alloc] init];
    
    // Find the camera
    inputCamera = nil;
    
    AVCaptureDevicePosition cameraPosition = AVCaptureDevicePositionBack;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == cameraPosition)
        {
            inputCamera = device;
        }
    }
    
    assert(inputCamera);
    
    // Setup input
    NSError *error = nil;
    videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:&error];
    if ([captureSession canAddInput:videoInput])
    {
        [captureSession addInput:videoInput];
    }
    
    // Configure the capture session
    [captureSession beginConfiguration];
    
    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [captureSession commitConfiguration];
}

- (void)setupView {
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = self.view.layer.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
}

#pragma mark - Camera Controls

- (void)startCamera {
    [captureSession startRunning];
}

- (void)stopCamera {
    [captureSession stopRunning];
}

@end
