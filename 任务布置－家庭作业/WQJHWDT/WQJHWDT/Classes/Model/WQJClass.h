//
//  WQJClass.h
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQJClass : NSObject

@property (nonatomic, strong) NSString * classID;
@property (nonatomic, strong) NSString * className;
@property (nonatomic, strong) NSString * classDesc;

@property (nonatomic, strong) NSString * createByUserId;

- (instancetype)initWithID:(NSString *)classID name:(NSString *)className description:(NSString *)classDesc createByUserId:(NSString *)createByUserId;

@end
