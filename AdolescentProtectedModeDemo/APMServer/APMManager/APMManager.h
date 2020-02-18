//
//  APMManager.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMManager : NSObject


+ (instancetype)apm_manager;

/**
 *  注册服务
 */
- (void)apm_regiseterServer;

/**
 *  青少年保护模式是否开启
 */
- (BOOL)apm_status;

/**
 *  展示青少年保护模式提示
 *  @param content  提示内容
 */
- (void)apm_showPromptsVcContent:(NSString * __nonnull)content;

/**
*  展示青少年保护模式开启界面
*  @param content  提示内容
*/
- (void)apm_showSetAPMVcContent:(NSString * __nonnull)content Block:(void(^)(BOOL status))block;

/**
 *  关闭青少年模式
 */
- (void)apm_turnOffProtected:(void(^)(BOOL status))block;


@end

NS_ASSUME_NONNULL_END
