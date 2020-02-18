//
//  CJCollectionIMP.h
//  CJHandyListDemo
//
//  Created by Anmo on 2019/12/17.
//  Copyright © 2019 com.Cingjin. All rights reserved.
//

#import "CJCommonInfo.h"
#import "CJCollectionSection.h"

NS_ASSUME_NONNULL_BEGIN

/**
 代理实现类，可以直接抽出来作为UICollectionView的 delegate 和 dataSource 若想实现更多的代理方法，继承于该类在子类中拓展就行了
 */
@interface CJCollectionIMP : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 数据源*/
@property (nonatomic ,strong) NSMutableArray<CJCollectionSection *>* sectionArray;

/** 公共信息对象，将会下发到Cell/Header/Footer*/
@property (nonatomic ,strong) CJCommonInfo * commonInfo;

/** 是否激活 UICollectionViewFlowLatout 的布局属性，默认为NO*/
@property (nonatomic ,assign) BOOL  enabledFlowLayoutProperties;

@end

NS_ASSUME_NONNULL_END
