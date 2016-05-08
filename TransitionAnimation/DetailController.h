//
//  DetailController.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITableView *detailTableView;

- (instancetype)initWithTitle: (NSString *)title image: (UIImage *)image;

@end
