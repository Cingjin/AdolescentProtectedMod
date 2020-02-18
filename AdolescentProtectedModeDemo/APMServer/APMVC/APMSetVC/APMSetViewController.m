//
//  APMSetViewController.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMSetViewController.h"
#import "APMPromptsViewController.h"
#import "APMPwdViewController.h"

@interface APMSetViewController ()

/** setView*/
@property (nonatomic ,strong) APMSetView    * setView;

@end

@implementation APMSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"青少年模式";
    
    [self apm_addSubView];
    
}

#pragma mark - View

- (void)apm_addSubView {
     
    [self.view addSubview:self.setView];
    // 设置block
    [self apm_configBlcok];
}


#pragma mark - configBlock

- (void)apm_configBlcok {
    
    __weak typeof(self)weakSelf = self;
    self.setView.APMOnBlock = ^(APMPwdType type) {
        BOOL resetType = type == APMPwdReset;
        // 开启青少年保护模式
        APMPwdViewController * pwdVc = [[APMPwdViewController alloc]init];
        pwdVc.title = resetType?@"修改密码":@"密码验证";
        pwdVc.titleStr = resetType?@"输入原密码":@"输入密码";
        pwdVc.hiddenMarkLabel = resetType || type == APMPwdVerify;
        pwdVc.hiddenResetLabel = (resetType || type == APMPwdVerify)?NO:YES;
        [weakSelf.navigationController pushViewController:pwdVc animated:YES];
        __weak APMPwdViewController * weakpwdVc = pwdVc;
        pwdVc.pwdBlock = ^(NSString * _Nonnull pwdString) { // 密码输入完成后要做的事情
            if (type == APMPwdSet) {    // 设置密码
                [weakSelf apm_surePwd:weakpwdVc PwdStr:pwdString resetPwd:NO];
            } else if (type == APMPwdVerify){ // 关闭密码
                [weakSelf apm_verifyPwd:weakpwdVc PwdStr:pwdString resetPwd:NO];
            }else { // 重设密码
                [weakSelf apm_verifyPwd:weakpwdVc PwdStr:pwdString resetPwd:YES];
            }
        };
    };
}

/// 二次输入密码

- (void)apm_surePwd:(UIViewController *)vc PwdStr:(NSString *)pwdStr resetPwd:(BOOL)reset{
    
    APMPwdViewController * pwdVcSure = [[APMPwdViewController alloc]init];
    pwdVcSure.title = reset?@"修改密码":@"密码验证";
    pwdVcSure.titleStr =reset?@"确认新密码":@"确认密码";
    pwdVcSure.hiddenMarkLabel = reset;
    pwdVcSure.hiddenResetLabel = YES;
    __weak typeof(self)weakSelf = self;
    __weak APMPwdViewController * weakpwdVc = pwdVcSure;
    pwdVcSure.pwdBlock = ^(NSString * _Nonnull pwdString) {
        // 验证密码
        [weakSelf apm_surePwdStr1:pwdStr PwdStr2:pwdString nowVC:weakpwdVc resetPwd:reset];
    };
    [vc.navigationController pushViewController:pwdVcSure animated:YES];
}

/// 确认密码

- (void)apm_surePwdStr1:(NSString *)pwd1 PwdStr2:(NSString *)pwd2 nowVC:(UIViewController *)vc resetPwd:(BOOL)reset{
    if ([pwd1 isEqualToString:pwd2]) {
        // 视图刷新
        [self.setView apm_reloadView];
        [CJAlertView showMessage:reset?@"修改密码成功":@"青少年模式开启成功" completion:^{}];
        // 回调Block
        if (self.APMSetViewBlock) {
            self.APMSetViewBlock(pwd1, reset?APMPwdReset:APMPwdSet,vc);
        }
    }else {
        [CJAlertView showMessage:@"两次密码不一致,请重新输入" completion:^{}];
    }
}

/// 验证密码

- (void)apm_verifyPwd:(UIViewController *)vc PwdStr:(NSString *)pwdStr resetPwd:(BOOL)reset{
    
    NSString * savePwd = [[NSUserDefaults standardUserDefaults]objectForKey:APM_PWD_KEY];
    if ([savePwd isEqualToString:pwdStr]) {
        if (reset) {
            APMPwdViewController * pwdVc = [[APMPwdViewController alloc]init];
            pwdVc.title = @"修改密码";
            pwdVc.titleStr = @"输入新密码";
            pwdVc.hiddenMarkLabel = NO;
            pwdVc.hiddenResetLabel = YES;
            [self.navigationController pushViewController:pwdVc animated:YES];
            __weak APMPwdViewController * weakpwdVc = pwdVc;
            __weak typeof(self)weakSelf = self;
            pwdVc.pwdBlock = ^(NSString * _Nonnull pwdString) { // 密码输入完成后要做的事情
                [weakSelf apm_surePwd:weakpwdVc PwdStr:pwdString resetPwd:YES];
            };
        }else {
            
            [self.setView apm_reloadView];
            [CJAlertView showMessage:@"关闭青少年保护模式" completion:^{}];
            if (self.APMSetViewBlock) {
                self.APMSetViewBlock(@"", APMPwdVerify, vc);
            }
        }
    }else {
        [CJAlertView showMessage:@"原密码错误,请重新输入" completion:^{
            
        }];
    }
}

#pragma mark - Lazy

- (APMSetView *)setView {
    if (!_setView) {
        _setView = [[APMSetView alloc]initWithFrame:self.view.frame Content:self.userContent];
    }
    return _setView;
}


@end
