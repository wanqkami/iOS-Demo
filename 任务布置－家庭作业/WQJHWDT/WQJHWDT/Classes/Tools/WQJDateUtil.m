//
//  WQJDataUtil.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "WQJDateUtil.h"

@implementation WQJDateUtil

+ (NSString *)getDateString
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+ (NSString *)toStringWithDate:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    return fixString;
}

@end
