//
//  APMPromptsViewController.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMPromptsViewController.h"
#import "APMSetViewController.h"

@interface APMPromptsViewController ()

@end

@implementation APMPromptsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.hiddenNavBar) {
        self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    }
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 200, 100)];
    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.text = @"这里做引导提示";
    [self.view addSubview:titleLabel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.hiddenNavBar) {
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIButton new]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.hiddenNavBar) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setHiddenNavBar:(BOOL)hiddenNavBar {
    _hiddenNavBar = hiddenNavBar;
}


@end
