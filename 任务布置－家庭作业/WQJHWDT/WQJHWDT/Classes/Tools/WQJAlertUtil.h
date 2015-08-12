//
//  WQJAlertUtil.h
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQJAlertUtil : NSObject

+ (void)showOneBtnAlertWithTitle:(NSString *)title content:(NSString *)context rightBtnText:(NSString *)rightBtnText;
+ (void)showOneBtnAlertWithTitle:(NSString *)title content:(NSString *)context rightBtnText:(NSString *)rightBtnText block:(dispatch_block_t)block;

@end
