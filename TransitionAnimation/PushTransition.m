//
//  PushTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "PushTransition.h"
#import "DetailController.h"

@interface PushTransition ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transition;

@end

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transition = transitionContext;
    UIView *container = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey: UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey: UITransitionContextFromViewKey];
    
    if (self.type == PushTransitionSpringType) {
        [container addSubview: toView];

        DetailController *toVC = (DetailController *)[transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
        toVC.topImageView.hidden = YES;
        toVC.detailTableView.alpha = 0;
        self.snapView.frame = _snapFrame;
        [container addSubview: self.snapView];
        
        [UIView animateWithDuration: self.duration delay: 0.0 usingSpringWithDamping: 0.8 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            self.snapView.frame = CGRectMake(0, 64, self.snapView.frame.size.width, self.snapView.frame.size.height);
            toVC.detailTableView.alpha = 1.f;
        } completion:^(BOOL finished) {
            toVC.topImageView.hidden = NO;
            [self.snapView removeFromSuperview];
            [transitionContext completeTransition: YES];
        }];

    } else if (self.type == PushTransitionCircleMaskType) {
        [container addSubview: fromView];
        [container addSubview: toView];
        CGPoint initalPoint = CGPointMake(self.snapFrame.origin.x + self.snapFrame.size.width / 2, self.snapFrame.origin.y + self.snapFrame.size.height / 2);
        CGRect rect = toView.bounds;
        CGFloat radius;
        
        if (initalPoint.x > rect.size.width / 2 && initalPoint.y > rect.size.height / 2) {
            radius = sqrtf(powf(initalPoint.x, 2) + powf(initalPoint.y, 2));
        } else if (initalPoint.x > rect.size.width / 2 && initalPoint.y < rect.size.height / 2) {
            radius = sqrtf(powf(initalPoint.x, 2) + powf(rect.size.height - initalPoint.y, 2));
        } else if (initalPoint.x < rect.size.width / 2 && initalPoint.y > rect.size.height / 2) {
            radius = sqrtf(powf(rect.size.width - initalPoint.x, 2) + powf(initalPoint.y, 2));
        } else {
            radius = sqrtf(powf(rect.size.width - initalPoint.x, 2) + powf(rect.size.height - initalPoint.y, 2));
        }
        radius = radius + 20;
        
        UIBezierPath *initalPath = [UIBezierPath bezierPathWithOvalInRect: self.snapFrame];
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithArcCenter: initalPoint radius: radius startAngle: 0 endAngle: M_PI * 2 clockwise: YES];
        
        CAShapeLayer *initalMask = [CAShapeLayer layer];
        initalMask.path = initalPath.CGPath;
        
        CAShapeLayer *finalMask = [CAShapeLayer layer];
        finalMask.path = finalPath.CGPath;
        
        toView.layer.mask = finalMask;
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
        maskLayerAnimation.fromValue = (__bridge id)initalPath.CGPath;
        maskLayerAnimation.toValue = (__bridge id)finalPath.CGPath;
        maskLayerAnimation.duration = self.duration;
        maskLayerAnimation.delegate = self;
        [finalMask addAnimation: maskLayerAnimation forKey: @"maskLayerAnimation"];
        
        self.snapView.frame = self.snapFrame;
        [container addSubview: self.snapView];
        [UIView animateWithDuration: self.duration delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            self.snapView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.snapView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.snapView removeFromSuperview];
            self.snapView.transform = CGAffineTransformIdentity;
            self.snapView.alpha = 1;
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transition completeTransition: ![self.transition transitionWasCancelled]];
    [self.transition viewControllerForKey: UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transition viewControllerForKey: UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
