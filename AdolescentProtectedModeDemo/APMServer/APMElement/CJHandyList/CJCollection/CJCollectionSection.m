//
//  CJCollectionSection.m
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionSection.h"

@interface  CJCollectionSection ()

/** rowArray*/
@property (nonatomic ,strong) NSMutableArray <id<CJCollectionCellConfig>> * rowArray;

@end

@implementation CJCollectionSection

- (NSMutableArray<id<CJCollectionCellConfig>> *)rowArray {
    if (!_rowArray) {
        _rowArray = [NSMutableArray array];
    }
    return _rowArray;
}


@end
