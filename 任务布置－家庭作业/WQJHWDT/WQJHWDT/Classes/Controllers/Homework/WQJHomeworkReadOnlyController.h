//
//  WQJHomeworkReadOnlyController.h
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/2.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQJHomeworkController.h"

@interface WQJHomeworkReadOnlyController : UITableViewController

@property (nonatomic, strong) NSString * libID;
@property (nonatomic, strong) NSString * libTitle;
@property (nonatomic, strong) NSString * libContent;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic, strong) NSArray * libImageArray;

@property (nonatomic, strong) NSString * taskUserRefID;

@property (nonatomic, assign) BOOL done;

//@property (nonatomic, weak) WQJHomeworkController * homeworkController;


@end
