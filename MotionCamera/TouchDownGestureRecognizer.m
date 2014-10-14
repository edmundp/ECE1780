//
//  TouchDownGestureRecognizer.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-13.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "TouchDownGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TouchDownGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateEnded;
}


@end
