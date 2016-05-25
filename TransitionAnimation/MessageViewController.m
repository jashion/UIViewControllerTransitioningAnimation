//
//  MessageViewController.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/5.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "MessageViewController.h"
#import "PhotoFromLocal.h"

#define kRect           [UIScreen mainScreen].bounds
#define itemWith        (kRect.size.width - 50) / 4
#define itemHeight      (kRect.size.width - 50) / 4

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface MessageViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (nonatomic, strong) UICollectionView *photoContainerView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) PhotoFromLocal *photoPicker;

@end

@implementation MessageViewController

- (instancetype)init {
    if (self = [super init]) {
        self.navigationItem.title = @"Message";
        _photos = @[].mutableCopy;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemWith, itemHeight);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.photoContainerView = [[UICollectionView alloc] initWithFrame: [UIScreen mainScreen].bounds collectionViewLayout: flowLayout];
    self.photoContainerView.dataSource = self;
    self.photoContainerView.delegate = self;
    self.photoContainerView.backgroundColor = [UIColor whiteColor];
    self.photoContainerView.bounces = YES;
    [self.photoContainerView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: NSStringFromClass([UICollectionViewCell class])];
    [self.view addSubview: self.photoContainerView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: NSStringFromClass([UICollectionViewCell class]) forIndexPath: indexPath];
    
    UIImage *image;
    if (indexPath.row != self.photos.count) {
        image = self.photos[indexPath.row];
    } else {
        image = [UIImage imageNamed:@"PhotoAddButton"];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.frame = CGRectMake(0, 0, itemWith, itemHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell.contentView addSubview: imageView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.photos.count) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (iOS8Later) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil message: nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *videoAction = [UIAlertAction actionWithTitle: @"小视频" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             self.photoPicker = [[PhotoFromLocal alloc] initWithController: self];
            [self.photoPicker getPhotoFromType: FromCamera photoBlock:^(UIImage *image) {
                [weakSelf.photos addObject: image];
                [weakSelf.photoContainerView reloadData];
            }];
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle: @"从手机相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction: videoAction];
        [alert addAction: photoAction];
        [alert addAction: albumAction];
        [alert addAction: cancelAction];
        [self presentViewController: alert animated: YES completion: nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: nil otherButtonTitles: @"小视频", @"拍照", @"从手机相册选择", nil];
        [actionSheet showInView: self.view];
    }
#pragma clang diagnostic pop
}

#pragma mark - UIActionSheetDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            break;
        }
        
        case 1:
        {
            break;
        }

        case 2:
        {
            break;
        }
            
        default:
            break;
    }
}

#pragma clang diagnostic pop

@end
