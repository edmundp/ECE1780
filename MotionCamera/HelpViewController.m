//
//  HelpViewController.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-15.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController () {
    
    IBOutlet UIView *circleOneView;
    IBOutlet UILabel *labelOne;
    
    IBOutlet UIView *circleTwoView;
    IBOutlet UILabel *labelTwo;
    
    IBOutlet UIImageView *imageViewZoom;
    IBOutlet UILabel *labelZoom;
    
    IBOutlet UIImageView *imageViewShake;
    IBOutlet UILabel *labelShake;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageViewZoom.animationImages = @[[UIImage imageNamed:@"deviceCenter"],
                                      [UIImage imageNamed:@"deviceLeft"],
                                      [UIImage imageNamed:@"deviceCenter"],
                                      [UIImage imageNamed:@"deviceRight"]];
    imageViewZoom.animationDuration = 2.0;
    [imageViewZoom startAnimating];
    
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.0f;
    animation.cumulative = NO;
    animation.repeatCount = HUGE_VALF;
    animation.values = @[@(0.0 * M_PI),
                         @(-0.08 * M_PI),
                         @(0.0 * M_PI),
                         @(0.08 * M_PI),
                         @(0.0 * M_PI)];
    animation.keyTimes = @[@(0.00),
                           @(0.05),
                           @(0.10),
                           @(0.15),
                           @(0.20)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [imageViewShake.layer addAnimation:animation forKey:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    circleOneView.alpha = 0.0;
    labelOne.alpha = 0.0;
    
    circleTwoView.alpha = 0.0;
    labelTwo.alpha = 0.0;
    
    imageViewZoom.alpha = 0.0;
    labelZoom.alpha = 0.0;
    
    imageViewShake.alpha = 0.0;
    labelShake.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateKeyframesWithDuration:2.0 delay:0.3 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            circleOneView.alpha = 1.0;
            labelOne.alpha = 1.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.2 animations:^{
            circleTwoView.alpha = 1.0;
            labelTwo.alpha = 1.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.4 animations:^{
            imageViewZoom.alpha = 1.0;
            labelZoom.alpha = 1.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.4 animations:^{
            imageViewShake.alpha = 1.0;
            labelShake.alpha = 1.0;
        }];
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
