//
//  NSString+WQJExpand.m
//  WQJHomeworkTodo
//
//  Created by tarena on 15/7/23.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "NSString+WQJExpand.h"

@implementation NSString (WQJExpand)

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

@end
