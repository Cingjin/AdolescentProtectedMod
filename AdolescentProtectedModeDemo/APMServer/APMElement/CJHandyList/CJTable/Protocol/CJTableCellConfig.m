//
//  CJTableCellConfig.m
//  CJListView
//
//  Created by Anmo on 2019/12/12.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableCellConfig.h"

@implementation CJTableCellConfig

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultHeight = -1;
    }
    return self;
}


#pragma mark - <CJTableCellConfig>

- (Class<CJTableCellProtocol>)cj_cellClass {
    return self.cellClass;
}

- (id)cj_cellModel {
    return self.model;
}

- (CGFloat)cj_defaultHeight {
    return self.defaultHeight;
}

- (NSString *)cj_cellRuseIdentifier {
    return self.cellReuseIndentifier;
}

@end
