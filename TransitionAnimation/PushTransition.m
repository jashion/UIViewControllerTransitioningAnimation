//
//  PushTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "PushTransition.h"
#import "DetailController.h"

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *container = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey: UITransitionContextToViewKey];
    [container addSubview: toView];
    
    if (self.type == PushTransitionSpringType) {
        DetailController *toVC = (DetailController *)[transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
        toVC.topImageView.hidden = YES;
        toVC.detailTableView.alpha = 0;
        self.snapView.frame = _snapFrame;
        [container addSubview: self.snapView];
        
        [UIView animateWithDuration: 0.6 delay: 0.0 usingSpringWithDamping: 0.7 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            self.snapView.frame = CGRectMake(0, 64, self.snapView.frame.size.width, self.snapView.frame.size.height);
            toVC.detailTableView.alpha = 1.f;
        } completion:^(BOOL finished) {
            toVC.topImageView.hidden = NO;
            [self.snapView removeFromSuperview];
            [transitionContext completeTransition: YES];
        }];

    }
}

@end
