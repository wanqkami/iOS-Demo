//
//  WQJHomworkBase.h
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/2.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQJHomeworkBase : NSObject

typedef enum {
    WQJHomeworkStateNone = 0,
    WQJHomeworkStateDone,
    
    WQJHomeworkStateUndone,
    WQJHomeworkStateDifficult
} WQJHomeworkState;

@end
