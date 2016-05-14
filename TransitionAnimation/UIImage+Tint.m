//
//  UIImage+Tint.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/14.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "UIImage+Tint.h"

@implementation UIImage (Tint)

- (UIImage *)imageWithTintColor: (UIColor *)tintColor blendMode: (CGBlendMode)mode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect: bounds blendMode: mode alpha: 1.0];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
