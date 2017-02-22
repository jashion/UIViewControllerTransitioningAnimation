//
//  BMAnimateTransition.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/10.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "BMAnimateTransition.h"

@interface BMAnimateTransition ()<CAAnimationDelegate>

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

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
    self.transitionContext = transitionContext;
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
                
        [UIView animateWithDuration: self.duration delay: 0.0 usingSpringWithDamping: 0.7 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
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
        
        [UIView animateWithDuration: self.duration delay: 0.0 usingSpringWithDamping: 0.7 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
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
    
    if (self.operation == BMAnimateTransitionCircleLayerPush) {
        [container addSubview: fromVC.view];
        [container addSubview: toVC.view];
        
        CGPoint initalPoint = CGPointMake(self.initalFrame.origin.x + self.initalFrame.size.width / 2, self.initalFrame.origin.y + self.initalFrame.size.height / 2);
        CGRect rect = toVC.view.bounds;
        CGFloat radius = [self calculateRadiusWithInitalPoint: initalPoint frame: rect];
        
        UIBezierPath *initalPath = [UIBezierPath bezierPathWithOvalInRect: self.initalFrame];
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithArcCenter: initalPoint radius: radius startAngle: 0 endAngle: M_PI * 2 clockwise: YES];
        
        [self circleMaskLayerAnimateWithController: toVC fromPath: initalPath.CGPath toPath: finalPath.CGPath animationKeyName: @"BMAnimateTransitionCircleLayerPush" animationDuration: self.duration];
        
        self.snapView.frame = self.initalFrame;
        [container addSubview: self.snapView];
        [UIView animateWithDuration: self.duration delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            self.snapView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.snapView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.snapView removeFromSuperview];
            self.snapView.transform = CGAffineTransformIdentity;
            self.snapView.alpha = 1;
        }];
        return;
    }
    
    if (self.operation == BMAnimateTransitionCircleLayerPop) {
        [container addSubview: toVC.view];
        [container addSubview: fromVC.view];
        
        CGPoint initalPoint = CGPointMake(self.finalFrame.origin.x + self.finalFrame.size.width / 2, self.finalFrame.origin.y + self.finalFrame.size.height / 2);
        CGRect rect = fromVC.view.bounds;
        CGFloat radius = [self calculateRadiusWithInitalPoint: initalPoint frame: rect];
        
        UIBezierPath *initalPath = [UIBezierPath bezierPathWithArcCenter: initalPoint radius: radius startAngle: 0 endAngle: M_PI * 2 clockwise: YES];
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect: self.finalFrame];
        
        [self circleMaskLayerAnimateWithController: fromVC fromPath: initalPath.CGPath toPath: finalPath.CGPath animationKeyName: @"BMAnimateTransitionCircleLayerPop" animationDuration: self.duration];
        
        self.finalView.frame = self.finalFrame;
        [container addSubview: self.finalView];
        
        self.finalView.bounds = CGRectMake(0, 0, 0.1, 0.1);
        [UIView animateWithDuration: self.duration delay: 0 options: UIViewAnimationOptionCurveEaseIn animations:^{
            self.finalView.bounds = CGRectMake(0, 0, self.finalFrame.size.width, self.finalFrame.size.height);
        } completion:^(BOOL finished) {
            [self.finalView removeFromSuperview];
        }];
        return;
    }
    
    if (self.operation == BMAnimateTransitionTabBarCircleLayer) {
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
        
        CGFloat radius = [self calculateRadiusWithInitalPoint: initalPoint frame: rect];
        
        UIBezierPath *initalPath = [UIBezierPath bezierPathWithOvalInRect: initalFrame];
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithArcCenter: initalPoint radius: radius startAngle: 0 endAngle: M_PI * 2 clockwise: YES];
        
        [self circleMaskLayerAnimateWithController: toVC fromPath: initalPath.CGPath toPath: finalPath.CGPath animationKeyName: @"BMAnimateTransitionTabBarCircleLayer" animationDuration: self.duration];
        return;
    }
    
    if (self.operation == BMAnimateTransitionPresentFadeIn) {
        [container addSubview: toVC.view];
        
        toVC.view.alpha = 0;
        [UIView animateWithDuration: self.duration animations:^{
            toVC.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
        }];
        
        return;
    }
    
    if (self.operation == BMAnimateTransitionPresentFadeOut) {
        [container addSubview: toVC.view];
        [container addSubview: fromVC.view];
        
        [UIView animateWithDuration: self.duration animations:^{
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
        }];
        return;
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition: ![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey: UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

#pragma mark - Private Method

- (CGFloat)calculateRadiusWithInitalPoint: (CGPoint)initalPoint frame: (CGRect)frame {
    CGFloat radius;
    if (initalPoint.x >= frame.size.width / 2 && initalPoint.y >= frame.size.height / 2) {
        radius = sqrtf(powf(initalPoint.x, 2) + powf(initalPoint.y, 2));
    } else if (initalPoint.x > frame.size.width / 2 && initalPoint.y < frame.size.height / 2) {
        radius = sqrtf(powf(initalPoint.x, 2) + powf(frame.size.height - initalPoint.y, 2));
    } else if (initalPoint.x < frame.size.width / 2 && initalPoint.y > frame.size.height / 2) {
        radius = sqrtf(powf(frame.size.width - initalPoint.x, 2) + powf(initalPoint.y, 2));
    } else {
        radius = sqrtf(powf(frame.size.width - initalPoint.x, 2) + powf(frame.size.height - initalPoint.y, 2));
    }
    radius = radius + 20;
    return radius;
}

- (void)circleMaskLayerAnimateWithController: (UIViewController *)controller fromPath: (CGPathRef)fromPath toPath: (CGPathRef)toPath animationKeyName: (NSString *)keyName animationDuration: (NSTimeInterval)duration{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = toPath;
    
    controller.view.layer.mask = maskLayer;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    maskLayerAnimation.duration = duration;
    maskLayerAnimation.fromValue = (__bridge id)fromPath;
    maskLayerAnimation.toValue = (__bridge id)toPath;
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation: maskLayerAnimation forKey: keyName];
}

@end
