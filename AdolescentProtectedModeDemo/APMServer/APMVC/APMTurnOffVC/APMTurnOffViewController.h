//
//  APMTurnOffViewController.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/15.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "APMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface APMTurnOffViewController : APMBaseViewController

/** APMTrunOffBlock*/
@property (nonatomic ,copy) void(^APMTrunOffBlock)(BOOL status);

/// titleStr
@property (nonatomic ,copy) NSString        * titleStr;

/// hiddenMarkLabel
@property (nonatomic ,assign) BOOL          hiddenMarkLabel;

/// hiddenResetLabel
@property (nonatomic ,assign) BOOL          hiddenResetLabel;


@end

NS_ASSUME_NONNULL_END
