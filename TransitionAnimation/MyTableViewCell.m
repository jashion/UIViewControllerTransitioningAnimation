//
//  MyTableViewCell.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
{
    UIImageView *cellImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildView];
    }
    return self;
}

- (void)buildView {
    cellImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds) * 3 /4)];
    [self.contentView addSubview: cellImageView];
}

- (void)setCellImage:(UIImage *)image {
    cellImageView.image = image;
}

@end
