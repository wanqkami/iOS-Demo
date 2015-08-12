//
//  Person.h
//  数据持久化-归档
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCopying, NSCoding>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * age;
@property (nonatomic, strong) NSString * education;

@end
