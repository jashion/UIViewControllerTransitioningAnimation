//
//  HomeViewController.m
//  TransitionAnimation
//
//  Created by jashion on 16/5/5.
//  Copyright © 2016年 BMu. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailController.h"
#import "MyTableViewCell.h"
#import "ColorUtils.h"
#import "BMAnimateTransition.h"
#import "BMInteractiveTransition.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BMAnimateTransition *transition;
@property (nonatomic, strong) BMInteractiveTransition *interactive;

@end

@implementation HomeViewController
{
    NSArray *items;
    MyTableViewCell *selectedCell;
    UIView *snapView;
    CGRect snapFrame;
}

- (instancetype)init {
    if(self = [super init]) {
        items = @[@"Castle", @"Web", @"Sun", @"Chart", @"Signal"];
        self.navigationItem.title = @"Home";
        _transition = [BMAnimateTransition new];
        _interactive = [BMInteractiveTransition new];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.myTable = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style: UITableViewStylePlain];
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTable registerClass: [MyTableViewCell class] forCellReuseIdentifier: NSStringFromClass([MyTableViewCell class])];
    [self.view addSubview: self.myTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([MyTableViewCell class])];
    [cell setCellImage: [UIImage imageNamed: items[indexPath.row]]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(self.view.frame) * 3 /4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedCell = [tableView cellForRowAtIndexPath: indexPath];
    snapView = [selectedCell snapshotViewAfterScreenUpdates: NO];
    snapFrame = [selectedCell convertRect: selectedCell.contentView.frame toView: self.view];
    DetailController *detail = [[DetailController alloc] initWithTitle: items[indexPath.row] image: [UIImage imageNamed: items[indexPath.row]]];
    [self.interactive wireToViewController: detail operation: BMInteractiveTransitionSnapViewTransform];
    [self.navigationController pushViewController: detail animated: YES];
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        DetailController *detail = (DetailController *)toVC;
        self.transition.operation = BMAnimateTransitionSnapViewTransformPush;
        self.transition.duration = 0.6;
        self.transition.snapView = snapView;
        self.transition.initalView = selectedCell;
        self.transition.initalFrame = snapFrame;
        self.transition.finalView = detail.topImageView;
        self.transition.finalFrame = CGRectMake(0, 64, snapFrame.size.width, snapFrame.size.height);
        return self.transition;
    } else if (operation == UINavigationControllerOperationPop) {
        DetailController *detail = (DetailController *)fromVC;
        self.transition.operation = BMAnimateTransitionSnapViewTransformPop;
        self.transition.duration = 0.6;
        self.transition.snapView = [detail.topImageView snapshotViewAfterScreenUpdates: NO];
        self.transition.initalView = detail.topImageView;
        self.transition.initalFrame = [detail.topImageView convertRect: detail.topImageView.bounds toView: detail.view];
        self.transition.finalView = selectedCell;
        self.transition.finalFrame = snapFrame;
        return self.transition;
    } else {
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    
    return self.interactive.interacting ? self.interactive : nil;
}

@end
