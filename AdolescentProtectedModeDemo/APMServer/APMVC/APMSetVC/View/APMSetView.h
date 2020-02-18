//
//  APMSetView.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, APMPwdType) {
    APMPwdSet,      // 用户设置密码
    APMPwdVerify,   // 用户验证密码
    APMPwdReset,    // 用户重置密码
};

@interface APMSetView : UIView

/** APMOnBlock*/
@property (nonatomic ,copy) void(^APMOnBlock)(APMPwdType type);

- (instancetype)initWithFrame:(CGRect)frame Content:(NSString *)content;

- (void)apm_reloadView;

@end

NS_ASSUME_NONNULL_END
