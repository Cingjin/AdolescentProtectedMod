//
//  ViewController.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "ViewController.h"
#import "APMManagerHeader.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [[APMManager apm_manager]apm_regiseterServer];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, 200, 200, 100)];
    button.backgroundColor = [UIColor orangeColor];
    button.tag = 0;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"点击设置青少年模式" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, CGRectGetMaxY(button.frame) + 30, 200, 100)];
    button1.backgroundColor = [UIColor orangeColor];
    button1.tag = 1;
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"点击关闭青少年模式" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
}

- (void)buttonAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        [[APMManager apm_manager]apm_showSetAPMVcContent:self.content Block:^(BOOL status) {
            NSLog(@"123开启青少年保护模式成功");
        }];
    } else {
        [[APMManager apm_manager]apm_turnOffProtected:^(BOOL status) {
            NSLog(@"关闭青少年保护模式 %@",status?@"YES":@"NO");
        }];
    }
}

- (NSString *)content {
    return @"在青少年模式中，我们精选了一批教育类、知识类内容在首页，且无法开启直播功能\n开启青少年模式后，将自动为您开启时间锁，单日使用时不超过40分钟，晚上10点至早上6点无法使用影视大全，开启青少年模式后，将自动为您开启时间锁，单日使用时不超过40分钟，晚上10点至早上6点无法使用影视大全，开启青少年模式后，将自动为您开启时间锁，单日使用时不超过40分钟，晚上10点至早上6点无法使用影视大全\n开启青少年模式需要设置独立密码，如果忘记可通过找回密码重置";
}

@end
