//
//  APMManager.m
//  AdolescentProtectedModeDemo
//
//  Created by Anmo on 2020/2/12.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#define APM_MAX_TIME 200

#import "APMManager.h"
#import "APMNavigationViewController.h"
#import "APMPromptsViewController.h"
#import "APMSetViewController.h"
#import "APMPwdViewController.h"
#import "APMTurnOffViewController.h"
#import "APMPwdViewController.h"

#import "CJAlertView.h"

@interface APMManager ()

/** 定时器*/
@property (nonatomic ,strong)   NSTimer     * playerStatesTimer;

/** 创建后台任务*/
@property (nonatomic ,assign) UIBackgroundTaskIdentifier  backgroundTask;

/** 开启保护模式的时间*/
@property (nonatomic ,assign)  NSInteger    startTime;

/** app回到前台的时间*/
@property (nonatomic ,assign)  NSInteger    becomeTime;

/** app退到后台的时间*/
@property (nonatomic ,assign)  NSInteger    enterBgTime;

/** app可用时长*/
@property (nonatomic ,assign)  NSInteger    canUseTime;

/** 当前时间是否在22:00 - 06:00 时间段内*/
@property (nonatomic ,assign) BOOL          isProtectedTime;

@end

@implementation APMManager


/**
 
 1.如果22:00 - 06:00 时间段内启动程序，直接弹出输入密码使用界面，
    1.1 输入密码正常使用，这个时候开启40分钟检测功能，每四十分钟弹出一次密码输入界面
    1.2 反之则程序不能使用
 
 2.如果时间在 06:00 - 22:00 时间段内启动程序，清除06:00之前存的时间，然后判断今天06:00开始使用总时长有没有超过40分钟，
    2.1 如果总是用时长超过40分钟，则弹出密码输入框界面，输入密码成功后正常使用清除之前的时间，开始新的40分钟计算，密码输入错误则不能使用，
    2.2 如果总是用时长没有超过40分钟程序正常使用，开始40分钟的计算
    2.3 在程序使用过程中，超过40分钟使用时长，弹出密码输入框界面，输入密码成功后正常使用，清除之前的时间，开始新的40分钟计算，密码输入错误则不能使用
 
 3.时间计算逻辑App使用时长为App启动到App杀死（A代表当前启动 B代表上次启动）
    获取tABegin(程序启动时获取的时间)判断上一次App使用时长多少，tBEnd - tBBegin = tBValue，如果tBValue<40分钟正常使用，然后开启时间时间检测，在（40 - tBValue）后弹出密码输入框，如果tBValue>=40分钟，弹出密码输入框，用户输入密码后程序正常使用，以当前时间为起始点开始新一轮的40分钟计算，
 */

static APMManager * _instance = nil;

+ (instancetype)apm_manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


#pragma mark Public

/// 注册服务
- (void)apm_regiseterServer {
    
    // 增加系统通知（退到后台、kill）
    [self apm_addNSNOtification];
    // 开始用户使用时长统计（重App启动开始）
    [self apm_useDurationStatistic];
}

/// 创建通知相关
- (void)apm_addNSNOtification {
    
    //  - 添加通知的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActive)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

/// 事件处理

/** 程序从后台进入到前台的事件监听*/
- (void)appBecomeActive {
    NSLog(@"APM回到前台");
    // 获取回到前台的时间
    self.becomeTime = [[NSDate date] timeIntervalSince1970];
    // 如果此时从后台回到前台的时间>=可用时间则直接弹出密码输入
    NSInteger intervalTime = self.becomeTime - self.enterBgTime;
    // 如果间隔时长小于可使用时长则可以正常使用,否则开启保护模式
    if (intervalTime < (APM_MAX_TIME - self.canUseTime)) {
        self.canUseTime = self.canUseTime + intervalTime;
    }else {
        self.canUseTime = APM_MAX_TIME - 1; // 这里默认减一
    }
    // 这个时候开启定时器因为定时器时间会处理时间
    [self apm_creatTimer];
}

/** 程序进入后台的通知的事件监听 */
-(void)appEnterBackground{
    NSLog(@"APM退到后台");
    // 退到的时候停止定时器
    [self apm_stopTimer];
    // 获取退到后台的时间算出当前可用时间
    self.enterBgTime = [[NSDate date]timeIntervalSince1970];
    
    [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^(){
        //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
        NSLog(@"程序关闭");
    }];
}
/** 程序被杀死通知事件监听 */
-(void)applicationWillTerminate{
    NSLog(@"APM被杀死");
    // 获取杀死应用的时间（杀死应用的时候一定会进入到后台）
    NSInteger killTime = [[NSDate date]timeIntervalSince1970];
    // 计算出退到后台到杀死应用的这个时间段
    NSInteger intervalTime = killTime - self.enterBgTime;
    // 如果这个时间小于可使用时长则下次可以继续使用，否则下次开启保护模式用户输入密码后才可以使用
    if (intervalTime < (APM_MAX_TIME - self.canUseTime)) {
        self.canUseTime = self.canUseTime + intervalTime;
    }else {
        self.canUseTime = APM_MAX_TIME - 1; //这里默认减一
    }
    if (!self.protected) {   // 如果使用时长小于40分钟则保存使用时长时间
        [[NSUserDefaults standardUserDefaults]setInteger:self.canUseTime forKey:self.dateKey];
         NSLog(@"保存了数据%ld key->%@",self.canUseTime,self.dateKey);
        NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:self.dateKey];
        NSLog(@"马上读取数据%ld",time);
    }
    NSLog(@"使用了%lds",self.canUseTime);
}
 
