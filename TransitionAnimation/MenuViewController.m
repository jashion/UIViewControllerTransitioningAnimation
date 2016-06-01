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

- (instancetype)initWithBackgroundImage: (UIImage *)backgroundImage {
    if (self = [super init]) {
        _backgroundImage = backgroundImage;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage: _backgroundImage];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview: imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
