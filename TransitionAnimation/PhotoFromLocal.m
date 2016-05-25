#import "PhotoFromLocal.h"

typedef void (^PhotoBlock)(UIImage *);

@interface PhotoFromLocal ()

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, copy) PhotoBlock photoBlock;

@end

@implementation PhotoFromLocal

{
    UIViewController *baseController;
}

- (instancetype)initWithController: (UIViewController *)controller {
    self = [super init];
    if (self) {
        baseController = controller;
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    if (originalImage) {
        self.photoBlock(originalImage);
        [self.picker dismissViewControllerAnimated: YES completion: NULL];
        return;
    }
    
    if (editedImage) {
        self.photoBlock(editedImage);
        [self.picker dismissViewControllerAnimated: YES completion: NULL];
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.picker dismissViewControllerAnimated: YES completion: NULL];
}

#pragma mark - getPhoto from camera or album

- (void)getPhotoFromType: (PhotoSrcType)type photoBlock: (void(^)(UIImage *image))aPhoto {
    if (!baseController) {
        return;
    }
    self.photoBlock = aPhoto;
    
    switch (type) {
        case FromAlbum:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [baseController presentViewController: self.picker animated: YES completion: NULL];
            }
            break;
        }
            
        case FromCamera:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [baseController presentViewController: self.picker animated: YES completion: NULL];
            }
            break;
        }
    }
}

#pragma mark - setter and getter

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = NO;
    }
    return _picker;
}

@end
