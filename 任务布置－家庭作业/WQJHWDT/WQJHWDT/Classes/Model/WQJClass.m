//
//  WQJClass.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "WQJClass.h"

@implementation WQJClass

- (instancetype)initWithID:(NSString *)classID name:(NSString *)className description:(NSString *)classDesc createByUserId:(NSString *)createByUserId
{
    self = [super init];
    if (self) {
        self.classID = classID;
        self.className = className;
        self.classDesc = classDesc;
        self.createByUserId = createByUserId;
    }
    return self;
}

@end
