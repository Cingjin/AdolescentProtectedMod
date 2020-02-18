//
//  APMPwdInputView.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMPwdInputView : UIView

/// codeBlock
@property (nonatomic ,copy) void(^APMPwdBlock)(NSString * codeString);

/// resetActionBlock
@property (nonatomic ,copy) void(^APMPwdResetBlock)(void);

/// hiddenMarkLabel
@property (nonatomic ,assign) BOOL          hiddenMarkLabel;

/// hiddenResetLabel
@property (nonatomic ,assign) BOOL          hiddenResetLabel;

/// titleStr
@property (nonatomic ,copy) NSString        * titleStr;

/// bgColor
@property (nonatomic ,strong) UIColor       * bgColor;

@end

NS_ASSUME_NONNULL_END
