//
//  BMPhotoDataHandle.h
//  TransitionAnimation
//
//  Created by jashion on 16/6/1.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface BMPhotoDataHandle : NSObject

+ (instancetype)getInstance;

- (BOOL)authorizationStatusAuthorized;

@end
