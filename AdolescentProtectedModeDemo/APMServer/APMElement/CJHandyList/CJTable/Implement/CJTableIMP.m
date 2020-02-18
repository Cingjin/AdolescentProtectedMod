//
//  CJTableIMP.m
//  CJListView
//
//  Created by Anmo on 2019/12/12.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJTableIMP.h"

@implementation CJTableIMP

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJTableSection * cjSection = self.sectionArray[indexPath.section];
    id<CJTableCellConfig> config = cjSection.rowArray[indexPath.row];
    if ([config.cj_cellClass respondsToSelector:@selector(cj_heightForCellWithConfig:reuseIndentifier:indexPath:commonInfo:)]) {
        return [config.cj_cellClass cj_heightForCellWithConfig:config reuseIndentifier:[self reuseIdentifierForCellConfig:config] indexPath:indexPath commonInfo:self.commonInfo];
    }
    if ([config.cj_cellClass respondsToSelector:@selector(cj_heightForCellWithConfig:reuseIndentifier:indexPath:)]) {
        return [config.cj_cellClass cj_heightForCellWithConfig:config reuseIndentifier:[self reuseIdentifierForCellConfig:config] indexPath:indexPath];
    }
    if ([config respondsToSelector:@selector(cj_defaultHeight)] && config.cj_defaultHeight >= 0) {
        return config.cj_defaultHeight;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CJTableSection * cjSection = self.sectionArray[section];
    id<CJTableHeaderFooterConfig> config = cjSection.header;
    return [self heightForHeadrFooterWithTableView:tableView config:config section:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CJTableSection * cjSection = self.sectionArray[section];
    id<CJTableHeaderFooterConfig> config = cjSection.footer;
    return [self heightForHeadrFooterWithTableView:tableView config:config section:section];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CJTableSection * cjSection = self.sectionArray[section];
    id<CJTableHeaderFooterConfig>config = cjSection.header;
    return [self viewForHeaderFooterWithTableView:tableView config:config section:section];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CJTableSection * cjSection = self.sectionArray[section];
    id<CJTableHeaderFooterConfig> config = cjSection.footer;
    return [self viewForHeaderFooterWithTableView:tableView config:config section:section];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionArray[section].rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJTableSection * cjSection = self.sectionArray[indexPath.section];
    id<CJTableCellConfig> config = cjSection.rowArray[indexPath.row];
    
    Class cellClass = [self validClassForCellConfig:config];
    NSString * reuseIdentifier = [self reuseIdentifierForCellConfig:config];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        NSString * path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(cellClass) ofType:@"nib"];
        if (path) {
            [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        } else {
            [tableView registerClass:cellClass forCellReuseIdentifier:reuseIdentifier];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    }
    if ([cell conformsToProtocol:@protocol(CJTableCellProtocol)]) {
        UITableViewCell<CJTableCellProtocol> *tmpCell = (UITableViewCell<CJTableCellProtocol> *)cell;
        if ([tmpCell respondsToSelector:@selector(cj_setCellConfig:indexPath:commonInfo:)]) {
            [tmpCell cj_setCellConfig:config indexPath:indexPath commonInfo:self.commonInfo];
        }
        if ([tmpCell respondsToSelector:@selector(cj_setCellConfig:)]) {
            [tmpCell cj_setCellConfig:config];
        }
        if ([tmpCell respondsToSelector:@selector(setCj_reloadTableView:)]) {
            __weak typeof(tableView) wTableView = tableView;
            [tmpCell setCj_reloadTableView:^{
                __strong typeof(wTableView) sTableView = wTableView;
                if (!sTableView) return ;
                [sTableView reloadData];
            }];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(cj_didSelectedAtIndexPath:)]) {
        [(id<CJTableCellProtocol>)cell cj_didSelectedAtIndexPath:indexPath];
    }
}

#pragma mark - private

- (Class)validClassForCellConfig:(id<CJTableCellConfig>)config {
    return config.cj_cellClass ?:UITableViewCell.self;
}

- (Class)validClassForHeaderFooterConfig:(id<CJTableHeaderFooterConfig>)config {
    return config.cj_headerFooterClass ?:UIView.self;
}

- (NSString *)reuseIdentifierForCellConfig:(id<CJTableCellConfig>)config {
    NSString * identifier;
    if (config && [config respondsToSelector:@selector(cj_cellRuseIdentifier)]) {
        identifier = config.cj_cellRuseIdentifier;
    }
    return identifier ?:NSStringFromClass([self validClassForCellConfig:config]);
}

- (NSString *)reuseIdentifierForHeaderFooterConfig:(id<CJTableHeaderFooterConfig>)config {
    NSString * identifier;
    if (config && [config respondsToSelector:@selector(cj_headerFooterReuseIndentifier)]) {
        identifier = config.cj_headerFooterReuseIndentifier;
    }
    return identifier ?:NSStringFromClass([self validClassForHeaderFooterConfig:config]);
}

- (CGFloat)heightForHeadrFooterWithTableView:(UITableView *)tableView config:(id<CJTableHeaderFooterConfig>)config section:(NSInteger)section {
    if (config && [config.cj_headerFooterClass respondsToSelector:@selector(cj_heightForHeaderFooterWithConfig:reuseIndentifier:section:commonInfo:)]) {
        return [config.cj_headerFooterClass cj_heightForHeaderFooterWithConfig:config reuseIndentifier:[self reuseIdentifierForHeaderFooterConfig:config] section:section commonInfo:self.commonInfo];
    }
    if (config && [config.cj_headerFooterClass respondsToSelector:@selector(cj_heightForHeaderFooterWithConfig:reuseIndentifier:section:)]) {
        return [config.cj_headerFooterClass cj_heightForHeaderFooterWithConfig:config reuseIndentifier:[self reuseIdentifierForHeaderFooterConfig:config] section:section];
    }
    if ([config respondsToSelector:@selector(cj_defaultHeight)]) {
        return config.cj_defaultHeight;
    }
    return tableView.style == UITableViewStylePlain ?0:CGFLOAT_MIN;
}

- (__kindof UIView *)viewForHeaderFooterWithTableView:(UITableView *)tableView config:(id<CJTableHeaderFooterConfig>)config section:(NSInteger)section {
    if (!config) return nil;
    Class headerFooterClass = [self validClassForHeaderFooterConfig:config];
    NSString * reuseIdentifier = [self reuseIdentifierForHeaderFooterConfig:config];
    UIView * view = nil;
    if ([headerFooterClass isSubclassOfClass:UITableViewHeaderFooterView.self]) {
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
        if (!view) {
            NSString * path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(headerFooterClass) ofType:@"nib"];
            if (path) {
                [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(headerFooterClass) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
            }else {
                [tableView registerClass:headerFooterClass forCellReuseIdentifier:reuseIdentifier];
            }
        }
    }else {
        view = [headerFooterClass new];
    }
    /*
     conformsToProtocol:是用来检查对象（包括其祖先）是否实现了指定协议类的方法。
     参看资料：https://www.jianshu.com/p/76b1431cad56
     */
    if ([view conformsToProtocol:@protocol(CJTableHeaderFooterProtocol)]) {
        UIView<CJTableHeaderFooterProtocol> * tmpView = (UIView<CJTableHeaderFooterProtocol> *)view;
        if ([tmpView respondsToSelector:@selector(cj_setHeaderFooterConfig:section:commonInfo:)]) {
            [tmpView cj_setHeaderFooterConfig:config section:section commonInfo:self.commonInfo];
        }
        if ([tmpView respondsToSelector:@selector(cj_setHeaderFooterConfig:)]) {
            [tmpView cj_setHeaderFooterConfig:config];
        }
        if ([tmpView respondsToSelector:@selector(setCj_reloadTableView:)]) {
            __weak typeof(tableView) wTableView = tableView;
            [tmpView setCj_reloadTableView:^{
                __strong typeof(wTableView) sTableView = wTableView;
                if (sTableView) {
                    [sTableView reloadData];
                }
            }];
        }
    }
    return view;
}

#pragma mark - getter

- (NSMutableArray<CJTableSection *> *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (CJCommonInfo *)commonInfo {
    if (!_commonInfo) {
        _commonInfo = [[CJCommonInfo alloc]init];
    }
    return _commonInfo;
}

@end
