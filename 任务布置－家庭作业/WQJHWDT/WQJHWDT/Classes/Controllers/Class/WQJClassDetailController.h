//
//  WQJClassDetailController.h
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQJClass.h"

@interface WQJClassDetailController : UITableViewController

@property (nonatomic, strong) WQJClass * wqjClass;
@property (nonatomic, strong) NSArray * studentArray;

@end
