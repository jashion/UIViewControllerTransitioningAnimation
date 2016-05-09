//
//  MessageViewController.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/5.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "MessageViewController.h"

@implementation MessageViewController

- (instancetype)init {
    if (self = [super init]) {
        self.navigationItem.title = @"Message";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
}

@end
