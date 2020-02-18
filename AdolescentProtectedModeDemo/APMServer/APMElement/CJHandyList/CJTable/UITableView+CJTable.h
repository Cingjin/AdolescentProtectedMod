//
//  UITableView+CJTable.h
//  CJListView
//
//  Created by Anmo on 2019/12/13.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableIMP.h"
#import "CJCommonInfo.h"
#import "CJTableCellConfig.h"
#import "CJTableHeaderFooterConfig.h"
#import "CJTableSection.h"

NS_ASSUME_NONNULL_BEGIN

/// cj_tableIMP 属性是核心代理实现类，其它属性都是便捷配置 cj_tableIMP的语法糖

@interface UITableView (CJTable)

/** 一个 section，cell 配置数组*/
@property (nonatomic ,strong ,readonly) NSMutableArray <id<CJTableCellConfig>> * cj_rowArray;

/** 一个 section,header   配置*/
@property (nonatomic ,strong ,nullable) id<CJTableHeaderFooterConfig> cj_header;

/** 一个 section,footer   配置*/
@property (nonatomic ,strong ,nullable) id<CJTableHeaderFooterConfig> cj_footer;

/** 多个 section 配置数组*/
@property (nonatomic ,strong ,readonly) NSMutableArray <CJTableSection *> * cj_sectionArray;

/** 公共信息对象，将会下发到 cell/header/footer*/
@property (nonatomic ,strong)  CJCommonInfo * cj_commonInfo;

/** */
@property (nonatomic ,strong) __kindof CJTableIMP * cj_tableIMP;

@end

NS_ASSUME_NONNULL_END
