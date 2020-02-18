//
//  CJAlertView.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/14.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJAlertView.h"

@interface CJAlertView ()

@property(nonatomic,strong)UILabel  * showLabel;
/*定时器*/
@property(nonatomic,strong)NSTimer  * timer;

@property(nonatomic,assign)NSInteger time;


@end

@implementation CJAlertView

static CJAlertView *_showView = nil;

+ (CJAlertView *)shareShowView{
    if (!_showView) {
        _showView = [[CJAlertView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _showView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //界面相关
        [self createUI];
    }
    return self;
}

#pragma mark -界面相关

-(void)createUI{
    
    self.showLabel.frame = CGRectMake(self.center.x,self.center.y, 0, 70);
    [self addSubview:self.showLabel];
}

+ (void)showMessage:(NSString *)message completion:(void (^)(void))completion {
    [self shareShowView];
     CGSize size = [self apm_sizeWithText:message font:[UIFont systemFontOfSize:16] maxW:[UIScreen mainScreen].bounds.size.width - 30];
     if (![message isEqualToString:@""]) {
         [self shareShowView].showLabel.text = message;
         CGRect frame = [self shareShowView].showLabel.frame;
         frame.size.width = size.width + 2 + 72;
         frame.origin.x = ([UIScreen mainScreen].bounds.size.width - frame.size.width)/ 2;
         [self shareShowView].showLabel.frame = frame;
     }
    [[UIApplication sharedApplication].keyWindow addSubview:[self shareShowView]];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [UIView animateWithDuration:0.5 animations:^{
             _showView.alpha = 0;
         } completion:^(BOOL finished) {
             [_showView removeFromSuperview];
             _showView.transform = CGAffineTransformIdentity;
             _showView.alpha = 1;
             if (completion) {
                 completion();
             }
         }];
     });
}

#pragma mark - Private

//根据文字和字体的大小计算文字的容器的大小
+ (CGSize)apm_sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    //约束宽度
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - Lazy

-(UILabel *)showLabel{
    
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _showLabel.font = [UIFont systemFontOfSize:16];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.layer.masksToBounds = YES;
        _showLabel.textColor = [UIColor whiteColor];
        _showLabel.layer.cornerRadius = 5;
        _showLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _showLabel;
}


@end
