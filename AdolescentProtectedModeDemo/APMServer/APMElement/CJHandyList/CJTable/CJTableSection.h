//
//  CJTableSection.h
//  CJListView
//
//  Created by Anmo on 2019/12/12.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableCellConfig.h"
#import "CJTableHeaderFooterConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJTableSection : NSObject

/** UITableView header  配置数组*/
@property (nonatomic ,strong ,nullable) id<CJTableHeaderFooterConfig> header;

/** UITableView footer  配置数组*/
@property (nonatomic ,strong ,nullable) id<CJTableHeaderFooterConfig> footer;

/** UITableView cell    配置数组*/
@property (nonatomic ,strong ,readonly)NSMutableArray   <id<CJTableCellConfig>> *rowArray;

@end

NS_ASSUME_NONNULL_END
