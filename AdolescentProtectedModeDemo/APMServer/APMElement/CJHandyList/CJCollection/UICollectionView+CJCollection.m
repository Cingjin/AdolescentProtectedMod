//
//  UICollectionView+CJCollection.m
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "UICollectionView+CJCollection.h"
#import <objc/runtime.h>


@implementation UICollectionView (CJCollection)

#pragma mark - syntactic sugar

- (NSMutableArray<id<CJCollectionCellConfig>> *)cj_rowArray {
    return self.cj_firstSection.rowArray;
}

- (void)setCj_header:(id<CJCollectionHeaderFooterConfig>)cj_header {
    self.cj_firstSection.header = cj_header;
}

- (id<CJCollectionHeaderFooterConfig>)cj_header {
    return self.cj_firstSection.header;
}

- (void)setCj_footer:(id<CJCollectionHeaderFooterConfig>)cj_footer {
    self.cj_firstSection.footer = cj_footer;
}

- (id<CJCollectionHeaderFooterConfig>)cj_footer {
    return self.cj_firstSection.footer;
}

- (void)setCj_minimumLineSpacing:(CGFloat)cj_minimumLineSpacing {
    self.cj_firstSection.minimumLineSpacing = cj_minimumLineSpacing;
}

- (CGFloat)cj_minimumLineSpacing {
    return self.cj_firstSection.minimumLineSpacing;
}

- (void)setCj_minimumInteritemSpacing:(CGFloat)cj_minimumInteritemSpacing {
    self.cj_firstSection.minimumInteritemSpacing = cj_minimumInteritemSpacing;
}

- (CGFloat)cj_minimumInteritemSpacing {
    return self.cj_firstSection.minimumInteritemSpacing;
}

- (void)setCj_inset:(UIEdgeInsets)cj_inset {
    self.cj_firstSection.inset = cj_inset;
}

- (UIEdgeInsets)cj_inset {
    return self.cj_firstSection.inset;
}

- (CJCollectionSection *)cj_firstSection {
    if (self.cj_sectionArray.count > 0) {
        return self.cj_sectionArray[0];
    }
    CJCollectionSection * section = [CJCollectionSection new];
    [self.cj_sectionArray addObject:section];
    return section;
}

- (void)setCj_commonInfo:(CJCommonInfo *)cj_commonInfo {
    self.cj_collectionIMP.commonInfo = cj_commonInfo;
}

- (CJCommonInfo *)cj_commonInfo {
    return self.cj_collectionIMP.commonInfo;
}

#pragma mark - getters & setters

static const void * CJSectionArrayKey = &CJSectionArrayKey;

- (void)setCj_sectionArray:(NSMutableArray<CJCollectionSection *> * _Nonnull)cj_sectionArray {
    objc_setAssociatedObject(self, CJSectionArrayKey, cj_sectionArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-  (NSMutableArray<CJCollectionSection *> *)cj_sectionArray {
    NSMutableArray * array = objc_getAssociatedObject(self, CJSectionArrayKey);
    if (!array) {
        array = [NSMutableArray array];
        self.cj_sectionArray = array;
        [self cj_collectionIMP];    //Just call.
    }
    return array;
}

static const void * CJCollectionIMPKey = &CJCollectionIMPKey;

- (void)setCj_collectionIMP:(__kindof CJCollectionIMP *)cj_collectionIMP {
    cj_collectionIMP.sectionArray = self.cj_sectionArray;
    self.delegate = cj_collectionIMP;
    self.dataSource = cj_collectionIMP;
    objc_setAssociatedObject(self, CJCollectionIMPKey, cj_collectionIMP, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CJCollectionIMP *)cj_collectionIMP {
    CJCollectionIMP * imp = objc_getAssociatedObject(self, CJCollectionIMPKey);
    if (!imp) {
        imp = [CJCollectionIMP new];
        self.cj_collectionIMP = imp;
    }
    return imp;
}

@end
