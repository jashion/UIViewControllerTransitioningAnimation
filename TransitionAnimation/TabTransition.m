//
//  TabTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/9.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "TabTransition.h"

@interface TabTransition ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation TabTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    UIView *container = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    [container addSubview: fromVC.view];
    [container addSubview: toVC.view];
    
    CGRect rect = toVC.view.frame;
    CGRect initalFrame;
    if ([toVC.tabBarItem.title isEqualToString: @"Home"]) {
        initalFrame = CGRectMake(0, rect.size.height - 49, rect.size.width / 3, 49);
    } else if ([toVC.tabBarItem.title isEqualToString: @"Message"]) {
        initalFrame = CGRectMake(rect.size.width / 3, rect.size.height - 49, rect.size.width / 3, 49);
    } else {
        initalFrame = CGRectMake(rect.size.width * 2 / 3, rect.size.height - 49, rect.size.width / 3, 49);
    }
    CGPoint initalPoint = CGPointMake(initalFrame.origin.x + initalFrame.size.width / 2, initalFrame.origin.y + initalFrame.size.height / 2);
    
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
    
    UIBezierPath *initalPath = [UIBezierPath bezierPathWithOvalInRect: initalFrame];
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithArcCenter: initalPoint radius: radius startAngle: 0 endAngle: M_PI * 2 clockwise: YES];
        
    CAShapeLayer *finalMaskLayer = [CAShapeLayer layer];
    finalMaskLayer.path = finalPath.CGPath;
    
    toVC.view.layer.mask = finalMaskLayer;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    maskLayerAnimation.duration = 0.4;
    maskLayerAnimation.fromValue = (__bridge id)initalPath.CGPath;
    maskLayerAnimation.toValue = (__bridge id)finalPath.CGPath;
    maskLayerAnimation.delegate = self;
    [finalMaskLayer addAnimation: maskLayerAnimation forKey: @"maskLayerAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition: ![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewForKey: UITransitionContextFromViewKey].layer.mask = nil;
    [self.transitionContext viewForKey: UITransitionContextToViewKey].layer.mask = nil;
}

@end
