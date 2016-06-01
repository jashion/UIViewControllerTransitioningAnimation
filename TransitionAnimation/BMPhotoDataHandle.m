//
//  BMPhotoDataHandle.m
//  TransitionAnimation
//
//  Created by jashion on 16/6/1.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "BMPhotoDataHandle.h"

@interface BMPhotoDataHandle ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

@end

@implementation BMPhotoDataHandle

+ (instancetype)getInstance {
    static BMPhotoDataHandle *instance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
       instance = [BMPhotoDataHandle new];
    });
    return instance;
}

- (BOOL)authorizationStatusAuthorized {
    if (iOS8Later && [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        return YES;
    } else if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Setter & Getter

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (PHCachingImageManager *)cachingImageManager {
    if (_cachingImageManager) {
        _cachingImageManager = [[PHCachingImageManager alloc] init];
    }
    return _cachingImageManager;
}

@end
