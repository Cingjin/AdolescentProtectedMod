//
//  APMBaseViewController.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMBaseViewController.h"

@interface APMBaseViewController ()

@end

@implementation APMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self apm_baseSet];
}

- (void)dealloc {
    NSLog(@"__%s__",__func__);
}

- (void)apm_baseSet {
    
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
