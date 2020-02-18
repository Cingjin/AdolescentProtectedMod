//
//  APMPwdViewController.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^APMPwdBlcok)(NSString * pwdString);

@interface APMPwdViewController : APMBaseViewController

/// 密码回调
@property (nonatomic ,copy) APMPwdBlcok         pwdBlock;

/// titleStr
@property (nonatomic ,copy) NSString        * titleStr;

/// hiddenMarkLabel
@property (nonatomic ,assign) BOOL          hiddenMarkLabel;

/// hiddenResetLabel
@property (nonatomic ,assign) BOOL          hiddenResetLabel;

@end

NS_ASSUME_NONNULL_END
