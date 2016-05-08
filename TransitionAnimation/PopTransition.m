//
//  PopTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "PopTransition.h"
#import "DetailController.h"
#import "HomeViewController.h"

@implementation PopTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *container = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey: UITransitionContextToViewKey];
    [container addSubview: toView];
    
    if (self.type == PopTransitionSpringType) {
        DetailController *fromVC = (DetailController *)[transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
        UIView *snapView = [fromVC.topImageView snapshotViewAfterScreenUpdates: NO];
        snapView.frame = [fromVC.topImageView convertRect: fromVC.topImageView.frame toView: toView];
        [container addSubview: snapView];
        
        self.selectedCell.contentView.hidden = YES;
        [UIView animateWithDuration: 0.6 delay: 0.0 usingSpringWithDamping: 0.7 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            snapView.frame = self.finalFrame;
        } completion:^(BOOL finished) {
            self.selectedCell.contentView.hidden = NO;
            [snapView removeFromSuperview];
            [transitionContext completeTransition: self.completed];
        }];

    }
}

@end
