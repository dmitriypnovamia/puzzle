//
//  UINavigationController+Fade.h
//  QuationSolver
//
//  Created by Singh Team on 09/07/16.
//  Copyright © 2016 Singh Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)fadePopViewController;
- (void)fadePopToRootViewController;

@end
