//
//  APMPwdInputView.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMPwdInputView.h"
#import "CJInputView.h"
#import "APMHeader.h"


@interface APMPwdInputView ()

/** titleLabel*/
@property (nonatomic ,strong) UILabel       * titleLabel;

/** markLabel*/
@property (nonatomic ,strong) UILabel       * markLabel;

/** resetLabel*/
@property (nonatomic ,strong) UILabel       * resetLabel;

/** codeView*/
@property (nonatomic ,strong) CJInputView   * codeView;




@end

@implementation APMPwdInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self apm_buildInit];
        [self apm_setLayout];
        [self apm_setBlock];
        [self apm_resetLabelText];
        [self apm_addNSNOtification];
        [self addSubview:self.titleLabel];
        [self addSubview:self.codeView];
        [self addSubview:self.markLabel];
        [self addSubview:self.resetLabel];
    }
    return self;
}

- (void)apm_buildInit {
    self.bgColor = [UIColor whiteColor];
    
}

- (void)apm_setBlock {
    
    __weak typeof(self)weakSelf = self;
    self.codeView.codeBlock = ^(NSString * _Nonnull code) {
        if (weakSelf.APMPwdBlock) {
            weakSelf.APMPwdBlock(code);
        }
    };
}

- (void)apm_addNSNOtification {
    
   //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                             name:UIKeyboardWillChangeFrameNotification
                                             object:nil];
}

// 监听键盘的弹出和隐藏
- (void)keyboardWillChangeFrame:(NSNotification *)noti{
    // 键盘最终的frame
    CGRect keyboradF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.resetLabel.transform = CGAffineTransformMakeTranslation(0, keyboradF.origin.y-self.frame.size.height);
    }];
}

- (void)apm_setLayout {
    
    self.titleLabel.frame = CGRectMake(0, 60, self.frame.size.width, 30);
    
    CGFloat codeViewY = CGRectGetMaxY(self.titleLabel.frame) + 58;
    CGFloat codeViewX = 72;
    CGFloat codeViewW = self.frame.size.width - (72*2);
    self.codeView.frame = CGRectMake(codeViewX,codeViewY,codeViewW, 60);
    
    CGFloat labelY = CGRectGetMaxY(self.codeView.frame) + 39;
    self.markLabel.frame = CGRectMake(0, labelY, self.frame.size.width, 22);
    self.resetLabel.frame = CGRectMake(0, APM_SIZE_HEIGHT - 90 - APMSafeAreaTopHeight, self.frame.size.width, 60);
    
}

- (void)apm_resetLabelText {
    
    NSString * str = @"申诉重置";
    NSString * content = @"忘记密码，请申诉重置";
    //rgba(60,125,235,1.00)
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:APMColorRGB(139, 146, 153, 1.00)}];
    NSRange rang = [content rangeOfString:str];
    // rgba(139,146,153,1.00)
    [attr addAttribute:NSForegroundColorAttributeName value:APMColorRGB(60, 125, 235, 1.00) range:rang];
    self.resetLabel.attributedText = attr;
    
}

- (void)apm_resetClick {
    if (self.APMPwdResetBlock) {
        self.APMPwdResetBlock();
    }
}

#pragma mark - Setter

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = self.titleStr;
}

- (void)setHiddenMarkLabel:(BOOL)hiddenMarkLabel {
    _hiddenMarkLabel = hiddenMarkLabel;
    self.markLabel.hidden = self.hiddenMarkLabel;
}

- (void)setHiddenResetLabel:(BOOL)hiddenResetLabel {
    _hiddenResetLabel = hiddenResetLabel;
    self.resetLabel.hidden = self.hiddenResetLabel;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    
    self.backgroundColor = self.bgColor;
    self.codeView.bgColor = self.bgColor;
}

#pragma mark - Lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = APMColorRGB(61, 73, 85, 1.00);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"输入密码";
    }
    return _titleLabel;
}

- (UILabel *)markLabel {
    if (!_markLabel) {
        _markLabel = [[UILabel alloc]init];
        _markLabel.font = [UIFont boldSystemFontOfSize:15];//rgba(139,146,153,1.00)
        _markLabel.textColor = APMColorRGB(139, 146, 153, 1.00);
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.hidden = NO;
        _markLabel.text = @"关闭青少年模式，请输入开启时设置的密码";
    }
    return _markLabel;
}

- (UILabel *)resetLabel {
    if (!_resetLabel) {
        _resetLabel = [[UILabel alloc]init];
        _resetLabel.textAlignment = NSTextAlignmentCenter;
        _resetLabel.font = [UIFont boldSystemFontOfSize:15];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(apm_resetClick)];
        _resetLabel.userInteractionEnabled = YES;
        _resetLabel.hidden = YES;
        [_resetLabel addGestureRecognizer:tap];
    }
    return _resetLabel;
}

- (CJInputView *)codeView {
    if (!_codeView) {
        _codeView = [[CJInputView alloc]initWithCount:4 margin:20];
    }
    return _codeView;
}


@end
