//
//  APMPwdViewController.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMPwdViewController.h"
#import "APMForgetPwdViewController.h"

//view
#import "APMPwdInputView.h"

@interface APMPwdViewController ()

/// codeView
@property (nonatomic ,strong) APMPwdInputView   * codeView;

@end

@implementation APMPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview: self.codeView];
    
    [self apm_setBlock];
    
}

- (void)apm_setBlock {
    
    __weak typeof(self)weakSelf = self;
    self.codeView.titleStr      = self.titleStr;
    self.codeView.hiddenMarkLabel = self.hiddenMarkLabel;
    self.codeView.hiddenResetLabel = self.hiddenResetLabel;
    self.codeView.APMPwdBlock = ^(NSString * _Nonnull codeString) {
        if (weakSelf.pwdBlock) {
            weakSelf.pwdBlock(codeString);
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
    }
    return _codeView;
}

@end
