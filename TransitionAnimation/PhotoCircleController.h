//
//  PhotoCircleController.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/9.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCircleController;

@protocol handleDismissControllerDelegate <NSObject>

- (void)dismissController: (PhotoCircleController *)controller;

@end

@interface PhotoCircleController : UIViewController

@property (nonatomic, weak) id<handleDismissControllerDelegate> delegate;

- (instancetype)initWithImages: (NSArray *)images currentImageIndex: (NSInteger)index;

@end
