//
//  CJCollectionHeaderFooterConfig.h
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionHeaderFooterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// UICollectionView header/footer  配置协议

@protocol CJCollectionHeaderFooterConfig <NSObject>

@required

/// header/footer 类类型
- (Class<CJCollectionHeaderFooterProtocol>)cj_headerFooterClass;

@optional

/// header/footer 对应的数据模型
- (id)cj_cellModel;

/// header/footer 的大小（优先级低于 CJCollectionHeaderFooterProtocol代理方法返回的高度）
- (CGSize)cj_defaultSize;

/// header/footer 的复用标识
- (NSString *)cj_headerFooterReuseIdentifier;

@end

/// 配置默认实现类，用于快速构建，若想拓展属性请自行创建类实现 CJCollectionHeaderFooterConfig协议
@interface CJCollectionHeaderFooterConfig : NSObject

/** header/footer 类类型*/
@property (nonatomic ,strong) Class<CJCollectionHeaderFooterProtocol> headerFooterClass;

/** header/fooyer 对应的数据模型*/
@property (nonatomic ,strong) id model;

/** header/footer 的大小（优先级低于 CJCollectionHeaderFooterProtocol代理方法返回的高度）*/
@property (nonatomic ,assign) CGSize  defaultSize;

/** header/footer 的复用标识*/
@property (nonatomic ,copy) NSString * headerFooterReuseIdentifier;

@end

NS_ASSUME_NONNULL_END
