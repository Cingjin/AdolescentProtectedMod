//
//  APMContentTableViewCell.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMContentTableViewCell.h"
#import "APMContentModel.h"
#import "CJListHeader.h"
#import "APMHeader.h"

@interface APMContentTableViewCell ()<CJTableCellProtocol>

/** contentLabel*/
@property (nonatomic ,strong) UILabel       * contentLabel;

/** contentIcon*/
@property (nonatomic ,strong) UIImageView   * contentIcon;

@end

@implementation APMContentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self apm_addSubView];
    }
    return self;
}

#pragma mark - View

- (void)apm_addSubView {
    
    [self.contentView addSubview:self.contentIcon];
    
    [self.contentView addSubview:self.contentLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat iconX = 15;
    CGFloat iconY = 8;
    CGFloat iconW = 6;
    self.contentIcon.frame = CGRectMake(iconX, iconY, iconW, iconW);
    
    CGFloat labelX = CGRectGetMaxX(self.contentIcon.frame) + 10;
    CGFloat labelW = self.bounds.size.width - (labelX * 2);
    CGFloat labelH = self.bounds.size.height;
    self.contentLabel.frame = CGRectMake(labelX, 0, labelW, labelH);
    [self.contentLabel sizeToFit];
}

#pragma mark - <CJTableCellProtocol>

- (void)cj_setCellConfig:(id<CJTableCellConfig>)config {
    
    APMContentModel * cellModel = config.cj_cellModel;
    [self apm_labelText:cellModel.content];
}

- (void)apm_labelText:(NSString *)text {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    self.contentLabel.attributedText = attributedStr;
}

#pragma mark - Lazy

- (UIImageView *)contentIcon {
    if (!_contentIcon) {
        _contentIcon = [[UIImageView alloc]init];
        _contentIcon.image = [UIImage imageNamed:@"icon_Oval1"];
    }
    return _contentIcon;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = APMColorRGB(61, 73, 85, 1.0);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
