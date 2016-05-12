//
//  BMAnimateTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/10.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "BMAnimateTransition.h"

@implementation BMAnimateTransition

- (instancetype)init {
    return [self initWithDuration: 0.4 operation: BMAnimateTransitionCustomType];
}

- (instancetype)initWithDuration: (NSTimeInterval)duration operation: (BMAnimateTransitionOPerationType)operation {
    if (self = [super init]) {
        _duration = duration;
        _operation = operation;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *container = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];

    if (self.operation == BMAnimateTransitionCustomType) {
        return;
    }
    
    if (self.operation == BMAnimateTransitionSnapViewTransformPush) {
        [container addSubview: toVC.view];
        
        self.finalView.hidden = YES;
        toVC.view.alpha = 0;
        
        self.snapView.frame = self.initalFrame;
        [container addSubview: self.snapView];
        
        [UIView animateWithDuration: self.duration delay: 0.0 usingSpringWithDamping: 0.8 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            self.snapView.frame = self.finalFrame;
            toVC.view.alpha = 1.f;
        } completion:^(BOOL finished) {
            self.finalView.hidden = NO;
            [self.snapView removeFromSuperview];
            [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
        }];
        return;
    }
    
    if (self.operation == BMAnimateTransitionSnapViewTransformPop) {
        [container addSubview: toVC.view];
        [container addSubview: fromVC.view];
        
        self.initalView.hidden = YES;
        self.finalView.hidden = YES;
        toVC.view.alpha = 0;
        
        self.snapView.frame = self.initalFrame;
        [container addSubview: self.snapView];
        
        [UIView animateWithDuration: self.duration delay: 0.0 usingSpringWithDamping: 0.9 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            self.snapView.frame = self.finalFrame;
            toVC.view.alpha = 1;
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            self.finalView.hidden = NO;
            self.initalView.hidden = ![transitionContext transitionWasCancelled];
            [self.snapView removeFromSuperview];
            [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
        }];
        return;
    }
    
    if (self.operation == BMAnimateTransitionCircleLayer) {
        
    }
}

@end
