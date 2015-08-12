//
//  WQJChooseLibController.h
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/2.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQJChooseLibController : UITableViewController

typedef void(^SetLibBlock)(NSString * libID, NSString *libTitle);

@property (nonatomic, copy) SetLibBlock setlibBlock;

@end
