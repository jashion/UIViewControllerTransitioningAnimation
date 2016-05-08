//
//  PopTransition.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"

typedef NS_ENUM(NSInteger, PopTransitionType) {
    PopTransitionSpringType       = 0,
    PopTransitionCircleMaskType   = 1
};

@interface PopTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) MyTableViewCell *selectedCell;
@property (nonatomic, assign) PopTransitionType type;
@property (nonatomic, strong) UIView *finalView;
@property (nonatomic, assign) CGRect finalFrame;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL completed;

@end
