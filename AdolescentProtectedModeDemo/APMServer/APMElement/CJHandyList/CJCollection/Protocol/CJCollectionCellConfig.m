//
//  CJCollectionCellConfig.m
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionCellConfig.h"

@implementation CJCollectionCellConfig

#pragma mark - <CJCollectionCellConfig>

- (Class<CJCollectionCellProtocol>)cj_cellClass {
    return self.cellClass;
}

- (id)cj_cellModel {
    return self.model;
}

- (CGSize)cj_defaultSize {
    return self.defaultSize;
}

- (NSString *)cj_cellRuseIdentifier {
    return  self.cellReuseIdentifier;
}

@end
