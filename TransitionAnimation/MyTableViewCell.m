//
//  MyTableViewCell.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "MyTableViewCell.h"
#import "FXBlurView.h"

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
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer  alloc] initWithTarget: self action: @selector(handleLongPressGesture:)];
    [cellImageView addGestureRecognizer: longPress];
    cellImageView.userInteractionEnabled = YES;
    [self.contentView addSubview: cellImageView];
}

- (void)setCellImage:(UIImage *)image {
    cellImageView.image = image;
}

- (void)handleLongPressGesture: (UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            cellImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            cellImageView.image = [cellImageView.image blurredImageWithRadius: 5 iterations: 10 tintColor: [UIColor blackColor]];
            break;
        }
        
        case UIGestureRecognizerStateChanged:
        {
            break;
        }
        
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            cellImageView.transform = CGAffineTransformIdentity;
            break;
        }
            
        default:
            break;
    }
}

@end
