#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PhotoSrcType) {
    FromAlbum,
    FromCamera
};

@interface PhotoFromLocal : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (instancetype)initWithController: (UIViewController *)controller;
- (void)getPhotoFromType: (PhotoSrcType)type photoBlock: (void(^)(UIImage *image))aPhoto;

@end
