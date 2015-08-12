//
//  NSObject+WQJExpand.m
//  WQJHomeworkTodo
//
//  Created by tarena on 15/7/23.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "NSObject+WQJExpand.h"

@implementation NSObject (WQJExpand)


- (BOOL)isEmpty
{
    if (self == nil || [self isEqual:@""]) {
        return  true;
    }
    return false;
}

@end
