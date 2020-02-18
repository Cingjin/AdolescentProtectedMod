//
//  CJCollectionCellProtocol.h
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJCommonInfo.h"

@protocol CJCollectionCellConfig;
@class CJCollectionSection;

NS_ASSUME_NONNULL_BEGIN

@protocol CJCollectionCellProtocol <NSObject>

@optional



/**
 传递数据给 cell（根据配置对象拿到数据更新UI）

 @param  config      配置对象
 @param  indexPath   indexPath
 @param  commonInfo  公共信息
 */
- (void)cj_setCellConfig:(id<CJCollectionCellConfig>)config indexPath:(NSIndexPath *)indexPath commonInfo:(CJCommonInfo *)commonInfo;
- (void)cj_setCellConfig:(id<CJCollectionCellConfig>)config;

/**
 获取 cell 高度

 @param config  配置对象
 @param reuseIndentifier    复用标识
 @param indexPath   indexPath
 @param sectionPack cell 所属 section 的配置
 @param commonInfo  公共信息
 @return    高度
 */
+ (CGSize)cj_sizeForCellWithConfig:(id<CJCollectionCellConfig>)config reuseIndentifier:(NSString *)reuseIndentifier indexPath:(NSIndexPath *)indexPath sectionPack:(CJCollectionSection *)sectionPack commonInfo:(CJCommonInfo *)commonInfo;
+ (CGSize)cj_sizeForCellWithConfig:(id<CJCollectionCellConfig>)config reuseIndentifier:(NSString *)reuseIndentifier indexPath:(NSIndexPath *)indexPath sectionPack:(CJCollectionSection *)sectionPack;
/**
 当前 cell 被选中

 @param indexPath   indexPath
 **/
- (void)cj_didSelectedAtIndexPath:(NSIndexPath *)indexPath;

/** 刷新UITableView */
@property (nonatomic ,copy) void(^cj_reloadCollectionView)(void);

@end

NS_ASSUME_NONNULL_END
