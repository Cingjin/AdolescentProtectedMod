//
//  UICollectionView+CJCollection.h
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionIMP.h"
#import "CJCommonInfo.h"
#import "CJCollectionCellConfig.h"
#import "CJCollectionHeaderFooterConfig.h"
#import "CJCollectionSection.h"
#import "CJCollectionIMP.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (CJCollection)

/** 一个 section，cell 配置数组*/
@property (nonatomic ,strong ,readonly) NSMutableArray <id<CJCollectionCellConfig>> *cj_rowArray;

/** 一个 section，header 配置*/
@property (nonatomic ,strong ,nullable) id<CJCollectionHeaderFooterConfig> cj_header;

/** 一个 section，footer 配置*/
@property (nonatomic ,strong ,nullable) id<CJCollectionHeaderFooterConfig> cj_footer;

/** 一个  section，cell 间距 */
@property (nonatomic, assign) CGFloat cj_minimumLineSpacing;

/** 一个  section，cell 间距 */
@property (nonatomic, assign) CGFloat cj_minimumInteritemSpacing;

/** 一个  section，外边距 */
@property (nonatomic, assign) UIEdgeInsets cj_inset;

/** 多个  section*/
@property (nonatomic ,strong ,readonly) NSMutableArray<CJCollectionSection *>*cj_sectionArray;

/** 公共信息对象，将会下发到 Cell/Header/Footer*/
@property (nonatomic ,strong) CJCommonInfo * cj_commonInfo;

/** 代理实现者，将数组内容转换为列表代理方法的核心类，（需要实现额外的 UICollectionView 代理方法，可以自定义继承CJCollectionIMP的类并赋值该属性）*/
@property (nonatomic ,strong) __kindof CJCollectionIMP * cj_collectionIMP;

@end

NS_ASSUME_NONNULL_END
