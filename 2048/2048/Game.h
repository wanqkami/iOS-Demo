//
//  Game.h
//  2048
//
//  Created by tarena on 15/7/9.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoxView.h"

@interface Game : NSObject

//移动的方向
typedef enum {
    MoveDirectionUp,
    MoveDirectionLeft,
    MoveDirectionDown,
    MoveDirectionRight
} MoveDirection;


- (instancetype)init;


// 创建一个box
- (BoxView *)createBoxView:(NSInteger*)index;

- (BOOL)isOver;

- (void)lookBox;

- (NSArray *)boxMove:(MoveDirection)direction;

@end
