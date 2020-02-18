//
//  APMContentModel.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/13.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMContentModel : NSObject

/** content*/
@property (nonatomic ,copy) NSString    * content;

/** hiddenOval*/
@property (nonatomic ,assign) BOOL      hiddenOval;

/** cellHeight*/
@property (nonatomic ,assign) CGFloat   cellHeight;

@end

NS_ASSUME_NONNULL_END
