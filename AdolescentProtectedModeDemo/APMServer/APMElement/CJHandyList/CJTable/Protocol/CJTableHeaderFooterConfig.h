//
//  CJTableHeaderFooterConfig.h
//  CJListView
//
//  Created by Anmo on 2019/12/13.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableHeaderFooterProtocol.h"


NS_ASSUME_NONNULL_BEGIN

/// TableView header/footer 配置协议
@protocol CJTableHeaderFooterConfig <NSObject>

@required

/// header/footer 类类型
- (Class<CJTableHeaderFooterProtocol>)cj_headerFooterClass;

@optional

/// header/footer  对应的数据模型
- (id)cj_headerFooterModel;

/// header/footer   的默认高度（优先级低于CJTableHeaderFooterProtocol 代理方法返回的高度）
- (CGFloat)cj_defaultHeight;

/// header/footer   复用标识
- (NSString *)cj_headerFooterReuseIndentifier;


@end

@interface CJTableHeaderFooterConfig : NSObject<CJTableHeaderFooterConfig>

/** header/footer 类类型*/
@property (nonatomic ,strong) Class<CJTableHeaderFooterProtocol>headerFooterClass;

/** header/footer 对应的数据模型*/
@property (nonatomic ,strong) id    model;

/** header/footer 默认高度（优先级低于CJTableHeaderFooterProtocol 代理方法返回的高度）*/
@property (nonatomic ,assign) CGFloat  defaultHeight;

/** header/footer 复用标识*/
@property (nonatomic ,copy) NSString    * headerFooterReuseIdentifier;

@end

NS_ASSUME_NONNULL_END
