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
    
    NSInteger captureTimeRemaining;
    NSTimer* captureTimer;
    
    BOOL isVideo;
    BOOL isRecording;
    
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

- (void)viewDidLayoutSubviews {
    previewLayer.frame = self.view.layer.bounds;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    AVCaptureConnection *connection = previewLayer.connection;
    
    AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
    
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait: videoOrientation = AVCaptureVideoOrientationPortrait; break;
        case UIInterfaceOrientationPortraitUpsideDown: videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown; break;
        case UIInterfaceOrientationLandscapeLeft: videoOrientation = AVCaptureVideoOrientationLandscapeLeft; break;
        case UIInterfaceOrientationLandscapeRight: videoOrientation = AVCaptureVideoOrientationLandscapeRight; break;
        default:
            break;
    }
    
    assert([connection isVideoOrientationSupported]);
    [connection setVideoOrientation:videoOrientation];
    
    camera.orientation = videoOrientation;
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

- (void) updateTimeCounter {

    captureTimeRemaining--;
    if (captureTimeRemaining==0)
    {
        if (isRecording)
        {
            [self showMessage:@"Recording finished" forDuration:1];
            [camera stopVideoRecording];
            isRecording=NO;
        }
        else{
            [self showMessage:@"Cheese!" forDuration:1];
            motionDetector.photoCaptured = YES;
            [camera capturePhotoWithCompletionHandler:^{
            
                [self animatePhotoCapture];
            
            } afterDelay:0.5];
        }
        [captureTimer invalidate];
        captureTimer=nil;
    }
    else
    {
        messageView.alpha=1.0;
        NSString *message = isRecording ? [NSString stringWithFormat: @"Finish recording in %ds...", captureTimeRemaining] : [NSString stringWithFormat: @"Capturing in %ds...", captureTimeRemaining];
        labelMessage.text=message;
    }
    
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

- (void)motionDetectorUserPerformedPush{
    if (isRecording)
    {
        [self showMessage:@"Recording finished" forDuration:1];
        [camera stopVideoRecording];
        isRecording=NO;
        return;
    }
    if (isVideo)
    {
        isRecording=YES;
        [camera startVideoRecording];
        labelMessage.text=@"Recording...";
        messageView.alpha=1;
        return;
    }
    [self showMessage:@"Cheese!" forDuration:1];
    motionDetector.photoCaptured = YES;
    [camera capturePhotoWithCompletionHandler:^{
        
        [self animatePhotoCapture];
        
    } afterDelay:1];
}

- (void)motionDetectorUserPerformedShake: (int)shakeCount{
    if (isRecording)
        return;
    if (isVideo)
    {
        captureTimeRemaining=shakeCount*5;
        isRecording=YES;
        [camera startVideoRecording];
        captureTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeCounter) userInfo:nil repeats:YES];
        return;
    }
    if (captureTimeRemaining>0)
    {
        captureTimeRemaining+=shakeCount*3;
        return;
    }
    captureTimeRemaining=(shakeCount-1)*3;
    if (captureTimeRemaining==0)
        captureTimeRemaining++;
    

    [self showMessage:[NSString stringWithFormat: @"%d shakes detected!", shakeCount] forDuration:1];


    captureTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeCounter) userInfo:nil repeats:YES];
}

- (void)motionDetectorUserPerformedVerticalTilt {
    if (isRecording)
        return;
    [camera flipCamera];
    motionDetector.tiltPerformed = YES;
   // [motionDetector stopMotionSensing];
    
    
    NSString *type = camera.cameraPosition == AVCaptureDevicePositionBack ? @"back" : @"front";
    NSString *message = [NSString stringWithFormat:@"Switched to %@ camera", type];
    
    [self showMessage:message forDuration:2.0];
}

- (void)motionDetectorUserPerformedHorizontalTilt {
    if (isRecording || captureTimeRemaining>0)
        return;
    motionDetector.tiltPerformed = YES;
  //  [motionDetector stopMotionSensing];
    isVideo=!isVideo;
    NSString *captureMode = isVideo ? @"Video recording mode" : @"Photo capturing mode";

    [self showMessage: captureMode forDuration:2.0];
    

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
