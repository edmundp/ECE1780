//
//  ViewController.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-08.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "Camera.h"
#import "MotionDetector.h"

@interface ViewController () <MotionDetectorDelegate> {
    AVCaptureVideoPreviewLayer *previewLayer;
    Camera *camera;
    MotionDetector *motionDetector;
    
    UITapGestureRecognizer *tapGestureRecognizer;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
}

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCamera];
    [self setupMotionGestures];
    [self setupTouchGestures];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [camera startCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupCamera {
    camera = [[Camera alloc] init];
}

- (void)setupMotionGestures {
    motionDetector = [[MotionDetector alloc] init];
    motionDetector.delegate = self;
    [motionDetector beginMotionSensing];

}

- (void)setupTouchGestures {
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePerformed:)];
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesturePerformed:)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setupView {
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:camera.captureSession];
    previewLayer.frame = self.view.layer.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];

}

#pragma mark - MotionDetectorDelegate

- (void)motionDetectorUserPerformedShake {
    [camera capturePhoto];
}

- (void)motionDetectorUserPerformedVerticalTilt {
    [camera flipCamera];
}

- (void)motionDetectorUserIsPerformingHorizontalRotate:(float)amount {
    NSLog(@"ZOOM:%f", amount);
    [camera setZoom:amount];
}

#pragma mark - Touch Gestures

- (void)tapGesturePerformed:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [motionDetector beginMotionSensing];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        [motionDetector stopMotionSensing];
    }
}

- (void)longPressGesturePerformed:(UILongPressGestureRecognizer *)gesture {
    
}

@end
