//
//  APMSetViewController.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APMSetViewController : APMBaseViewController

/** userContent*/
@property (nonatomic ,copy) NSString    * userContent;

/** 回调block*/
@property (nonatomic ,copy) void(^APMSetViewBlock)(NSString * pwd ,APMPwdType type,UIViewController *vc);

@end

NS_ASSUME_NONNULL_END
