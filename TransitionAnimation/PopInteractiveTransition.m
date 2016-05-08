//
//  PopInteractiveTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/7.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "PopInteractiveTransition.h"

@implementation PopInteractiveTransition
{
    BOOL shouldComplete;
    UIViewController *toVC;
}

- (void)wireToViewController: (UIViewController *)viewController {
    toVC = viewController;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleInteractiveGesture:)];
    [viewController.view addGestureRecognizer: pan];
}

- (void)handleInteractiveGesture: (UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView: gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interacting = YES;
            [toVC.navigationController popViewControllerAnimated: YES];
            break;
        }
        
        case UIGestureRecognizerStateChanged:
        {
            CGFloat fraction = translation.x / (CGRectGetWidth([UIScreen mainScreen].bounds) / 2);
            fraction= fminf(fmaxf(fraction, 0.0), 1.0);
            shouldComplete = (fraction > 0.5);
            [self updateInteractiveTransition: fraction];
            break;
        }
        
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            self.interacting = NO;
            if (shouldComplete) {
                self.animatedTransition.completed = YES;
                [self finishInteractiveTransition];
            } else {
                self.animatedTransition.completed = NO;
                [self cancelInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
