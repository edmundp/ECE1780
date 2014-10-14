//
//  AppDelegate.m
//  MotionCamera
//
//  Created by Edmund Phung on 2014-10-08.
//  Copyright (c) 2014 ECE1780. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)updateOrientation {
    UIInterfaceOrientation iOrientation = [UIApplication sharedApplication].statusBarOrientation;
	UIDeviceOrientation dOrientation = [UIDevice currentDevice].orientation;
    
	bool landscape;
	
	if (dOrientation == UIDeviceOrientationUnknown || dOrientation == UIDeviceOrientationFaceUp || dOrientation == UIDeviceOrientationFaceDown) {
		// If the device is laying down, use the UIInterfaceOrientation based on the status bar.
		landscape = UIInterfaceOrientationIsLandscape(iOrientation);
	} else {
		// If the device is not laying down, use UIDeviceOrientation.
		landscape = UIDeviceOrientationIsLandscape(dOrientation);
		
		// There's a bug in iOS!!!! http://openradar.appspot.com/7216046
		// So values needs to be reversed for landscape!
		if (dOrientation == UIDeviceOrientationLandscapeLeft) iOrientation = UIInterfaceOrientationLandscapeRight;
		else if (dOrientation == UIDeviceOrientationLandscapeRight) iOrientation = UIInterfaceOrientationLandscapeLeft;
        
		else if (dOrientation == UIDeviceOrientationPortrait) iOrientation = UIInterfaceOrientationPortrait;
		else if (dOrientation == UIDeviceOrientationPortraitUpsideDown) iOrientation = UIInterfaceOrientationPortraitUpsideDown;
	}
	
	if (landscape) {
        

	} else {
        
	}
	
	// Now manually rotate the view if needed.

    
	// Set the status bar to the right spot just in case
	[[UIApplication sharedApplication] setStatusBarOrientation:iOrientation];
	
}

@end
