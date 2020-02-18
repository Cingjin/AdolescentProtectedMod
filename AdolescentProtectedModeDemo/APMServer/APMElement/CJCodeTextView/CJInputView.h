//
//  CJInputView.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CJCodeViewBlock)(NSString * code);


@interface CJInputView : UIView


/// bgColor
@property (nonatomic ,strong) UIColor   * bgColor;

/// 当前输入的内容
@property (nonatomic ,copy ,readonly) NSString  * code;

/// 回调block
@property (nonatomic ,copy) CJCodeViewBlock     codeBlock;

/// 使用该方法进行初始化
-(instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;

/// 禁止使用的方法
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

@end

@interface CJ_lineView : UIView

/// colorView
@property (nonatomic ,weak) UIView  * colorView;

- (void)animation;

@end

@interface CJ_CursorLabel : UILabel


@property (nonatomic, weak, readonly) UIView *cursorView;

/// 光标动画
- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
