//
//  Person.m
//  数据持久化-归档
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import "Person.h"

#define kNameKey        @"name"
#define kGenderKey      @"gender"
#define kAgeKey         @"age"
#define KEducationKey   @"education"

@implementation Person

#pragma mark -
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kNameKey];
    [aCoder encodeObject:self.gender forKey:kGenderKey];
    [aCoder encodeObject:self.age forKey:kAgeKey];
    [aCoder encodeObject:self.education forKey:KEducationKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.name = [aDecoder decodeObjectForKey:kNameKey];
        self.gender = [aDecoder decodeObjectForKey:kGenderKey];
        self.age = [aDecoder decodeObjectForKey:kAgeKey];
        self.education = [aDecoder decodeObjectForKey:KEducationKey];
    }
    return self;
}


#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    Person * person = [[Person alloc] init];
    return person;
}

@end
