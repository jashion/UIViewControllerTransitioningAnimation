//
//  PopInteractiveTransition.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/7.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopTransition.h"

@interface PopInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, strong) PopTransition *animatedTransition;

- (void)wireToViewController: (UIViewController *)viewController;

@end
