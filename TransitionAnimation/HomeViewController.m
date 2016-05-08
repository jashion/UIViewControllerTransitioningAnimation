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
#import "PushTransition.h"
#import "PopTransition.h"
#import "ColorUtils.h"
#import "PopInteractiveTransition.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) PushTransition *pushTransition;
@property (nonatomic, strong) PopTransition *popTransition;
@property (nonatomic, strong) PopInteractiveTransition *interactive;

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
        items = @[@"Book", @"Chair", @"Scene", @"Ice", @"Seed"];
        self.navigationItem.title = @"Home";
        _pushTransition = [PushTransition new];
        _popTransition = [PopTransition new];
        _interactive = [PopInteractiveTransition new];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.myTable = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style: UITableViewStylePlain];
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    [self.myTable registerClass: [MyTableViewCell class] forCellReuseIdentifier: NSStringFromClass([MyTableViewCell class])];
    [self.view addSubview: self.myTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
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
    [self.interactive wireToViewController: detail];
    [self.navigationController pushViewController: detail animated: YES];
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        self.pushTransition.type = PushTransitionSpringType;
        self.pushTransition.snapView = snapView;
        self.pushTransition.snapFrame = snapFrame;
        return self.pushTransition;
    } else if (operation == UINavigationControllerOperationPop) {
        self.popTransition.finalFrame = snapFrame;
        self.popTransition.selectedCell = selectedCell;
        self.popTransition.completed = YES;
        return self.popTransition;
    } else {
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    
    self.interactive.animatedTransition = animationController;
    return self.interactive.interacting ? self.interactive : nil;
}

@end
