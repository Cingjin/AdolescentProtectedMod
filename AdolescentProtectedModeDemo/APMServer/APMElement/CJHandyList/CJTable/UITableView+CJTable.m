//
//  UITableView+CJTable.m
//  CJListView
//
//  Created by Anmo on 2019/12/13.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "UITableView+CJTable.h"
#import <objc/runtime.h>

@implementation UITableView (CJTable)

#pragma mark - syntactic sugar

- (NSMutableArray<id<CJTableCellConfig>> *)cj_rowArray {
    
    return self.cj_firstSection.rowArray;
}

- (void)setCj_header:(id<CJTableHeaderFooterConfig>)cj_header {
    self.cj_firstSection.header = cj_header;
}

- (id<CJTableHeaderFooterConfig>)cj_header {
    return self.cj_firstSection.header;
}

- (void)setCj_footer:(id<CJTableHeaderFooterConfig>)cj_footer {
    self.cj_firstSection.footer = cj_footer;
}

- (id<CJTableHeaderFooterConfig>)cj_footer {
    return self.cj_firstSection.footer;
}

- (CJTableSection *)cj_firstSection {
    if (self.cj_sectionArray.count > 0) {
        return self.cj_sectionArray[0];
    }
    CJTableSection * section = [CJTableSection new];
    [self.cj_sectionArray addObject:section];
    return section;
}

- (void)setCj_commonInfo:(CJCommonInfo *)cj_commonInfo {
    self.cj_tableIMP.commonInfo = cj_commonInfo;
}

- (CJCommonInfo *)cj_commonInfo {
    return self.cj_tableIMP.commonInfo;
}

#pragma mark - getters & setters

static const void * CJSectionArrayKey = &CJSectionArrayKey;
- (void)setCj_sectionArray:(NSMutableArray<CJTableSection *> * _Nonnull)cj_sectionArray {
    /*
     基本说明：objc_setAssociatedObject 关联对象就是runTime界的NSMultableDictionary
     objc_setAssociatedObject   相当于 setValue:forKey 进行关联value对象
     objc_getAssociatedObject   用来读取对象
     objc_AssociationPolicy     属性 是设定该value在object内的属性，即 assgin, (retain,nonatomic)...等
     objc_removeAssociatedObjects 函数来移除一个关联对象，或者使用objc_setAssociatedObject函数将key指定的关联对象设置为nil。
     参考资料：https://www.cnblogs.com/someonelikeyou/p/7162613.html
     */
    objc_setAssociatedObject(self, CJSectionArrayKey, cj_sectionArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<CJTableSection *> *)cj_sectionArray {
    NSMutableArray * array = objc_getAssociatedObject(self, CJSectionArrayKey);
    if (!array) {
        array = [NSMutableArray array];
        self.cj_sectionArray = array;
        [self cj_tableIMP]; // Just call.
    }
    return array;
}

static const void * CJTableIMPKey = &CJTableIMPKey;

- (void)setCj_tableIMP:(CJTableIMP *)cj_tableIMP {
    cj_tableIMP.sectionArray = self.cj_sectionArray;
    self.delegate = cj_tableIMP;
    self.dataSource = cj_tableIMP;
    objc_setAssociatedObject(self, CJTableIMPKey, cj_tableIMP, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CJTableIMP *)cj_tableIMP {
    CJTableIMP * imp = objc_getAssociatedObject(self, CJTableIMPKey);
    if (!imp) {
        imp = [CJTableIMP new];
        self.cj_tableIMP = imp;
    }
    return imp;
}

@end
