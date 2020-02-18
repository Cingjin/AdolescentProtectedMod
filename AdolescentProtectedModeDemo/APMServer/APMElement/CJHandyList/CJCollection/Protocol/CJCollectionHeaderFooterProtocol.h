//
//  CJCollectionHeaderFooterProtocol.h
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJCommonInfo.h"

@protocol CJCollectionHeaderFooterConfig;
@class CJCollectionSection;

NS_ASSUME_NONNULL_BEGIN

@protocol CJCollectionHeaderFooterProtocol <NSObject>

@optional

/**
 传递数据给  header/footer   (根据配置对象拿到数据更新UI)
 
 @param config  配置对象
 @param indexPath indexPath
 @param commonInfo  公共信息
 */

- (void)cj_setHeaderFooterConfig:(id<CJCollectionHeaderFooterConfig>)config indexPath:(NSIndexPath *)indexPath commonInfo:(CJCommonInfo *)commonInfo;
- (void)cj_setHeaderFooterConfig:(id<CJCollectionHeaderFooterConfig>)config;

/**
 获取 header/footer   的高度
 
 @param config  配置对象
 @param reuseIndentifier    复用标识
 @param section section
 @param commonInfo  公共信息
 @return    高度
 */

+ (CGSize)cj_sizeForHeaderFooterWithConfig:(id<CJCollectionHeaderFooterConfig>)config reuseIndentifier:(NSString *)reuseIndentifier section:(NSInteger)section sectionPack:(CJCollectionSection *)sectionPack commonInfo:(CJCommonInfo *)commonInfo;
+ (CGSize)cj_sizeForHeaderFooterWithConfig:(id<CJCollectionHeaderFooterConfig>)config reuseIndentifier:(NSString *)reuseIndentifier section:(NSInteger)section sectionPack:(CJCollectionSection *)sectionPack;

/** 刷新UITableView */
@property (nonatomic ,copy) void(^cj_reloadCollectionView)(void);


@end

NS_ASSUME_NONNULL_END
