//
//  DetailController.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/4.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "DetailController.h"
#import "DetailTableViewCell.h"
#import "HomeViewController.h"
#import "PersonProfileViewController.h"
#import "PushTransition.h"
#import "PopTransition.h"
#import "PopInteractiveTransition.h"

#define kScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define topImageViewHeight kScreenWidth * 3 / 4

@interface DetailController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PushTransition *pushTransition;
@property (nonatomic, strong) PopTransition *popTransition;
@property (nonatomic, strong) PopInteractiveTransition *popInteractiveTransition;

@end

@implementation DetailController
{
    UIView *topImageContainer;
    UIImage *topImage;
    DetailTableViewCell *selectedCell;
    UIView *snapView;
    CGRect snapFrame;
    NSArray *names;
    NSArray *contents;
    NSArray *avatars;
    NSArray *titles;
}

- (instancetype)initWithTitle: (NSString *)title image: (UIImage *)image {
    if (self = [super init]) {
        self.navigationItem.title = title;
        self.hidesBottomBarWhenPushed = YES;
        _pushTransition = [PushTransition new];
        _popTransition = [PopTransition new];
        _popInteractiveTransition = [PopInteractiveTransition new];
        topImage = image;
        names = @[@"morgan", @"Jashion", @"Kevin Burr", @"Sean Furr", @"Marry", @"Stan", @"Sulian", @"Sheet"];
        contents = @[@"Awesome atmosphere.I like it!Can i get your contact?", @"Love it!You are very excellent!God bless you,AMEN.", @"Great!Something like you.I want to learn!Hehe,can you teach me?", @"like it to much.I painted it as you.", @"Nice :)", @"Sweet Lord.This is gorgeous,great job guys!", @"Supernice! Can i have it printed on poster please? :)", @"Whoa!This is amazing."];
        avatars = @[@"morgan", @"Jashion", @"Kevin Burr", @"Sean Furr", @"Marry", @"Stan", @"Sulian", @"Sheet"];
        titles = @[@"Roma Datsyuk", @"Balkan Brothers", @"Shamsuddin", @"Jakub Nespor", @"Thomas Meijer", @"Stan", @"Sulian", @"Sheet"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UIButton *backButton = [UIButton buttonWithType: UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 40, 44);
    [backButton setImage: [UIImage imageNamed:@"BackIcon"] forState: UIControlStateNormal];
    [backButton setImageEdgeInsets: UIEdgeInsetsMake(0, - 30, 0, 0)];
    [backButton addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backButton];
    
    self.detailTableView = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style: UITableViewStyleGrouped];
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    [self.detailTableView registerClass: [DetailTableViewCell class] forCellReuseIdentifier: NSStringFromClass([DetailTableViewCell class])];
    self.detailTableView.contentInset = UIEdgeInsetsMake(topImageViewHeight, 0, 0, 0);
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.detailTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview: self.detailTableView];
    
    topImageContainer = [[UIView alloc] initWithFrame: CGRectMake(0, - topImageViewHeight, kScreenWidth, topImageViewHeight)];
    topImageContainer.clipsToBounds = YES;
    [self.detailTableView addSubview: topImageContainer];
    
    self.topImageView = [[UIImageView alloc] initWithFrame: topImageContainer.bounds];
    self.topImageView.image = topImage;
    self.topImageView.contentMode = UIViewContentModeScaleToFill;
    [topImageContainer addSubview: self.topImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    for (UIViewController *subVC in self.navigationController.viewControllers) {
        if ([subVC isKindOfClass: [HomeViewController class]]) {
            self.navigationController.delegate = (HomeViewController *)subVC;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([DetailTableViewCell class])];
    [cell setAvatar: [UIImage imageNamed: avatars[indexPath.row]] name: names[indexPath.row] des: contents[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *buttonsContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 60)];
    buttonsContainer.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1.0];
    
    CGFloat buttonWidth = (buttonsContainer.frame.size.width - 1) / 3;
    CGFloat buttonHeight = buttonsContainer.frame.size.height - 0.5;
    
    UIButton *clikedLikeButton = [self createButtonWithImage: [UIImage imageNamed:@"LikeIcon"] title: @"2048" frame: CGRectMake(0, 0.5, buttonWidth, buttonHeight)];
    [buttonsContainer addSubview: clikedLikeButton];
    
    UIButton *clickedCommentButton = [self createButtonWithImage: [UIImage imageNamed:@"CommentIcon"] title: @"10086" frame: CGRectMake(buttonWidth + 0.5, 0.5, buttonWidth, buttonHeight)];
    [buttonsContainer addSubview: clickedCommentButton];
    
    UIButton *clickedFollowButton = [self createButtonWithImage: [UIImage imageNamed:@"FollowIcon"] title: @"250" frame: CGRectMake(buttonWidth * 2 + 1, 0.5, buttonWidth, buttonHeight)];
    [buttonsContainer addSubview: clickedFollowButton];
    
    return buttonsContainer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationController.delegate = self;
    selectedCell = [tableView cellForRowAtIndexPath: indexPath];
    selectedCell.selected = NO;
    snapView = [selectedCell.avatarImageView snapshotViewAfterScreenUpdates: NO];
    snapFrame = [selectedCell.avatarImageView convertRect: selectedCell.avatarImageView.bounds toView: self.view];
    PersonProfileViewController *person = [[PersonProfileViewController alloc] initWithName: names[indexPath.row] title: titles[indexPath.row]];
    [self.popInteractiveTransition wireToViewController: person];
    [self.navigationController pushViewController: person animated: YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + topImageViewHeight + 64;
    if (offset < 0) {
        topImageContainer.bounds = CGRectMake(0, 0, kScreenWidth - offset, topImageViewHeight - offset);
        topImageContainer.center = CGPointMake(kScreenWidth / 2, - topImageViewHeight / 2 + offset / 2);
        self.topImageView.frame = topImageContainer.bounds;
    } else if(offset > 0){
        self.topImageView.center = CGPointMake(kScreenWidth / 2, topImageViewHeight / 2 + offset / 3);
    } else {
       [UIView animateWithDuration: 0.1 animations:^{
           topImageContainer.frame = CGRectMake(0, - topImageViewHeight, kScreenWidth, topImageViewHeight);
           self.topImageView.frame = topImageContainer.bounds;
       }];
    }
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  {
    
    
    if (operation == UINavigationControllerOperationPush) {
        self.pushTransition.type = PushTransitionCircleMaskType;
        self.pushTransition.snapView = snapView;
        self.pushTransition.snapFrame = snapFrame;
        self.pushTransition.duration = 0.4;
        return self.pushTransition;
    } else if (operation == UINavigationControllerOperationPop) {
        self.popTransition.type = PopTransitionCircleMaskType;
        self.popTransition.finalView = snapView;
        self.popTransition.finalFrame = snapFrame;
        self.popTransition.duration = 0.4;
        self.popTransition.completed = YES;
        return  self.popTransition;
    } else {
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    self.popInteractiveTransition.animatedTransition = animationController;
    return self.popInteractiveTransition.interacting ? self.popInteractiveTransition : nil;
}

#pragma mark - Event Response

- (void)back {
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Private Method

- (UIButton *)createButtonWithImage: (UIImage *)image title: (NSString *)title frame: (CGRect)frame {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
    button.titleEdgeInsets = UIEdgeInsetsMake(26, 0, 0, 0);
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [button addTarget: self action: @selector(buttonBgColorChange:) forControlEvents: UIControlEventTouchDown];
    [button addTarget: self action: @selector(buttonBgColorReset:) forControlEvents: UIControlEventTouchDragOutside];
    [button addTarget: self action: @selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.bounds = CGRectMake(0, 0, frame.size.height / 2, frame.size.height / 2);
    imageView.center = CGPointMake(frame.size.width / 2, frame.size.height / 4);
    [button addSubview: imageView];
    return button;
}

- (void)buttonBgColorChange: (id)sender {
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
}

- (void)buttonBgColorReset: (id)sender {
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor whiteColor];
}

- (void)buttonClick: (id)sender {
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor whiteColor];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Congratulation!" message: @"Hello world!" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle: @"OK!" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated: YES completion: nil];
    }];
    [alert addAction: action];
    [self presentViewController: alert animated: YES completion: nil];
}

@end
