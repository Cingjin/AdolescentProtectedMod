//
//  APMHeader.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#ifndef APMHeader_h
#define APMHeader_h

/// SavaeKey

#define APM_PWD_KEY     @"APM_PWD_KEY"          // 密码保存Key


/// View

#import "APMSetView.h"
#import "CJAlertView.h"

/// Manager

#import "APMManager.h"

/// 关键宏

#define APMColorRGB(r, g, b ,a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]
#define APM_SIZE_WIDTH      [UIScreen mainScreen].bounds.size.width
#define APM_SIZE_HEIGHT     [UIScreen mainScreen].bounds.size.height


#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneXLater (iPhoneX || iPhoneR || iPhoneXSMax || iPhoneXS)

#define APMSafeAreaTopHeight       ((iPhoneXLater) ? 88 : 64)
#define APMSafeAreaBoHttomHeight   ((iPhoneXLater) ? 34 : 0)
#define APMStatusBarHeight         ((iPhoneXLater) ? 44 : 20)
#define APMStatusBarTopHeight      ((iPhoneXLater) ? 44 :0)
#define APMSafeAreaTabBarHeight    ((iPhoneXLater) ? 83 : 49)

#endif /* APMHeader_h */
