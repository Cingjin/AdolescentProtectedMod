//
//  CJCollectionCellConfig.h
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CJCollectionCellConfig <NSObject>

@required

/// UICollectionView    cell    配置协议
- (Class<CJCollectionCellProtocol>)cj_cellClass;

@optional

/// Cell    对应的数据模型
- (id)cj_cellModel;

/// Cell    的默认高度（优先级低于 CJCollectionCellProtocol代理方法返回的高度）
- (CGSize)cj_defaultSize;

/// Cell    复用标识
- (NSString *)cj_cellRuseIdentifier;

@end

/// 配置默认实现类，用于快速构建，若想拓展属性请自行创建类实现 CJCollectionCellConfig协议
@interface CJCollectionCellConfig : NSObject

/** cell 的类类型*/
@property (nonatomic ,strong) Class<CJCollectionCellProtocol> cellClass;

/** cell 对应的数据模型*/
@property (nonatomic ,strong) id    model;

/** cell 的默认高度（优先级低于 CJCollectionCellProtocol代理方法放回的高度）*/
@property (nonatomic ,assign) CGSize  defaultSize;

/** cell 的复用标识*/
@property (nonatomic ,copy ,nullable) NSString * cellReuseIdentifier;

@end

NS_ASSUME_NONNULL_END



