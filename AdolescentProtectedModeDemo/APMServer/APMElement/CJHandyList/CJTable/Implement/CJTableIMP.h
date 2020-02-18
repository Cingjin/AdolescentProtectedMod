//
//  CJTableIMP.h
//  CJListView
//
//  Created by Anmo on 2019/12/12.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableSection.h"
#import "CJCommonInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 代理实现类，可以直接抽出来作为 UITableView 的 delegate 和 dataSource 若想实现更多的代理方法继承该类在子类中拓展就行
 */
@interface CJTableIMP : NSObject <UITableViewDelegate,UITableViewDataSource>

/** 数据源*/
@property (nonatomic ,strong) NSMutableArray <CJTableSection *>* sectionArray;

/** 公共信息对象，将会下发到 cell/header/footer */
@property (nonatomic ,strong) CJCommonInfo  * commonInfo;


@end

NS_ASSUME_NONNULL_END
