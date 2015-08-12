//
//  ViewController.m
//  图片轮播
//
//  Created by 万齐鹣 on 15/6/29.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray * allImageViews;

@property (nonatomic) CGRect currectRect;
@property (nonatomic) CGRect preRect;
@property (nonatomic) CGRect nextRect;

@property (nonatomic) NSInteger currectIndex;

@property (nonatomic) UIPageControl * pageControl;

@end

@implementation ViewController

-(NSArray *)allImageNames
{
    if (!_allImageNames) {
        _allImageNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg", @"8.jpg", @"9.jpg"];
    }
    return _allImageNames;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.allImageViews = [NSMutableArray array];
    
    self.currectIndex = 0;
    NSInteger width = self.view.bounds.size.width * 2/3;
    NSInteger height = width * 3/4;
    
    
    NSInteger x = (self.view.bounds.size.width-width)/2;
    NSInteger y = (self.view.bounds.size.height - height)/2;
    self.currectRect = CGRectMake(x, y, width, height);
    self.preRect = CGRectMake(10, y+10, width*(height-20)/height, height-20);
    self.nextRect = CGRectMake(self.view.frame.size.width-10-width*(height-20)/height, y+10, width*(height-20)/height, height-20);
    
    for (int i=0; i<self.allImageNames.count; i++) {
        UIImage * image = [UIImage imageNamed:self.allImageNames[i]];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
        [self.allImageViews addObject:imageView];
        [self.view addSubview:imageView];
    }
    
    [self imageViewLayout:self.currectIndex];
    
    UISwipeGestureRecognizer * swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRightGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGR];
    
    UISwipeGestureRecognizer * swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGR];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.currectRect.origin.y+self.currectRect.size.height, self.view.frame.size.width, 20)];
    self.pageControl.numberOfPages = self.allImageViews.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview: self.pageControl];
}

-(void)swipe:(UISwipeGestureRecognizer *)gr
{
    if (gr.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"right");
        self.currectIndex++;
        self.currectIndex = self.currectIndex%self.allImageViews.count;
        [self imageViewLayout:self.currectIndex];
    }
    if (gr.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"left");
        self.currectIndex--;
        if (self.currectIndex<0) {
            self.currectIndex = self.currectIndex+self.allImageViews.count;
        }
        [self imageViewLayout:self.currectIndex];
    }
}

-(void)imageViewLayout:(NSInteger)index
{
    NSInteger preIndex, nextIndex;
    if (index == 0) {
        preIndex = self.allImageViews.count-1;
        nextIndex = index+1;
    }else if(index == self.allImageViews.count-1){
        preIndex = index-1;
        nextIndex = 0;
    }else{
        preIndex = index-1;
        nextIndex = index+1;
    }
    [self imageResetWithIndex:index andPreIndex:preIndex andNextIndex:nextIndex];
    
}

-(void)imageResetWithIndex:(NSInteger)index andPreIndex:(NSInteger)preIndex andNextIndex:(NSInteger)nextIndex
{
    [UIView animateWithDuration:0.2 animations:^{
        UIImageView * imageView;
        for (imageView in self.allImageViews) {
            imageView.hidden = YES;
        }
        
        imageView = self.allImageViews[preIndex];
        imageView.frame = self.preRect;
        imageView.hidden = NO;
        
        imageView = self.allImageViews[nextIndex];
        imageView.frame = self.nextRect;
        imageView.hidden = NO;
        
        imageView = self.allImageViews[index];
        imageView.frame = self.currectRect;
        imageView.hidden = NO;
        
        [self.view bringSubviewToFront:imageView];
        self.pageControl.currentPage = index;
    }];

}

@end
