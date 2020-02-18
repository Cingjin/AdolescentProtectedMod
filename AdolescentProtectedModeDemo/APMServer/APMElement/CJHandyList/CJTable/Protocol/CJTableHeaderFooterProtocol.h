//
//  CJTableHeaderFooterProtocol.h
//  CJListView
//
//  Created by Anmo on 2019/12/13.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJCommonInfo.h"

@protocol CJTableHeaderFooterConfig;

@class CJTableSection;

NS_ASSUME_NONNULL_BEGIN

@protocol CJTableHeaderFooterProtocol <NSObject>

@optional

/**
 传递数据给  header/footer   (根据配置对象拿到数据更新UI)
 
 @param config  配置对象
 @param section section
 @param commonInfo  公共信息
 */

- (void)cj_setHeaderFooterConfig:(id<CJTableHeaderFooterConfig>)config section:(NSInteger)section commonInfo:(CJCommonInfo *)commonInfo;
- (void)cj_setHeaderFooterConfig:(id<CJTableHeaderFooterConfig>)config;

/**
 获取 header/footer   的高度
 
 @param config  配置对象
 @param reuseIndentifier    复用标识
 @param section section
 @param commonInfo  公共信息
 @return    高度
 */

+ (CGFloat)cj_heightForHeaderFooterWithConfig:(id<CJTableHeaderFooterConfig>)config reuseIndentifier:(NSString *)reuseIndentifier section:(NSInteger)section commonInfo:(CJCommonInfo *)commonInfo;
+ (CGFloat)cj_heightForHeaderFooterWithConfig:(id<CJTableHeaderFooterConfig>)config reuseIndentifier:(NSString *)reuseIndentifier section:(NSInteger)section;

/** 刷新UITableView */
@property (nonatomic ,copy) void(^cj_reloadTableView)(void);


@end

NS_ASSUME_NONNULL_END
