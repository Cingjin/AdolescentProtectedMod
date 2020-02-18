//
//  APMSetView.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#define selfW self.frame.size.width
#define selfH self.frame.size.height

#import "APMSetView.h"
#import "CJListHeader.h"
#import "APMContentModel.h"
#import "APMContentTableViewCell.h"
#import "APMManager.h"
#import "APMHeader.h"

@interface APMSetView ()

/** icon*/
@property (nonatomic ,strong) UIImageView   * imgView;

/** apmStatusLabel*/
@property (nonatomic ,strong) UILabel       * statusLabel;

/** contentTable*/
@property (nonatomic ,strong) UITableView   * contentTable;

/** setPwdBtn*/
@property (nonatomic ,strong) UIButton      * setPwdBtn;

/** resetPwdBtn*/
@property (nonatomic ,strong) UIButton      * resetPwdBtn;

/** content*/
@property (nonatomic ,copy) NSString        * content;

@end

@implementation APMSetView

- (instancetype)initWithFrame:(CGRect)frame Content:(NSString *)content {
    self = [super initWithFrame:frame];
    if (self) {

        [self apm_addSubView];
        [self apm_getData:content];
        [self apm_reloadView];
        
    }
    return self;
}

- (void)apm_addSubView {

    [self addSubview:self.imgView];
    
    [self addSubview:self.statusLabel];
    
    [self addSubview:self.contentTable];
    
    [self addSubview:self.setPwdBtn];
    
    [self addSubview:self.resetPwdBtn];
}

- (void)apm_reloadView {
    
    self.resetPwdBtn.hidden = ![[APMManager apm_manager] apm_status];
    if ([[APMManager apm_manager] apm_status]) {
        self.imgView.image = [UIImage imageNamed:@"icon_on"];
        self.statusLabel.text = @"青少年模式已开启";
        [self.setPwdBtn setTitle:@"关闭青少年模式" forState:UIControlStateNormal];
        [self.resetPwdBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    }else {
        self.imgView.image = [UIImage imageNamed:@"icon_off"];
        self.statusLabel.text = @"青少年模式已关闭";
        [self.setPwdBtn setTitle:@"开启青少年模式" forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
}

#pragma mark - 处理数据拆分内容数组

- (void)apm_getData:(NSString *)content {
    
    if (!content) {return;}
    NSArray * contentArr = [content componentsSeparatedByString:@"\n"];
    // ① 模拟构建数据模型,使用默认实现的配置对象（能满足大部分需求）
    NSMutableArray *configArray = [NSMutableArray array];
    for (int i = 0; i < contentArr.count; ++i) {
        APMContentModel *model = [APMContentModel new];
        model.content = contentArr[i];
        model.hiddenOval = NO;
        model.cellHeight = [self apm_content:model.content]+20; // 加20的高度
        
        // 配置CellModel
        CJTableCellConfig * cellConfig = [CJTableCellConfig new];
        cellConfig.model = model;
        cellConfig.cellClass = APMContentTableViewCell.self;
        cellConfig.defaultHeight = model.cellHeight;
        [configArray addObject:cellConfig];
    }
    [self.contentTable.cj_rowArray addObjectsFromArray:configArray];
    [self.contentTable reloadData];
}

#pragma mark -计算文本高度

//计算UILabel的高度(带有行间距的情况)
- (CGFloat)apm_content:(NSString * )content {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 5;
    
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    CGFloat contentHeight = selfW - 62;
    CGRect rect = [content boundingRectWithSize:CGSizeMake(contentHeight, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil];
    return rect.size.height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imgY = 30;
    CGFloat imgHeight   = 58;
    CGFloat imgWidth    = 50;
    CGFloat imgX = (selfW - imgWidth)/2;
    self.imgView.frame = CGRectMake(imgX, imgY, imgWidth, imgHeight);
    
    CGFloat labelY = CGRectGetMaxY(self.imgView.frame) + 29;
    self.statusLabel.frame = CGRectMake(0, labelY, selfW, 28);
    
    CGFloat btnX = 15;
    CGFloat btnH = 50;
    CGFloat btnY = selfH - (btnH + 34) - ([[APMManager apm_manager] apm_status]?APMSafeAreaTopHeight+50:APMSafeAreaTopHeight);
    CGFloat btnW = selfW - (2*btnX);
    self.setPwdBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    if ([[APMManager apm_manager] apm_status]) {
        CGFloat resetBtnY = CGRectGetMaxY(self.setPwdBtn.frame);
        self.resetPwdBtn.frame = CGRectMake(btnX, resetBtnY, btnW, btnH);
    }else {
        self.resetPwdBtn.frame = CGRectZero;
    }
    
    CGFloat tableY = CGRectGetMaxY(self.statusLabel.frame) + 60;
    CGFloat tableH = CGRectGetMinY(self.setPwdBtn.frame) - tableY - 20;
    self.contentTable.frame = CGRectMake(0, tableY, selfW, tableH);
}

#pragma mark - Click

- (void)apm_buttonClick:(UIButton *)sender {
    
    BOOL apmStatus = [[APMManager apm_manager] apm_status];
    APMPwdType type;
    if (sender.tag == 0) {  // 设置密码或者验证密码
        type = apmStatus?APMPwdVerify:APMPwdSet;
    }else {
        type = APMPwdReset;
    }
    if (self.APMOnBlock) {  // 重设密码
        self.APMOnBlock(type);
    }
}


#pragma mark - Lazy

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont boldSystemFontOfSize:20];
        _statusLabel.textColor = APMColorRGB(61, 73, 85, 1.00);
    }
    return _statusLabel;
}

- (UITableView *)contentTable {
    if (!_contentTable) {
        _contentTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTable.backgroundColor = [UIColor whiteColor];
        _contentTable.estimatedSectionFooterHeight = 0;
        _contentTable.estimatedSectionHeaderHeight = 0;
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTable;
}

- (UIButton *)setPwdBtn {
    if (!_setPwdBtn) {
        _setPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];//rgba(60,125,235,1.00)
        _setPwdBtn.backgroundColor = APMColorRGB(60,125,235,1.00);
        _setPwdBtn.layer.masksToBounds = YES;
        _setPwdBtn.layer.cornerRadius = 5;
        _setPwdBtn.tag = 0;
        [_setPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_setPwdBtn addTarget:self action:@selector(apm_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setPwdBtn;
}

- (UIButton *)resetPwdBtn {
    if (!_resetPwdBtn) {
        _resetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetPwdBtn.backgroundColor = [UIColor whiteColor];
        _resetPwdBtn.hidden = YES;
        _resetPwdBtn.tag = 1;
        [_resetPwdBtn setTitleColor:APMColorRGB(139,146,153,1.00) forState:UIControlStateNormal];
        [_resetPwdBtn addTarget:self action:@selector(apm_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetPwdBtn;
}

@end
