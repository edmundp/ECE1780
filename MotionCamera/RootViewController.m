//
//  RootViewController.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-11-15.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <SWRevealViewControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.draggableBorderWidth = 30.0;
    self.rearViewRevealOverdraw = 0;
    self.frontViewShadowRadius = 3.0f;
    self.toggleAnimationDuration = 0.6;
    
    self.panGestureRecognizer.enabled = YES;
    self.tapGestureRecognizer.enabled = YES;
    
    self.delegate = self;
    
    self.rearViewRevealWidth = 200;
    
    [self setFrontViewPosition:FrontViewPositionRight animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SWRevealViewControllerDelegate

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionLeft) {
        self.frontViewController.view.userInteractionEnabled = YES;
    }
    else {
        self.frontViewController.view.userInteractionEnabled = NO;
    }
}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController {
    self.frontViewController.view.userInteractionEnabled = NO;
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController {
    self.frontViewController.view.userInteractionEnabled = YES;
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
