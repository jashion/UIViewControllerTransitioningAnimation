//
//  DetailTableViewCell.h
//  TransitionAnimation
//
//  Created by jashion on 16/5/7.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic, strong)  UIImageView *avatarImageView;

- (void)setAvatar: (UIImage *)image name: (NSString *)name des: (NSString *)des;

@end
