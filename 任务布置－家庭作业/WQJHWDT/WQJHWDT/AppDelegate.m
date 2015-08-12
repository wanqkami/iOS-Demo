//
//  AppDelegate.m
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    BOOL isTest = true;
    
    // 注册Bmob
    NSString * appKey = @"e5176c110243ca7ea1b3b64b2c8fa208";
    [Bmob registerWithAppKey:appKey];

    // 安装键盘管理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    // 判断是否是第一次启动app
    // 取plist里的版本号
    NSString * versionKey = (NSString *) kCFBundleVersionKey;
    NSString * versionValue = [NSBundle mainBundle].infoDictionary[versionKey];
    // 从沙箱中取上次存储的版本号
    NSString * saveVersionValue = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    if ([versionKey isEqualToString:saveVersionValue] || isTest) {
        // 不是第一次使用这个版本
        // 不显示状态
        application.statusBarHidden = NO;
        
    } else {
        // 第一次运行
        //将新版本号写入沙箱
        [[NSUserDefaults standardUserDefaults] setObject:versionValue forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //显示版本新特性界面
        
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)customNavigationBar{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置背景色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:176/255.0 blue:227/255.0 alpha:1]];
    //设置有导航条时,状态栏的文字颜色
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}
@end
