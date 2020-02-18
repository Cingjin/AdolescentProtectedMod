//
//  CJCommonInfo.m
//  CJListView
//
//  Created by Anmo on 2019/12/12.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCommonInfo.h"

@implementation CJCommonInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        CGSize size = UIScreen.mainScreen.bounds.size;
        _maxWidth = size.width;
        _maxHeight = size.height;
    }
    return self;
}

@end
