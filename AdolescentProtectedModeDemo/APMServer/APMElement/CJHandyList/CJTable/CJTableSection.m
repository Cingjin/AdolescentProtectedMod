//
//  CJTableSection.m
//  CJListView
//
//  Created by Anmo on 2019/12/12.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableSection.h"

@interface CJTableSection ()

/** */
@property (nonatomic ,strong) NSMutableArray <id<CJTableCellConfig>> *rowArray;

@end

@implementation CJTableSection

- (NSMutableArray<id<CJTableCellConfig>> *)rowArray {
    if (!_rowArray) {
        _rowArray = [NSMutableArray array];
    }
    return _rowArray;
}

@end
