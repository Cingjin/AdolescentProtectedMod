//
//  CJCollectionSection.h
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionCellConfig.h"
#import "CJCollectionHeaderFooterConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJCollectionSection : NSObject

/** UICollectionView 的 header 配置*/
@property (nonatomic ,strong ,nullable) id<CJCollectionHeaderFooterConfig>  header;

/** UICollectionView 的 footer 配置*/
@property (nonatomic ,strong ,nullable) id<CJCollectionHeaderFooterConfig>  footer;

/** UICollectionView 的 cell   配置数据*/
@property (nonatomic ,strong ,readonly) NSMutableArray<id<CJCollectionCellConfig>> *rowArray;

/** cell 间距*/
@property (nonatomic ,assign)   CGFloat minimumLineSpacing;

/** cell 间距*/
@property (nonatomic ,assign)   CGFloat minimumInteritemSpacing;

/** section 外边距*/
@property (nonatomic ,assign)    UIEdgeInsets inset;


@end

NS_ASSUME_NONNULL_END
