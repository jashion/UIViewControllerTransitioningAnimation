//
//  BMAnimateTransition.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/10.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BMAnimateTransitionOPerationType) {
    BMAnimateTransitionCustomType                 =  0,
    BMAnimateTransitionSnapViewTransformPush      =  1,
    BMAnimateTransitionSnapViewTransformPop       =  2,
    BMAnimateTransitionCircleLayerPush            =  3,
    BMAnimateTransitionCircleLayerPop             =  4,
    BMAnimateTransitionTabBarCircleLayer          =  5,
    BMAnimateTransitionPresentFadeIn              =  6,
    BMAnimateTransitionPresentFadeOut             =  7
};

@interface BMAnimateTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BMAnimateTransitionOPerationType operation;

/**
 *  BMAnimateTransitionSnapViewTransformPushOrPopOrCircleLayerType
 */

@property (nonatomic, strong) UIView *snapView;
@property (nonatomic, strong) UIView *initalView;
@property (nonatomic, assign) CGRect initalFrame;
@property (nonatomic, strong) UIView *finalView;
@property (nonatomic, assign) CGRect finalFrame;

/**
 *  BMAnimateTransition
 *
 *  @param duration  duration
 *  @param operation operation
 *
 *  @return self
 */

- (instancetype)initWithDuration: (NSTimeInterval)duration operation: (BMAnimateTransitionOPerationType)operation;

@end
