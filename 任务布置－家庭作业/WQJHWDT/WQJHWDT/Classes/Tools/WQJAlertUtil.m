//
//  WQJAlertUtil.m
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "WQJAlertUtil.h"
#import "DXAlertView.h"

@implementation WQJAlertUtil

+ (void)showTwoBtnAlertWithTitle:(NSString *)title content:(NSString *)context leftBtnText:(NSString *)leftBtnText rightBtnText:(NSString *)rightBtnText
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:context leftButtonTitle:leftBtnText rightButtonTitle:rightBtnText];
    [alert show];
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
}

+ (void)showOneBtnAlertWithTitle:(NSString *)title content:(NSString *)context rightBtnText:(NSString *)rightBtnText
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:context leftButtonTitle:nil rightButtonTitle:rightBtnText];
    [alert show];
    alert.rightBlock = ^() {
//        NSLog(@"right button clicked");
    };
    alert.dismissBlock = ^() {
//        NSLog(@"Do something interesting after dismiss block");
    };
}

+ (void)showOneBtnAlertWithTitle:(NSString *)title content:(NSString *)context rightBtnText:(NSString *)rightBtnText block:(dispatch_block_t)block
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:context leftButtonTitle:nil rightButtonTitle:rightBtnText];
    [alert show];
    alert.rightBlock = block;
    
    alert.dismissBlock = ^() {
        //        NSLog(@"Do something interesting after dismiss block");
    };
}
@end
