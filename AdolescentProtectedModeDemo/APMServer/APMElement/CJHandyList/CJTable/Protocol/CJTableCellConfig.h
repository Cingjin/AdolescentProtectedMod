//
//  CJTableCellConfig.h
//  CJListView
//
//  Created by Anmo on 2019/12/12.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJTableCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// UITableView Cell 配置协议
@protocol CJTableCellConfig <NSObject>

@required

/// Cell 的类类型
- (Class<CJTableCellProtocol>)cj_cellClass;

@optional

/// Cell 对应的数据模型
- (id)cj_cellModel;

/// Cell 的默认高度(优先级低于 CJTableCellProtocol代理方法返回的高度)
- (CGFloat)cj_defaultHeight;

/// Cell复用标识
- (NSString *)cj_cellRuseIdentifier;

@end

/// 配置默认实现类，用于快速构建，若想拓展属性请自行创建类实现 CJTableCellConfig协议

@interface CJTableCellConfig : NSObject <CJTableCellConfig>

/** cell 的类类型*/
@property (nonatomic ,strong) Class<CJTableCellProtocol> cellClass;

/** cell 对应的数据模型*/
@property (nonatomic ,strong) id model;

/** cell 的默认高度（优先级低于CJTableCellProtocol代理方法返回的高度）*/
@property (nonatomic ,assign) CGFloat  defaultHeight;

/** cell 的复用标识*/
@property (nonatomic ,copy , nullable) NSString *cellReuseIndentifier;

@end

NS_ASSUME_NONNULL_END
