//
//  PushTransition.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PushTransitionType) {
    PushTransitionSpringType        = 0,
    PushTransitionCircleMaskType    = 1
};

@interface PushTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PushTransitionType type;
@property (nonatomic, strong) UIView *snapView;
@property (nonatomic, assign) CGRect snapFrame;
@property (nonatomic, assign) NSTimeInterval duration;

@end
