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
    PopTransitionSpringType
};

@interface PopTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) MyTableViewCell *selectedCell;
@property (nonatomic, assign) PopTransitionType type;
@property (nonatomic, assign) CGRect finalFrame;
@property (nonatomic, assign) BOOL completed;

@end
