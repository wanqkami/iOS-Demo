//
//  Game.m
//  2048
//
//  Created by tarena on 15/7/9.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "Game.h"

@implementation Game
{
    // 棋盘 2维数组 4X4
    int boxBoard[4][4];
    int boxNumber;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        // 棋盘初始化
        for (int i=0; i<4; i++) {
            for (int j=0; j<4; j++) {
                boxBoard[i][j] = 0;
            }
        }
        boxNumber = 0;
    
    }
    return self;
}

// 寻找随机空的位置
- (NSInteger)getNewSite:(int)value
{
    while (boxNumber<16) {
        int i = arc4random_uniform(4);
        int j = arc4random_uniform(4);
        if (!boxBoard[i][j]) {
            boxBoard[i][j]=value;
            boxNumber++;
            return i*4+j;
        }
    }
    return 0;
}


- (BoxView *)createBoxView:(NSInteger*)index
{
    if (boxNumber<16) {
        BoxView * box = [[BoxView alloc] init];
        box.value = 2;
        *index = [self getNewSite:box.value];
        return box;
    }else {
        return nil;
    }
}

- (void)lookBox
{
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            printf("%4d",boxBoard[i][j]);
        }
        printf("\n");
    }
}

- (NSArray *)boxMove:(MoveDirection)direction

{
    NSMutableArray * mutableArray = [NSMutableArray array];
    switch (direction) {
        case MoveDirectionUp:
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    int start = i*4+j;
                    int end = i;
                    int type = 0;
                    //当前位置是否存在box
                    if (boxBoard[i][j]) {
                        // 存在box，判断上滑动方向是否存在空位置
                        while (end>0) {
                            //当前位置不在边缘，检查前边的位置是否为空
                            if (boxBoard[end-1][j]) {
                                //不为空
                                //判断是否数字是否相等
                                if (boxBoard[end-1][j]==boxBoard[end][j]) {
                                    type = 1;
                                    boxBoard[end-1][j]=boxBoard[end][j]*2;
                                    boxBoard[end][j] = 0;
                                    end = end-1;
                                    boxNumber--;
                                }
                                break;
                            }else{
                                type = 0;
                                boxBoard[end-1][j]=boxBoard[end][j];
                                boxBoard[end][j] = 0;
                            }
                            end = end-1;
                        }
                    }
                    
                    if (end != i) {
                        NSDictionary * dic = @{@"from":[NSNumber numberWithInt:start],@"to":[NSNumber numberWithInt:end*4+j], @"type":[NSNumber numberWithInt:type]};
                        
                        [mutableArray addObject:dic];
                    }
                }
            }
            
            break;
        case MoveDirectionLeft:
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    int start = i*4+j;
                    int end = j;
                    int type = 0;
                    //当前位置是否存在box
                    if (boxBoard[i][j]) {
                        // 存在box，判断上滑动方向是否存在空位置
                        while (end>0) {
                            //当前位置不在边缘，检查前边的位置是否为空
                            if (boxBoard[i][end-1]) {
                                //不为空
                                //判断是否数字是否相等
                                if (boxBoard[i][end-1]==boxBoard[i][end]) {
                                    type = 1;
                                    boxBoard[i][end-1]=boxBoard[i][end]*2;
                                    boxBoard[i][end] = 0;
                                    end = end-1;
                                    boxNumber--;
                                }
                                break;
                            }else{
                                type = 0;
                                boxBoard[i][end-1]=boxBoard[i][end];
                                boxBoard[i][end] = 0;
                            }
                            end = end-1;
                        }
                    }
                    
                    if (end != j) {
                        NSDictionary * dic = @{@"from":[NSNumber numberWithInt:start],@"to":[NSNumber numberWithInt:i*4+end], @"type":[NSNumber numberWithInt:type]};
                        
                        [mutableArray addObject:dic];
                    }
                }
            }

            break;
        case MoveDirectionDown:
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    int start = i*4+j;
                    int end = i;
                    int type = 0;
                    //当前位置是否存在box
                    if (boxBoard[i][j]) {
                        // 存在box，判断上滑动方向是否存在空位置
                        while (end<3) {
                            //当前位置不在边缘，检查前边的位置是否为空
                            if (boxBoard[end+1][j]) {
                                //不为空
                                //判断是否数字是否相等
                                if (boxBoard[end+1][j]==boxBoard[end][j]) {
                                    type = 1;
                                    boxBoard[end+1][j]=boxBoard[end][j]*2;
                                    boxBoard[end][j] = 0;
                                    end = end+1;
                                    boxNumber--;
                                }
                                break;
                            }else{
                                type = 0;
                                boxBoard[end+1][j]=boxBoard[end][j];
                                boxBoard[end][j] = 0;
                            }
                            end = end+1;
                        }
                    }
                    
                    if (end != i) {
                        NSDictionary * dic = @{@"from":[NSNumber numberWithInt:start],@"to":[NSNumber numberWithInt:end*4+j], @"type":[NSNumber numberWithInt:type]};
                        
                        [mutableArray addObject:dic];
                    }
                }
            }
            break;
        case MoveDirectionRight:
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    int start = i*4+j;
                    int end = j;
                    int type = 0;
                    //当前位置是否存在box
                    if (boxBoard[i][j]) {
                        // 存在box，判断上滑动方向是否存在空位置
                        while (end<3) {
                            //当前位置不在边缘，检查前边的位置是否为空
                            if (boxBoard[i][end+1]) {
                                //不为空
                                //判断是否数字是否相等
                                if (boxBoard[i][end+1]==boxBoard[i][end]) {
                                    type = 1;
                                    boxBoard[i][end+1]=boxBoard[i][end]*2;
                                    boxBoard[i][end] = 0;
                                    end = end+1;
                                    boxNumber--;
                                }
                                break;
                            }else{
                                type = 0;
                                boxBoard[i][end+1]=boxBoard[i][end];
                                boxBoard[i][end] = 0;
                            }
                            end = end+1;
                        }
                    }
                    
                    if (end != j) {
                        NSDictionary * dic = @{@"from":[NSNumber numberWithInt:start],@"to":[NSNumber numberWithInt:i*4+end], @"type":[NSNumber numberWithInt:type]};
                        
                        [mutableArray addObject:dic];
                    }
                }
            }

            break;
        default:
            break;
    }
    
    
    return  [mutableArray copy];
}




// 判断是否结束
- (BOOL)isOver
{
    // 检查是不是满了
    if (boxNumber == 16) {
        // 判断存不存在相邻的数字相同，可以合并
        for (int i=0; i<4; i++) {
            for (int j=0; j<4; j++) {
                if (i-1>=0) {
                    if (boxBoard[i][j]==boxBoard[i-1][j]) {
                        return NO;
                    }
                }
                if (i+1<4) {
                    if (boxBoard[i][j]==boxBoard[i+1][j]) {
                        return NO;
                    }
                }
                if (j-1>=0) {
                    if (boxBoard[i][j]==boxBoard[i][j-1]) {
                        return NO;
                    }
                }
                if (j+1<4) {
                    if (boxBoard[i][j]==boxBoard[i][j+1]) {
                        return NO;
                    }
                }
                return  YES;
            }
        }
    }
    
    return NO;
}

@end
