//
//  BMInteractiveTransition.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/11.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BMInteractiveTransitionType) {
    BMInteractiveTransitionNavigationType        = 0,
    BMInteractiveTransitionPresentType           = 1,
    BMInteractiveTransitionTabControllerType     = 2
};

@interface BMInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, assign) BMInteractiveTransitionType operation;

- (void)wireToViewController: (UIViewController *)viewController;

@end
