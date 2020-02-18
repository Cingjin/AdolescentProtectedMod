//
//  CJInputView.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJInputView.h"
#import "APMHeader.h"

@interface CJInputView ()

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) CGFloat itemMargin;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UIControl *maskView;

@property (nonatomic, strong) NSMutableArray<CJ_CursorLabel *> *labels;

@property (nonatomic, strong) NSMutableArray<CJ_lineView *> *lines;

@property (nonatomic, weak) CJ_CursorLabel * currentLabel;
/// 临时保存上次输入的内容(用于判断 删除 还是 输入)
@property (nonatomic, copy) NSString *tempStr;


@end

@implementation CJInputView


- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin
{
    if (self = [super init]) {
    
        self.itemCount = count;
        self.itemMargin = margin;
        
        [self apm_buildInit];
        [self configTextField];
    }
    return self;
}

- (void)apm_buildInit {
    // 初始化默认颜色
    self.bgColor = [UIColor whiteColor];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    
    self.backgroundColor            = self.bgColor;
    self.textField.backgroundColor  = self.bgColor;
    self.maskView.backgroundColor   = self.bgColor;
}

- (void)configTextField
{
    self.backgroundColor = self.bgColor;
    
    self.labels = @[].mutableCopy;
    self.lines = @[].mutableCopy;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [self addSubview:textField];
    self.textField = textField;
    [self.textField becomeFirstResponder];
    
    UIButton *maskView = [UIButton new];
    [maskView addTarget:self action:@selector(clickMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:maskView];
    self.maskView = maskView;
    
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        CJ_CursorLabel *label = [CJ_CursorLabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:41.5];
        [self addSubview:label];
        [self.labels addObject:label];
    }
    
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        CJ_lineView *line = [CJ_lineView new];
        line.backgroundColor =  APMColorRGB(204,206,208,1.00);
        [self addSubview:line];
        [self.lines addObject:line];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.labels.count != self.itemCount) return;
    
    CGFloat temp = self.bounds.size.width - (self.itemMargin * (self.itemCount - 1));
    CGFloat w = temp / self.itemCount;
    CGFloat x = 0;
    
    for (NSInteger i = 0; i < self.labels.count; i++)
    {
        x = i * (w + self.itemMargin);
        
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(x, 0, w, self.bounds.size.height);
        
        UIView *line = self.lines[i];
        line.frame = CGRectMake(x, self.bounds.size.height - 1, w, 1);
    }
    
    self.textField.frame = CGRectMake(1000, 0, 0, 0); //把TextField放在屏幕外
    self.maskView.frame = self.bounds;
}

#pragma mark - 编辑改变
- (void)tfEditingChanged:(UITextField *)textField
{
    if (textField.text.length > self.itemCount) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.itemCount)];
    }
    
    for (int i = 0; i < self.itemCount; i++)
    {
        UILabel *label = [self.labels objectAtIndex:i];
        UIView *line = [self.lines objectAtIndex:i];
        
        if (i < textField.text.length) {
            label.text = @"•";
            line.backgroundColor = APMColorRGB(60, 125, 235, 1.00);
        } else {
            label.text = nil;
            line.backgroundColor = APMColorRGB(204, 206, 208, 1.00);
        }
    }
    self.tempStr = textField.text;
    [self cursor];
    if (textField.text.length >= self.itemCount) {
        
        [self.currentLabel stopAnimating];
        [textField resignFirstResponder];
        // 回调值出去
        if (self.codeBlock) {
            self.codeBlock(self.tempStr);
        }
    }
}

- (void)animation:(UILabel *)label
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.15;
    animation.repeatCount = 1;
    animation.fromValue = @(0.1);
    animation.toValue = @(1);
    [label.layer addAnimation:animation forKey:@"zoom"];
}

- (void)clickMaskView
{
    [self.textField becomeFirstResponder];
    // 设置光标
    [self cursor];
}

- (BOOL)endEditing:(BOOL)force
{
    [self.textField endEditing:force];
    [self.currentLabel stopAnimating];
    return [super endEditing:force];
}

- (void)cursor {
    
    [self.currentLabel stopAnimating];
    NSInteger index = self.code.length;
    if (index < 0) index = 0;
    if (index >= self.labels.count) index = self.labels.count - 1;
        
    CJ_CursorLabel *label = [self.labels objectAtIndex:index];
       
    [label startAnimating];
    self.currentLabel = label;
}


- (NSString *)code
{
    return self.textField.text;
}

@end



@implementation CJ_lineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView
{
    UIView *colorView = [UIView new];
    [self addSubview:colorView];
    self.colorView = colorView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.colorView.frame = self.bounds;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    self.colorView.backgroundColor = backgroundColor;
}

- (void)animation
{
    [self.colorView.layer removeAllAnimations];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.duration = 0.18;
    animation.repeatCount = 1;
    animation.fromValue = @(1.0);
    animation.toValue = @(0.1);
    animation.autoreverses = YES;

    [self.colorView.layer addAnimation:animation forKey:@"zoom.scale.x"];
}

@end

@implementation CJ_CursorLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView
{
    UIView *cursorView = [[UIView alloc] init];
    cursorView.backgroundColor = [UIColor blueColor];
    cursorView.alpha = 0;
    [self addSubview:cursorView];
    _cursorView = cursorView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = 30;
    CGFloat w = 2;
    CGFloat x = self.bounds.size.width * 0.5;
    CGFloat y = self.bounds.size.height * 0.5;
    self.cursorView.frame = CGRectMake(0, 0, w, h);
    self.cursorView.center = CGPointMake(x, y);
}

- (void)startAnimating
{
    if (self.text.length > 0) return;
    
    CABasicAnimation *oa = [CABasicAnimation animationWithKeyPath:@"opacity"];
    oa.fromValue = [NSNumber numberWithFloat:0];
    oa.toValue = [NSNumber numberWithFloat:1];
    oa.duration = 1;
    oa.repeatCount = MAXFLOAT;
    oa.removedOnCompletion = NO;
    oa.fillMode = kCAFillModeForwards;
    oa.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.cursorView.layer addAnimation:oa forKey:@"opacity"];
}

- (void)stopAnimating
{
    [self.cursorView.layer removeAnimationForKey:@"opacity"];
}

@end
