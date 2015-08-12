//
//  BoxView.m
//  2048
//
//  Created by tarena on 15/7/9.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "BoxView.h"

@implementation BoxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setValue:(NSInteger)value
{
    _value = value;
    self.text = [NSString stringWithFormat:@"%d",value ];
    self.font = [UIFont boldSystemFontOfSize:32];
    self.textAlignment = NSTextAlignmentCenter;
        switch (value) {
        case 1<<1:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1<<2:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1<<3:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1<<4:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1<<5:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1<<7:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1<<8:
            self.backgroundColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
