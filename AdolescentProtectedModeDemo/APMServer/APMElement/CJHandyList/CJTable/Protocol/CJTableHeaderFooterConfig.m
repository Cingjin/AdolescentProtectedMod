//
//  CJTableHeaderFooterConfig.m
//  CJListView
//
//  Created by Anmo on 2019/12/13.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableHeaderFooterConfig.h"

@implementation CJTableHeaderFooterConfig

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultHeight = -1;
    }
    return self;
}

#pragma mark - <CJTableHeaderFooterConfig>

- (Class<CJTableHeaderFooterProtocol>)cj_headerFooterClass {
    return self.headerFooterClass;
}

- (id)cj_headerFooterModel {
    return self.model;
}

- (CGFloat)cj_defaultHeight {
    return self.defaultHeight;
}

- (NSString *)cj_headerFooterReuseIndentifier {
    return self.headerFooterReuseIdentifier;
}

@end
