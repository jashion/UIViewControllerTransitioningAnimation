//
//  PersonProfileViewController.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/8.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "PersonProfileViewController.h"
#import "MyTableViewCell.h"
#import "ColorUtils.h"
#import "FXBlurView.h"

#define kScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define topImageViewHeight kScreenWidth * 3 / 4
#define topHeight (topImageViewHeight - 96)

@interface PersonProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PersonProfileViewController
{
    NSString *personName;
    NSString *personTitle;
    UITableView *personTableView;
    NSArray *photos;
    UIView *topImageContainer;
    UIImageView *topImageView;
    UIView *effectView;
    UIView *desContentView;
}

- (instancetype)initWithName: (NSString *)name title: (NSString *)title{
    if (self = [super init]) {
        personName = name;
        personTitle = title;
        self.navigationItem.title = name;
        photos = @[@"Web", @"PeaceMidNight", @"Signal", @"Castle", @"Sun", @"Chart", @"Animal"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1];
    
    personTableView = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style: UITableViewStyleGrouped];
    personTableView.dataSource = self;
    personTableView.delegate = self;
    [personTableView registerClass: [MyTableViewCell class] forCellReuseIdentifier: NSStringFromClass([MyTableViewCell class])];
    personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    personTableView.contentInset = UIEdgeInsetsMake(topHeight, 0, 0, 0);
    [self.view addSubview: personTableView];
    
    topImageContainer = [[UIView alloc] initWithFrame: CGRectMake(0, - topHeight, kScreenWidth, topHeight)];
    topImageContainer.clipsToBounds = YES;
    [personTableView addSubview: topImageContainer];
    
    topImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Sun"]];
    topImageView.frame = CGRectMake(0,  - 64, kScreenWidth, topImageViewHeight);
    [topImageContainer addSubview: topImageView];
    
    effectView = [[UIView alloc] init];
    effectView.frame = topImageContainer.bounds;
    effectView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.55];
    [topImageContainer addSubview: effectView];
    
    desContentView = [[UIView alloc] initWithFrame: topImageContainer.frame];
    [personTableView addSubview: desContentView];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize: 32];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = personTitle;
    title.frame = CGRectMake(0, 20, kScreenWidth, 50);
    [desContentView addSubview: title];
    
    UILabel *author = [[UILabel alloc] init];
    author.font = [UIFont systemFontOfSize: 16];
    author.textColor = [UIColor whiteColor];
    author.textAlignment = NSTextAlignmentCenter;
    author.text = personName;
    author.frame = CGRectMake(0, 70, kScreenWidth, 30);
    [desContentView addSubview: author];
    
    UILabel *follow = [[UILabel alloc] init];
    follow.frame = CGRectMake((kScreenWidth - 130) / 2, 110, 130, 30);
    follow.font = [UIFont boldSystemFontOfSize: 14];
    follow.textColor = [UIColor whiteColor];
    follow.layer.cornerRadius = 15;
    follow.layer.borderColor = [UIColor whiteColor].CGColor;
    follow.layer.borderWidth = 2;
    follow.textAlignment = NSTextAlignmentCenter;
    follow.text = @"Follow";
    [desContentView addSubview: follow];
    
    UIImageView *left = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"PersooLeft"]];
    left.frame = CGRectMake(80, 110, 30, 30);
    [desContentView addSubview: left];
    
    UIImageView *right = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"PersonRight"]];
    right.frame = CGRectMake(kScreenWidth - 110, 110, 30, 30);
    [desContentView addSubview: right];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([MyTableViewCell class])];
    [cell setCellImage: [UIImage imageNamed: photos[indexPath.row]]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return topImageViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *buttonsContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 120)];
    buttonsContainer.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1];
    CGFloat buttonWidth = (kScreenWidth - 0.5) / 2;
    CGFloat buttonHeight = (120 - 0.5) / 2;
    UIButton *followerButton = [self createButtonWithTopTitle: @"7785" topTitleColor: [UIColor blackColor] bottomTitle: @"Followers" bottomTitleColor: [ColorUtils mainColor] buttonBgColor: [UIColor whiteColor] frame: CGRectMake(0, 0, buttonWidth, buttonHeight)];
    followerButton.tag = 0;
    UIButton *followingButton = [self createButtonWithTopTitle: @"652" topTitleColor: [UIColor blackColor] bottomTitle: @"Following" bottomTitleColor: [ColorUtils mainColor] buttonBgColor: [UIColor whiteColor] frame: CGRectMake(buttonWidth + 0.5, 0, buttonWidth, buttonHeight)];
    followingButton.tag = 1;
    UIButton *shotsButton = [self createButtonWithTopTitle: @"Shots" topTitleColor: [UIColor whiteColor] bottomTitle: @"122" bottomTitleColor: [UIColor whiteColor] buttonBgColor: [ColorUtils mainColor] frame: CGRectMake(0, buttonHeight + 0.5, buttonWidth, buttonHeight)];
    shotsButton.tag = 2;
    UIButton *likesButton = [self createButtonWithTopTitle: @"Likes" topTitleColor: [UIColor whiteColor] bottomTitle: @"1253" bottomTitleColor: [UIColor whiteColor] buttonBgColor: [ColorUtils mainColor] frame: CGRectMake(buttonWidth + 0.5, buttonHeight + 0.5, buttonWidth, buttonHeight)];
    likesButton.tag = 3;
    [buttonsContainer addSubview: followerButton];
    [buttonsContainer addSubview: followingButton];
    [buttonsContainer addSubview: shotsButton];
    [buttonsContainer addSubview: likesButton];
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: personName]];
    avatarImageView.bounds = CGRectMake(0, 0, 64, 64);
    avatarImageView.center = CGPointMake(kScreenWidth / 2, 0);
    avatarImageView.backgroundColor = [UIColor whiteColor];
    avatarImageView.layer.cornerRadius = 32;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.layer.borderWidth = 3;
    [buttonsContainer addSubview: avatarImageView];
    return buttonsContainer;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + topHeight + 64;
    if (offset <= 0 && offset >= - 96) {
        topImageContainer.frame = CGRectMake(0, - topHeight + offset, kScreenWidth, topHeight - offset);
        topImageView.frame = CGRectMake(0, - 64 - offset * 2 / 3, kScreenWidth, topImageViewHeight);
    } else if(offset < - 96){
        CGFloat offsetY = - offset - 96;
        topImageContainer.bounds = CGRectMake(0, 0, kScreenWidth + offsetY, topImageViewHeight + offsetY);
        topImageContainer.center = CGPointMake(kScreenWidth / 2, - topImageContainer.bounds.size.height / 2);
        topImageView.frame = CGRectMake(0, 0, topImageContainer.bounds.size.width, topImageContainer.bounds.size.height);
    } else {
        [UIView animateWithDuration: 0.1 animations:^{
            topImageContainer.frame = CGRectMake(0, - topHeight, kScreenWidth, topHeight);
            topImageView.frame = CGRectMake(0, - 64, kScreenWidth, topImageViewHeight);
        }];
    }
    effectView.frame = topImageContainer.bounds;
}

