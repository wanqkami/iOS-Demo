//
//  ViewController.h
//  数据持久化-归档
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName   @"archive"
#define kDataKey    @"Data"


@interface ViewController : UIViewController


-(NSString *)dataFilePath;
-(void)applicationWillResignActive:(NSNotification *)nofication;
@end
