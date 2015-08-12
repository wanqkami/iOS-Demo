//
//  WQJHubUtil.m
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "WQJHudUtil.h"

@implementation WQJHudUtil


static MBProgressHUD * HUD;
static WQJHudUtil * util;
+ (instancetype)shareUtil
{
    if (util == nil) {
        util = [[WQJHudUtil alloc] init];
    }
    return util;
}


- (void)showSimpleOnView:(UIView *)view {
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
//    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [HUD show:YES];
}

- (void)showWithLabelOnView:(UIView *)view {
    
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showWithDetailsLabelOnView:(UIView *)view {
    
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"updating data";
    HUD.square = YES;
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showWithCustomViewOnView:(UIView *)view {
    
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = @"Completed";
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];
}

- (void)showWithGradientOnView:(UIView *)view {
    
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.dimBackground = YES;
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)showOnWindowOnView:(UIView *)view {
    // The hud will dispable all input on the window
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
//    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [HUD show:YES];
}

- (void)hide
{
    [HUD hide:YES];
}


- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}


#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
//    [HUD release];
    HUD = nil;
}

@end
