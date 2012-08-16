//
//  AppDelegate.h
//  Numbers Demo
//
//  Created by Cullen O'Neill on 8/16/12.
//  Copyright Lot18 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
