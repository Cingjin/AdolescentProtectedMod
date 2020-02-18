//
//  CJCollectionIMP.m
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCollectionIMP.h"

@implementation CJCollectionIMP {
    NSMutableSet    *_resueCellSet;
    NSMutableSet    *_resueHeaderSet;
    NSMutableSet    *_resueFooterSet;
}

#pragma mark - life cycle


- (instancetype)init
{
    self = [super init];
    if (self) {
        _resueCellSet = [NSMutableSet set];
        _resueHeaderSet = [NSMutableSet set];
        _resueFooterSet = [NSMutableSet set];
        
        _enabledFlowLayoutProperties = NO;
    }
    return self;
}

#pragma mark - <UICollectionViewDatasource,UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sectionArray[section].rowArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CJCollectionSection * cj_Section = self.sectionArray[indexPath.section];
    id<CJCollectionCellConfig>config = cj_Section.rowArray[indexPath.row];
    Class cellClass = [self validClassForCellConfig:config];
    NSString * identifier = [self reuseIdentifierForCellConfig:config];
    if (![_resueCellSet containsObject:identifier]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(cellClass) ofType:@"nib"];
        if (path) {
            [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellWithReuseIdentifier:identifier];
        }else {
            [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        }
        [_resueCellSet addObject:identifier];
    }
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(CJCollectionCellProtocol)]) {
        UICollectionViewCell<CJCollectionCellProtocol>*tempCell = (UICollectionViewCell<CJCollectionCellProtocol>*)cell;
        if ([tempCell respondsToSelector:@selector(cj_setHeaderFooterConfig:section:commonInfo:)]) {
            [tempCell cj_setCellConfig:config indexPath:indexPath commonInfo:self.commonInfo];
        }
        if ([tempCell respondsToSelector:@selector(cj_setCellConfig:)]) {
            [tempCell cj_setCellConfig:config];
        }
        if ([tempCell respondsToSelector:@selector(setCj_reloadCollectionView:)]) {
            __weak typeof(collectionView)wCollectionView = collectionView;
            [tempCell setCj_reloadCollectionView:^{
                __strong typeof(wCollectionView)collectionView = wCollectionView;
                if (!collectionView) return ;
                [collectionView reloadData];
            }];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CJCollectionSection * cj_Section = self.sectionArray[indexPath.section];
    id<CJCollectionHeaderFooterConfig> config;
    NSMutableSet *reuseSet;
    if (kind == UICollectionElementKindSectionHeader) {
        config = cj_Section.header;
        reuseSet = _resueHeaderSet;
    }else if (kind == UICollectionElementKindSectionFooter) {
        config = cj_Section.footer;
        reuseSet = _resueFooterSet;
    }else {
        return nil;
    }
    Class cls = [self validClassForHeaderFooterConfig:config];
    NSString * identifier = [self reuseIdentifierForHeaderFooterConfig:config];
    if (![reuseSet containsObject:identifier]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(cls) ofType:@"nib"];
        if (path) {
            [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
        }else {
            [collectionView registerClass:cls forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
        }
        [reuseSet addObject:identifier];
    }
    
    UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    if ([view conformsToProtocol:@protocol(CJCollectionHeaderFooterProtocol)]) {
        UICollectionReusableView<CJCollectionHeaderFooterProtocol> *tempView = (UICollectionReusableView<CJCollectionHeaderFooterProtocol> *)view;
        if ([tempView respondsToSelector:@selector(cj_setHeaderFooterConfig:indexPath:commonInfo:)]) {
            [tempView cj_setHeaderFooterConfig:config indexPath:indexPath commonInfo:self.commonInfo];
        }
        if ([tempView respondsToSelector:@selector(cj_setHeaderFooterConfig:)]) {
            [tempView cj_setHeaderFooterConfig:config];
        }
        if ([tempView respondsToSelector:@selector(setCj_reloadCollectionView:)]) {
            __weak typeof(collectionView)wCollectionView = collectionView;
            [tempView setCj_reloadCollectionView:^{
                __strong typeof(wCollectionView)collectionView = wCollectionView;
                if (!collectionView)return ;
                [collectionView reloadData];
            }];
        }
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(cj_didSelectedAtIndexPath:)]) {
        [(id<CJCollectionCellProtocol>)cell cj_didSelectedAtIndexPath:indexPath];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.enabledFlowLayoutProperties && [collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.self]) {
        return ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize;
    }
    CJCollectionSection * cj_Section = self.sectionArray[indexPath.section];
    id<CJCollectionCellConfig>config = cj_Section.rowArray[indexPath.row];
    NSString * identifier = [self reuseIdentifierForCellConfig:config];
    if ([config.cj_cellClass respondsToSelector:@selector(cj_sizeForCellWithConfig:reuseIndentifier:indexPath:sectionPack:commonInfo:)]) {
       return [config.cj_cellClass cj_sizeForCellWithConfig:config reuseIndentifier:identifier indexPath:indexPath sectionPack:cj_Section commonInfo:self.commonInfo];
    }
    if ([config.cj_cellClass respondsToSelector:@selector(cj_sizeForCellWithConfig:reuseIndentifier:indexPath:sectionPack:)]) {
       return [config.cj_cellClass cj_sizeForCellWithConfig:config reuseIndentifier:identifier indexPath:indexPath sectionPack:cj_Section];
    }
    if ([config respondsToSelector:@selector(cj_defaultSize)] && !CGSizeEqualToSize(config.cj_defaultSize, CGSizeZero)) {
        return config.cj_defaultSize;
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.enabledFlowLayoutProperties && [collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.self]) {
        return ((UICollectionViewFlowLayout *)collectionViewLayout).headerReferenceSize;
    }
    CJCollectionSection * cj_Section = self.sectionArray[section];
    id<CJCollectionHeaderFooterConfig> config = cj_Section.header;
    return [self sizeForHeaderFooterWithConfig:config section:section sectionPack:cj_Section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.enabledFlowLayoutProperties && [collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.self]) {
        return ((UICollectionViewFlowLayout *)collectionView).minimumLineSpacing;
    }
    return self.sectionArray[section].minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.enabledFlowLayoutProperties && [collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.self]) {
        return ((UICollectionViewFlowLayout *)collectionView).minimumInteritemSpacing;
    }
    return self.sectionArray[section].minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.enabledFlowLayoutProperties && [collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.self]) {
        return ((UICollectionViewFlowLayout *)collectionView).sectionInset;
    }
    return self.sectionArray[section].inset;
}