/// 用户使用时长统计开始
- (void)apm_useDurationStatistic {
    
    // 获取当前时间并存起来
    self.startTime = [[NSDate date] timeIntervalSince1970];
    // 用户上回退出应用时的可使用时长
    NSInteger lastUserTime = [[NSUserDefaults standardUserDefaults]integerForKey:self.dateKey];
    NSLog(@"lastUserTime %ld Key ->%@",lastUserTime,self.dateKey);
    // 计算出用户可用时长
    self.canUseTime = lastUserTime;
    // 如果用户开启了青少年保护模式则开始统计
    if ([self apm_status]) {
        // 时间段保护状态22:00 - 06:00
        if (self.isProtectedTime) {
            [self apm_turnOffProtectedPrivate:^(BOOL status) {
                if (status) {
                    // 如果可使用时长小于最大使用时长且现在不是处于保护状态则开启定时器
                    if (self.canUseTime  < APM_MAX_TIME && !self.protected) {
                        [self apm_creatTimer];
                    } else {
                        [self apm_turnOffProtectedPrivate:^(BOOL status) {}];
                    }
                }
            }];
            // 保存状态当前保护状态
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:self.protectedKey];
            // 保存当前最大使用时间
            [[NSUserDefaults standardUserDefaults]setInteger:APM_MAX_TIME - 1 forKey:self.dateKey];
            
        } else {
            // 如果可使用时长小于最大使用时长且现在不是处于保护状态则开启定时器
            if (self.canUseTime  < APM_MAX_TIME && !self.protected) {
                [self apm_creatTimer];
            } else {
                [self apm_turnOffProtectedPrivate:^(BOOL status) {
                    NSLog(@"关闭保护模式成功");
                }];
            }
        }
  
    } else {
        [self apm_showPromptsVcContent:@"123"];
    }
}

/// 关闭保护模式保护
- (void)apm_turnOffProtectedPrivate:(void(^)(BOOL status))block{

    UIViewController * currentView = [self apm_getCurrentVC];
    __weak UIViewController * weakVC = currentView;
    APMTurnOffViewController * turnOffVC = [APMTurnOffViewController new];
    APMNavigationViewController * apmNav = [[APMNavigationViewController alloc]initWithRootViewController:turnOffVC];
    apmNav.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    [weakVC presentViewController:apmNav animated:YES completion:^{ }];
    __weak typeof(self)weakSelf = self;
    turnOffVC.APMTrunOffBlock = ^(BOOL status) {
        if (status) {
            // 清除使用时长,开启新的计时
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:weakSelf.dateKey];
            // 清除保护模式状态
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:self.protectedKey];
            // 回调状态
            if (block) {
                block(status);
            }
            // 开启新的使用时长统计
            [weakSelf apm_useDurationStatistic];
        }
    };
    
}

/// 创建定时器
- (void)apm_creatTimer {
    
    [self apm_stopTimer];
    //添加定时器的时候先看是否用户进行了返回操作如果有返回操作就不用添加定时器了
    if (self.playerStatesTimer == nil) {
        //自动切源的时间调短点 这里用弱引用（有时候可能无法释放问题）
        __weak typeof(self) WeakSelf = self;
        self.playerStatesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:WeakSelf selector:@selector(apm_timerAction) userInfo:nil repeats:YES];
    }
}

/// 停止定时器
- (void)apm_stopTimer {
    
    [self.playerStatesTimer invalidate];
    self.playerStatesTimer = nil;
}

- (void)apm_timerAction {
    
    NSLog(@"定时器 %ld",self.canUseTime);
    self.canUseTime++;
    
    if (self.canUseTime >= APM_MAX_TIME) {
        // 暂停定时器
        [self apm_stopTimer];
        //  如果不是保护状态则弹出
        if (!self.protected) {
            [self apm_turnOffProtectedPrivate:^(BOOL status) {
                
            }];
        }
        // 保存状态当前保护状态
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:self.protectedKey];
        // 保存当前最大使用时间
        [[NSUserDefaults standardUserDefaults]setInteger:APM_MAX_TIME - 1 forKey:self.dateKey];
    }
}

- (void)apm_showPromptsVcContent:(NSString *)content {
    
    UIViewController * currentView = [self apm_getCurrentVC];
    __weak UIViewController * weakVC = currentView;
    APMPromptsViewController * apmVc = [APMPromptsViewController new];
    apmVc.hiddenNavBar = YES;
    APMNavigationViewController * apmNav = [[APMNavigationViewController alloc]initWithRootViewController:apmVc];
    apmNav.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    [weakVC presentViewController:apmNav animated:YES completion:^{
        
    }];
}

