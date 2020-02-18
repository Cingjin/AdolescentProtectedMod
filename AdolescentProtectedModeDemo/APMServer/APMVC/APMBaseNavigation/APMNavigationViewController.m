//
//  APMNavigationViewController.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMNavigationViewController.h"
#import "APMButton+APMBtn.h"
#import "APMButton.h"
#import "APMHeader.h"

@interface APMNavigationViewController ()<UIGestureRecognizerDelegate>

/** backBtn*/
@property (nonatomic ,strong)  APMButton    * backBtn;

@end

@implementation APMNavigationViewController

+ (void)initialize {
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    UINavigationBar *bar = [UINavigationBar appearance];
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [bar setTitleTextAttributes:dict];
    bar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果push进来的不是第一个视图控制器
//    if (self.childViewControllers.count > 0) {
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

/**
 * 只需要在支持除竖屏以外方向的页面重写下边三个方法
 */
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 竖
    return [self.topViewController supportedInterfaceOrientations];
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return [self.topViewController prefersHomeIndicatorAutoHidden];
}

//允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark 点击事件

- (void)popClick {
    
    if (self.childViewControllers.count <= 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

- (APMButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [APMButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 40, 40);
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backBtn setImage:[UIImage imageNamed:@"icon_back_Gray"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back_Gray"] forState:UIControlStateHighlighted];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backBtn setTitleColor:APMColorRGB(155, 155, 155, 1.00) forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn apm_setExpendEdgeWithTop:20 right:10 bottom:0 left:10];
    }
    return _backBtn;
}

@end