#pragma mark - private

- (Class)validClassForCellConfig:(id<CJCollectionCellConfig>)config {
    return config.cj_cellClass ?:UICollectionViewCell.self;
}

- (Class)validClassForHeaderFooterConfig:(id<CJCollectionHeaderFooterConfig>)config {
    return config.cj_headerFooterClass ?:UICollectionReusableView.self;
}

- (NSString *)reuseIdentifierForCellConfig:(id<CJCollectionCellConfig>)config {
    NSString *identifier;
    if (config && [config respondsToSelector:@selector(cj_cellRuseIdentifier)]) {
        identifier = config.cj_cellRuseIdentifier;
    }
    return identifier ?:NSStringFromClass([self validClassForCellConfig:config]);
}

- (NSString *)reuseIdentifierForHeaderFooterConfig:(id<CJCollectionHeaderFooterConfig>)config {
    NSString * identifier;
    if (config && [config respondsToSelector:@selector(cj_headerFooterReuseIdentifier)]) {
        identifier = config.cj_headerFooterReuseIdentifier;
    }
    return identifier ?:NSStringFromClass([self validClassForHeaderFooterConfig:config]);
}

- (CGSize)sizeForHeaderFooterWithConfig:(id<CJCollectionHeaderFooterConfig>)config section:(NSInteger)section sectionPack:(CJCollectionSection *)sectionPack {
    NSString * sectionReuseIdentifier = [self reuseIdentifierForHeaderFooterConfig:config];
    if (config && [config.cj_headerFooterClass respondsToSelector:@selector(cj_sizeForHeaderFooterWithConfig:reuseIndentifier:section:sectionPack:commonInfo:)]) {
        return [config.cj_headerFooterClass cj_sizeForHeaderFooterWithConfig:config reuseIndentifier:sectionReuseIdentifier section:section sectionPack:sectionPack commonInfo:self.commonInfo];
    }
    if (config && [config.cj_headerFooterClass respondsToSelector:@selector(cj_sizeForHeaderFooterWithConfig:reuseIndentifier:section:sectionPack:)]) {
        return [config.cj_headerFooterClass cj_sizeForHeaderFooterWithConfig:config reuseIndentifier:sectionReuseIdentifier section:section sectionPack:sectionPack];
    }
    if ([config respondsToSelector:@selector(cj_defaultSize)] && !CGSizeEqualToSize(config.cj_defaultSize, CGSizeZero)) {
        return config.cj_defaultSize;
    }
    return CGSizeZero;
}

#pragma mark - getter

- (NSMutableArray<CJCollectionSection *> *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (CJCommonInfo *)commonInfo {
    if (!_commonInfo) {
        _commonInfo = [CJCommonInfo new];
    }
    return _commonInfo;
}

@end