#pragma mark - Private Method

- (UIButton *)createButtonWithTopTitle: (NSString *)topTitle topTitleColor: (UIColor *)topTitleColor bottomTitle: (NSString *)bottomTitle bottomTitleColor: (UIColor *)bottomTitleColor buttonBgColor: (UIColor *)bgColor frame: (CGRect)frame {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = bgColor;
    button.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
    button.titleEdgeInsets = UIEdgeInsetsMake(26, 0, 0, 0);
    [button setTitle: bottomTitle forState: UIControlStateNormal];
    [button setTitleColor: bottomTitleColor forState: UIControlStateNormal];
    [button addTarget: self action: @selector(buttonBgColorChange:) forControlEvents: UIControlEventTouchDown];
    [button addTarget: self action: @selector(buttonBgColorReset:) forControlEvents: UIControlEventTouchDragOutside];
    [button addTarget: self action: @selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height / 2);
    topLabel.center = CGPointMake(frame.size.width / 2, frame.size.height / 4);
    topLabel.font = [UIFont systemFontOfSize: 18];
    topLabel.textColor = topTitleColor;
    topLabel.text = topTitle;
    [button addSubview: topLabel];
    return button;
}

- (void)buttonBgColorChange: (id)sender {
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
}

- (void)buttonBgColorReset: (id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag / 2 == 0) {
        button.backgroundColor = [UIColor whiteColor];
    } else {
        button.backgroundColor = [ColorUtils mainColor];
    }
}

- (void)buttonClick: (id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag / 2 == 0) {
        button.backgroundColor = [UIColor whiteColor];
    } else {
        button.backgroundColor = [ColorUtils mainColor];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil message: button.titleLabel.text preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle: @"cancel" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated: YES completion: nil];
    }];
    [alert addAction: action];
    [self presentViewController: alert animated: YES completion: nil];
}

@end
