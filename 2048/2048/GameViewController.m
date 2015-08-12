//
//  GameViewController.m
//  2048
//
//  Created by tarena on 15/7/9.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "GameViewController.h"
#import "BoxView.h"
#import "Game.h"


@interface GameViewController ()

@property (nonatomic, strong) NSMutableArray * boxArray;

@end

@implementation GameViewController
{
    CGSize boxSize;
    
    Game * game;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.boxArray = [NSMutableArray array];
    UILabel * label = (UILabel *)self.boxSites[0];
    boxSize = label.frame.size;
    
    
    //创建手势
    UISwipeGestureRecognizer *upSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGameView:)];
    upSwip.direction = UISwipeGestureRecognizerDirectionUp;
    [self.gameView addGestureRecognizer:upSwip];
    
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGameView:)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.gameView addGestureRecognizer:leftSwip];
    
    UISwipeGestureRecognizer *downSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGameView:)];
    downSwip.direction = UISwipeGestureRecognizerDirectionDown;
    [self.gameView addGestureRecognizer:downSwip];
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGameView:)];
    rightSwip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.gameView addGestureRecognizer:rightSwip];
    
    
    
    
    game = [[Game alloc] init];
    
    [self addBox];
    [self addBox];

    
}

- (CGRect)getBoxRect:(NSInteger)index
{
    UILabel * label = (UILabel *)self.boxSites[index];
    return label.frame;
}

- (void)addBox
{
    NSInteger index =0;
    BoxView * box = [game createBoxView:&index];
    if (box) {
        
        box.index = index;
        box.frame = [self getBoxRect:index];
    
        [self.boxArray addObject:box];
        [self.gameView addSubview: box];
//    [self displayAnimation:box];
        box.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:1
         animations:^{
             box.transform = CGAffineTransformMakeScale(1, 1);
         }completion:^(BOOL finish){
             
         }];
        
    }
}

- (void)boxMoveFrom:(NSInteger)from To:(NSInteger)to Type:(NSInteger)type
{

    for (BoxView * box  in self.boxArray) {
        NSLog(@"%@ -- %d",box.text, box.index);
    }
    
        if (type == 1) {
            BoxView *fromBox;
            for (BoxView * box in self.boxArray) {
                if (box.index == from) {
                    fromBox = box;
                    [box removeFromSuperview];
                }
                if (box.index == to) {
                    box.text = [NSString stringWithFormat:@"%d", [box.text intValue]*2];
                }
            }
            
            [self.boxArray removeObject:fromBox];
        }else{
            for (BoxView * box in self.boxArray) {
                if (box.index == from) {
                    CGRect rect = [self getBoxRect:to];
                    box.frame = rect;
                    box.index = to;
                }
            }
        }
//    }
    for (BoxView * box  in self.boxArray) {
        NSLog(@"%@ -- %d",box.text, box.index);
    }
}

- (void)displayAnimation:(UIView *)view
{
    view.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    [UIView animateWithDuration:1
//                     animations:^{
//                         view.transform = CGAffineTransformMakeScale(1.2, 1.2);
//                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:1
                                          animations:^{
                                              view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                          }completion:^(BOOL finish){
                                              [UIView animateWithDuration:1
                                                               animations:^{
                                                                   view.transform = CGAffineTransformMakeScale(1, 1);
                                                               }completion:^(BOOL finish){
                                                                   
                                                               }];
                                          }];
//                     }];

}

- (void)swipGameView:(UISwipeGestureRecognizer *)gr
{
    NSArray * array;
        switch (gr.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"Up");
            // 向上滑动，要检查[i][j],i小的是否有位置，保持j不变
                
            array = [game boxMove:MoveDirectionUp];
                for (NSDictionary * dic in array) {
                    NSLog(@"%@",dic);
                    
                    int from = [[dic valueForKey:@"from"] intValue];
                    int to = [[dic valueForKey:@"to"] intValue];
                    int type = [[dic valueForKey:@"type"] intValue];
                    [self boxMoveFrom:from To:to Type:type];
                }
        
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"left");
            
            array = [game boxMove:MoveDirectionLeft];
            for (NSDictionary * dic in array) {
                NSLog(@"%@",dic);
                
                int from = [[dic valueForKey:@"from"] intValue];
                int to = [[dic valueForKey:@"to"] intValue];
                int type = [[dic valueForKey:@"type"] intValue];
                [self boxMoveFrom:from To:to Type:type];
            }
            
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"Down");
            
            array = [game boxMove:MoveDirectionDown];
            for (NSDictionary * dic in array) {
                NSLog(@"%@",dic);
                
                int from = [[dic valueForKey:@"from"] intValue];
                int to = [[dic valueForKey:@"to"] intValue];
                int type = [[dic valueForKey:@"type"] intValue];
                [self boxMoveFrom:from To:to Type:type];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"Right");
            
            array = [game boxMove:MoveDirectionRight];
            for (NSDictionary * dic in array) {
                NSLog(@"%@",dic);
                
                int from = [[dic valueForKey:@"from"] intValue];
                int to = [[dic valueForKey:@"to"] intValue];
                int type = [[dic valueForKey:@"type"] intValue];
                [self boxMoveFrom:from To:to Type:type];
            }
            
            break;
        default:
            break;
    }
    
    [self addBox];
    [game lookBox];

}
@end
