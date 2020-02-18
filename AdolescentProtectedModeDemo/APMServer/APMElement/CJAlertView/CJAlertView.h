//
//  CJAlertView.h
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/14.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJAlertView : UIView

+(void)showMessage:(NSString *)message completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
