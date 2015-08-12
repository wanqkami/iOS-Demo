//
//  WQJChooseClassController.h
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/2.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQJChooseClassController : UITableViewController

typedef void (^SetClassBlock)(NSString *classID, NSString *className); //定义一个block

@property (nonatomic, copy) SetClassBlock setClassBlock;

@end