- (void)apm_showSetAPMVcContent:(NSString *)content Block:(void (^)(BOOL))block {
    
     UIViewController * currentView = [self apm_getCurrentVC];
    __weak UIViewController * weakVC = currentView;
    __weak typeof(self)weakSelf = self;
    APMSetViewController * setVC = [APMSetViewController new];
    setVC.userContent = content;
    APMNavigationViewController * apmNav = [[APMNavigationViewController alloc]initWithRootViewController:setVC];
    apmNav.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    [weakVC presentViewController:apmNav animated:YES completion:^{
        
    }];
    setVC.APMSetViewBlock = ^(NSString * _Nonnull pwd, APMPwdType type, UIViewController * _Nonnull vc) {
        //  保存密码
        [[NSUserDefaults standardUserDefaults]setObject:pwd forKey:APM_PWD_KEY];
        if (type == APMPwdSet) {
            // 开启青少年模式成功直接返回应用层面
            [weakVC dismissViewControllerAnimated:YES completion:^{}];
            // 开启使用时长统计
            [weakSelf apm_regiseterServer];
            // 状态回调
            block(YES);
        } else if(type == APMPwdReset){
            [vc.navigationController popToRootViewControllerAnimated:YES];
        
        }else {
            // 清除密码
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:APM_PWD_KEY];
            //清除使用时长,开启新的计时
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:self.dateKey];
            // 关闭定时器
            [weakSelf apm_stopTimer];
            [vc.navigationController popToRootViewControllerAnimated:YES];
        }
    };
}

- (void)apm_turnOffProtected:(void (^)(BOOL))block {
    
    if (!self.apm_status) {return;}
    UIViewController * currentView = [self apm_getCurrentVC];
    __weak UIViewController * weakVC = currentView;
    // 开启青少年保护模式
    APMPwdViewController * pwdVc = [[APMPwdViewController alloc]init];
    pwdVc.title = @"密码验证";
    pwdVc.titleStr =@"输入密码";
    pwdVc.hiddenMarkLabel = APMPwdVerify;
    pwdVc.hiddenResetLabel = NO;
    __weak typeof(self)weakSelf = self;
    pwdVc.pwdBlock = ^(NSString * _Nonnull pwdString) { // 密码输入完成后要做的事情
         [weakSelf apm_verifyPwd:weakVC PwdStr:pwdString Block:^(BOOL status) {
             block(status);
         }];
     };
    APMNavigationViewController * apmNav = [[APMNavigationViewController alloc]initWithRootViewController:pwdVc];
    apmNav.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    [weakVC presentViewController:apmNav animated:YES completion:^{}];
}

/// 验证密码
- (void)apm_verifyPwd:(UIViewController *)vc PwdStr:(NSString *)pwdStr Block:(void(^)(BOOL status))block{
    
    NSString * savePwd = [[NSUserDefaults standardUserDefaults]objectForKey:APM_PWD_KEY];
    if ([savePwd isEqualToString:pwdStr]) {
        // 清除密码
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:APM_PWD_KEY];
        // 清除使用时长,开启新的计时
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:self.dateKey];
        [CJAlertView showMessage:@"已关闭青少年保护模式" completion:^{}];
        // 停止定时器
        [self apm_stopTimer];
        // 页面消失
        [vc.navigationController dismissViewControllerAnimated:YES completion:^{}];
        // 回调状态
        block(YES);
    }else {
        [CJAlertView showMessage:@"密码错误,请重新输入" completion:^{
            
        }];
    }
}


- (BOOL)apm_status {
    
    NSString * pwd = [[NSUserDefaults standardUserDefaults]objectForKey:APM_PWD_KEY];
    BOOL status = (pwd&&pwd.length >= 4);
    return status;
    
}

#pragma mark - Private

- (BOOL)apm_judgeTimeByToday {
    
    NSArray * hourArr = @[@"22",@"23",@"00",@"01",@"02",@"03",@"04",@"05",@"06"];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"HH"];
    NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    BOOL isIncloud = [hourArr containsObject: todayStr];
    return isIncloud;
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)apm_getCurrentVC {
    
    UIViewController *result = nil;
    // 获取默认的window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    // 获取window的rootViewController
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

#pragma mark - Getter

- (NSString *)dateKey {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateKey = [formatter stringFromDate:date];
    return dateKey;
}

- (NSString  *)protectedKey {
    NSString * protectedKey = [NSString stringWithFormat:@"protected%@",self.dateKey];
    return protectedKey;
}

- (BOOL)protected {
    BOOL protected = [[NSUserDefaults standardUserDefaults]boolForKey:self.protectedKey];
    return protected;
}

- (BOOL)isProtectedTime {
    BOOL isProtect = [self apm_judgeTimeByToday];
    return isProtect;
}

@end
