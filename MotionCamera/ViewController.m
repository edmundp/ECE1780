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
#import "TouchDownGestureRecognizer.h"

@interface ViewController () <MotionDetectorDelegate> {
    IBOutlet UIView *messageView;
    IBOutlet UILabel *labelMessage;
    
    AVCaptureVideoPreviewLayer *previewLayer;
    Camera *camera;
    MotionDetector *motionDetector;
    
    UITapGestureRecognizer *tapGestureRecognizer;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    TouchDownGestureRecognizer *touchDownGestureRecognizer;
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
}

- (void)setupTouchGestures {
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePerformed:)];
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesturePerformed:)];
    touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(touchDownGesturePerformed:)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    [self.view addGestureRecognizer:touchDownGestureRecognizer];
}

- (void)setupView {
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:camera.captureSession];
    previewLayer.frame = self.view.layer.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:previewLayer atIndex:0];

    messageView.layer.cornerRadius = 10.0;
    messageView.alpha = 0.0;
}

#pragma mark - UI

- (void)showMessage:(NSString *)string forDuration:(NSTimeInterval)duration {
    labelMessage.text = string;
    
    [UIView animateWithDuration:0.3 animations:^{
        messageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:duration options:0 animations:^{
            messageView.alpha = 0.0;
        } completion:nil];
    }];
}

- (void)animatePhotoCapture {
    // Add flash view
    UIView *flashView = [[UIView alloc] init];
    flashView.translatesAutoresizingMaskIntoConstraints = NO;
    flashView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:flashView];
    
    // Set its constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(flashView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[flashView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[flashView]|" options:0 metrics:nil views:views]];
    
    // Animate the flash
    [UIView animateWithDuration:0.1 delay:0.1 options:0 animations:^{
        flashView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

#pragma mark - MotionDetectorDelegate

- (void)motionDetectorUserPerformedShake {
    [camera capturePhotoWithCompletionHandler:^{
        
        [self animatePhotoCapture];
        
    } afterDelay:1.0];
    motionDetector.photoCaptured = YES;
}

- (void)motionDetectorUserPerformedVerticalTilt {
    [camera flipCamera];
    motionDetector.tiltPerformed = YES;
    [motionDetector stopMotionSensing];
}

- (void)motionDetectorUserIsPerformingHorizontalRotate:(float)amount {
    
    float newZoom = MIN(MAX(camera.zoom + amount, 0.0), 1.0);
    
    camera.zoom = newZoom;
    
    [self showMessage:[NSString stringWithFormat:@"Zoom: %d%%", (int)(newZoom * 100)] forDuration:2.0];
}

#pragma mark - Touch Gestures

- (void)tapGesturePerformed:(UITapGestureRecognizer *)gesture {

}

- (void)longPressGesturePerformed:(UILongPressGestureRecognizer *)gesture {
    
}

- (void)touchDownGesturePerformed:(TouchDownGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [motionDetector beginMotionSensing];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        [motionDetector stopMotionSensing];
    }
}

@end
