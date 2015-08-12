//
//  WQJHubUtil.h
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface WQJHudUtil : NSObject <MBProgressHUDDelegate>

- (void)showSimpleOnView:(UIView *)view;

- (void)showOnWindowOnView:(UIView *)view;

- (void)hide;

+ (instancetype)shareUtil;

@end
