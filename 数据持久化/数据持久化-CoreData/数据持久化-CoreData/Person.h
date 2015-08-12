//
//  Person.h
//  数据持久化-CoreData
//
//  Created by 万齐鹣 on 15/7/16.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * education;

@end
