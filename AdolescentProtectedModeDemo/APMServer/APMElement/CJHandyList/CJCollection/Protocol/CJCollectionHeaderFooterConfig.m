//
//  CJCollectionHeaderFooterConfig.m
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionHeaderFooterConfig.h"

@implementation CJCollectionHeaderFooterConfig

#pragma mark - <CJCollectionHeaderFooterConfig>

- (Class<CJCollectionHeaderFooterProtocol>)cj_headerFooterClass {
    return self.headerFooterClass;
}

- (id)cj_cellModel {
    return self.model;
}

- (CGSize)cj_defaultSize {
    return self.defaultSize;
}

- (NSString *)cj_headerFooterReuseIdentifier {
    return self.headerFooterReuseIdentifier;
}

@end
