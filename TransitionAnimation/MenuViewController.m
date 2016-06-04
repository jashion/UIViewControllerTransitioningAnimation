//
//  MenuViewController.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/25.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) UIImage *backgroundImage;

@end

@implementation MenuViewController
{
    NSArray *titles;
    NSMutableArray *titleLabels;
    UIButton *deleteButton;
}

- (instancetype)initWithBackgroundImage: (UIImage *)backgroundImage {
    if (self = [super init]) {
        _backgroundImage = backgroundImage;
        titles = @[@"Popular", @"Debuts", @"Playoffs", @"Animated", @"Rebounds", @"Sign in"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: _backgroundImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    if (titleLabels && titleLabels.count > 0) {
        return;
    }
    
    deleteButton = [UIButton buttonWithType: UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(20, 30, 23, 23);
    deleteButton.contentMode = UIViewContentModeScaleAspectFill;
    deleteButton.clipsToBounds = YES;
    deleteButton.transform = CGAffineTransformMakeScale(0, 0);
    [deleteButton setImage: [UIImage imageNamed:@"DeleteIcon"] forState: UIControlStateNormal];
    [deleteButton addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: deleteButton];
    
    [UIView animateWithDuration: 0.6 delay: 0 usingSpringWithDamping: 0.5 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        deleteButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    CGRect rect = self.view.bounds;
    titleLabels = @[].mutableCopy;
    for (NSInteger index = 0; index < titles.count; index++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.bounds = CGRectMake(0, 0, 150, 30);
        titleLabel.center = CGPointMake(rect.size.width / 2, 160 + index * 60);
        titleLabel.text = titles[index];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize: 22];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.transform = CGAffineTransformMakeScale(0, 0);
        [self.view addSubview: titleLabel];
        [titleLabels addObject: titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(back)];
        [titleLabel addGestureRecognizer: tap];
     
        [UIView animateWithDuration: 0.6 delay: index * 0.05 usingSpringWithDamping: 0.5 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            titleLabel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)back {
    if (self.delegate && [self.delegate respondsToSelector: @selector(dismissWithMenuVC:)]) {
        for (NSInteger index = 0; index < titleLabels.count; index++) {
            UILabel *titleLabel = titleLabels[index];
            [UIView animateWithDuration: 0.3 delay: index * 0.1 usingSpringWithDamping: 0.7 initialSpringVelocity: 1.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
                titleLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                titleLabel.hidden = YES;
            }];
        }
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self.delegate dismissWithMenuVC: self];
        });
    }
}

@end
