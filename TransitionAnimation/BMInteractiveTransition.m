//
//  BMInteractiveTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/11.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "BMInteractiveTransition.h"

@implementation BMInteractiveTransition
{
    BOOL shouldComplete;
    UIViewController *controller;
    BMInteractiveTransitionType operationType;
}

- (void)wireToViewController: (UIViewController *)viewController operation: (BMInteractiveTransitionType)operation{
    controller = viewController;
    operationType = operation;
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget: self action: @selector(handleInteractiveGesture:)];
    if (operation == BMInteractiveTransitionTabControllerType) {
        screenEdgePan.edges = UIRectEdgeRight;
    } else {
        screenEdgePan.edges = UIRectEdgeLeft;
    }
    [viewController.view addGestureRecognizer: screenEdgePan];
}

- (void)handleInteractiveGesture: (UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView: gesture.view.superview];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interacting = YES;
            if (operationType == BMInteractiveTransitionNavigationType) {
                [controller.navigationController popViewControllerAnimated: YES];
            } else if (operationType == BMInteractiveTransitionTabControllerType) {
            } else {
                [controller dismissViewControllerAnimated: YES completion: nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat fraction = translation.x / (CGRectGetWidth([UIScreen mainScreen].bounds) / 2);
            fraction= fminf(fmaxf(fraction, 0.0), 1.0);
            shouldComplete = operationType == BMInteractiveTransitionNavigationType ? (fraction > 0.15) : (fraction > 0.5);
            [self updateInteractiveTransition: fraction];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            self.interacting = NO;
            shouldComplete? [self finishInteractiveTransition] : [self cancelInteractiveTransition];
            break;
        }
            
        default:
            break;
    }
}

@end
