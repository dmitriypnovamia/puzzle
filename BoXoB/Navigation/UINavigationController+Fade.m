//
//  UINavigationController+Fade.m
//  QuationSolver
//
//  Created by Singh Team on 09/07/16.
//  Copyright © 2016 Singh Team. All rights reserved.
//

#import "UINavigationController+Fade.h"

@implementation UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController
{

    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];

    [self pushViewController:viewController animated:NO];
}

- (void)fadePopViewController
{

    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

- (void)fadePopToRootViewController
{

    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popToRootViewControllerAnimated:NO];
}


@end
