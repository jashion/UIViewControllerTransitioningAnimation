//
//  DetailTableViewCell.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/7.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "ColorUtils.h"

@implementation DetailTableViewCell
{
    UILabel *nameLabel;
    UILabel *desLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    _avatarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 50, 50)];
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview: _avatarImageView];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 5, rect.size.width - 80, 25)];
    nameLabel.font = [UIFont systemFontOfSize: 16];
    nameLabel.textColor = [ColorUtils mainColor];
    [self.contentView addSubview: nameLabel];
    
    desLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 26, rect.size.width - 80, 54)];
    desLabel.font = [UIFont systemFontOfSize: 15];
    desLabel.textColor = [UIColor blackColor];
    desLabel.numberOfLines = 0;
    [self.contentView addSubview: desLabel];
}

- (void)setAvatar: (UIImage *)image name: (NSString *)name des: (NSString *)des {
    _avatarImageView.image = image;
    nameLabel.text = name;
    desLabel.text = des;
}

@end
