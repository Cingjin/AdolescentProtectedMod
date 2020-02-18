//
//  APMTurnOffViewController.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/15.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMTurnOffViewController.h"
#import "APMForgetPwdViewController.h"
//view
#import "APMPwdInputView.h"
#import "CJAlertView.h"
#import "APMManager.h"

@interface APMTurnOffViewController ()

/// codeView
@property (nonatomic ,strong) APMPwdInputView   * codeView;


@end

@implementation APMTurnOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"输入密码继续使用";
    [self.view addSubview: self.codeView];
    [self apm_setBlock];
    
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIButton new]];
    
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)apm_setBlock {
    
    __weak typeof(self)weakSelf = self;
    self.codeView.titleStr      = self.titleStr;
    self.codeView.hiddenMarkLabel = self.hiddenMarkLabel;
    self.codeView.hiddenResetLabel = self.hiddenResetLabel;
    self.codeView.APMPwdBlock = ^(NSString * _Nonnull codeString) {
        // 如果输入密码正确，清除使用时长开启新的时长统计
        NSString * saveCode = [[NSUserDefaults standardUserDefaults]objectForKey:APM_PWD_KEY];
        if ([codeString isEqualToString:saveCode]) {
            // 关闭状态回调回去
            if (weakSelf.APMTrunOffBlock) {
                weakSelf.APMTrunOffBlock(YES);
            }
            // 页面消失继续使用
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{}];
        } else {
            [CJAlertView showMessage:@"密码错误,请重新输入" completion:^{ }];
        }
    };
    
    self.codeView.APMPwdResetBlock = ^{
        APMForgetPwdViewController * forgrtVc = [APMForgetPwdViewController new];
        forgrtVc.title = @"找回密码";
        [weakSelf.navigationController pushViewController:forgrtVc animated:YES];
    };
}

- (APMPwdInputView *)codeView {
    if (!_codeView) {
        _codeView = [[APMPwdInputView alloc]initWithFrame:self.view.frame];
        _codeView.bgColor = [UIColor clearColor];
    }
    return _codeView;
}


@end
