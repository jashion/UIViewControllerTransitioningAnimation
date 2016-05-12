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

@interface PopTransition ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transition;

@end

@implementation PopTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transition = transitionContext;
    UIView *container = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey: UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey: UITransitionContextFromViewKey];
    
    NSLog(@"PopAnimating");
    if (self.type == PopTransitionSpringType) {
        [container addSubview: toView];
        DetailController *fromVC = (DetailController *)[transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
        fromVC.topImageView.alpha = 0;
        UIView *snapView = [fromVC.topImageView snapshotViewAfterScreenUpdates: NO];
        snapView.frame = [fromVC.topImageView convertRect: fromVC.topImageView.bounds toView: toView];
        [container addSubview: snapView];
        
        toView.alpha = 0;
        self.selectedCell.contentView.hidden = YES;
        [UIView animateWithDuration: self.duration delay: 0.0 usingSpringWithDamping: 0.9 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            snapView.frame = self.finalFrame;
            toView.alpha = 1;
        } completion:^(BOOL finished) {
            self.selectedCell.contentView.hidden = NO;
            fromVC.topImageView.alpha = self.completed ? 0 : 1;
            [snapView removeFromSuperview];
            [transitionContext completeTransition: self.completed];
        }];

    } else if (self.type == PopTransitionCircleMaskType) {
        [container addSubview: toView];
        [container addSubview: fromView];
        
        CGPoint initalPoint = CGPointMake(self.finalFrame.origin.x + self.finalFrame.size.width / 2, self.finalFrame.origin.y + self.finalFrame.size.height / 2);
        CGRect rect = fromView.bounds;
        CGFloat radius;
        
        if (initalPoint.x >= rect.size.width / 2 && initalPoint.y >= rect.size.height / 2) {
            radius = sqrtf(powf(initalPoint.x, 2) + powf(initalPoint.y, 2));
        } else if (initalPoint.x > rect.size.width / 2 && initalPoint.y < rect.size.height / 2) {
            radius = sqrtf(powf(initalPoint.x, 2) + powf(rect.size.height - initalPoint.y, 2));
        } else if (initalPoint.x < rect.size.width / 2 && initalPoint.y > rect.size.height / 2) {
            radius = sqrtf(powf(rect.size.width - initalPoint.x, 2) + powf(initalPoint.y, 2));
        } else {
            radius = sqrtf(powf(rect.size.width - initalPoint.x, 2) + powf(rect.size.height - initalPoint.y, 2));
        }
        radius = radius + 20;
        
        UIBezierPath *initalPath = [UIBezierPath bezierPathWithArcCenter: initalPoint radius: radius startAngle: 0 endAngle: M_PI * 2 clockwise: YES];
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect: self.finalFrame];
        
        CAShapeLayer *finalMask = [CAShapeLayer layer];
        finalMask.path = finalPath.CGPath;
        
        fromView.layer.mask = finalMask;
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
        maskLayerAnimation.fromValue = (__bridge id)initalPath.CGPath;
        maskLayerAnimation.toValue = (__bridge id)finalPath.CGPath;
        maskLayerAnimation.duration = self.duration;
        maskLayerAnimation.delegate = self;
        [finalMask addAnimation: maskLayerAnimation forKey: @"maskLayerAnimation"];
        
        self.finalView.frame = self.finalFrame;
        [container addSubview: self.finalView];
        
        self.finalView.bounds = CGRectMake(0, 0, 0.1, 0.1);
        [UIView animateWithDuration: self.duration delay: 0 options: UIViewAnimationOptionCurveEaseIn animations:^{
            self.finalView.bounds = CGRectMake(0, 0, self.finalFrame.size.width, self.finalFrame.size.height);
        } completion:^(BOOL finished) {
            [self.finalView removeFromSuperview];
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transition completeTransition: self.completed];
    [self.transition viewControllerForKey: UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transition viewControllerForKey: UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
