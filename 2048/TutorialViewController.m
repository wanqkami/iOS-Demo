//
//  TutorialViewController.m
//  2048
//
//  Created by tarena on 15/7/9.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import "TutorialViewController.h"
#import "GameViewController.h"

@interface TutorialViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIButton * jumpButton;

@end

@implementation TutorialViewController

// 教程滚动页面初始化
- (UIScrollView *)createScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    for (int i=0; i<self.allTutorialNames.count; i++) {
        UIImage * image = [UIImage imageNamed:self.allTutorialNames[i]];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        int x = i*self.view.bounds.size.width;
        int y = 0;
        int width = self.view.bounds.size.width;
        int height = self.view.bounds.size.height;
        imageView.frame = CGRectMake(x, y, width, height);
        [scrollView addSubview:imageView];
    }
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
//    NSInteger wid = self.view.frame.size.width*self.allTutorialNames.count;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.allTutorialNames.count, 0);
    
    scrollView.delegate = self;
    
    self.jumpButton = [self createButton];
    [scrollView addSubview:self.jumpButton];
    
    return scrollView;
}

// 分页控制初始化
- (UIPageControl *)createPageControl
{
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.allTutorialNames.count;
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.userInteractionEnabled = NO;
    
    int width = self.view.bounds.size.width;
    int height = 40;
    int x = 0;
    int y = self.view.bounds.size.height-height;
    
    pageControl.frame = CGRectMake(x, y, width, height);
    return pageControl;
}

// 跳转按钮初始化
- (UIButton *)createButton
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1];
    button.layer.cornerRadius = 8;
    button.layer.masksToBounds = YES;
    [button setTitle:@"开始游戏" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    int widht = 160;
    int height = 60;
    int x = self.view.bounds.size.width*2+(self.view.bounds.size.width-widht)/2;
    int y = self.view.bounds.size.height - height - 100;
    button.frame = CGRectMake(x, y, widht, height);
    
    [button addTarget:self action:@selector(tutorialFinished) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)tutorialFinished
{
    // 将完成吸收教程的状态存储
    
    // 跳转界面
    GameViewController * gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
//    gameViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:gameViewController animated:YES completion:nil];
    
}

// 教程名称数组懒加载
- (NSArray *)allTutorialNames
{
    if (!_allTutorialNames) {
        _allTutorialNames = @[@"tutorial_1",@"tutorial_2",@"tutorial_3"];
    }
    return _allTutorialNames;
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
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [self createScrollView];
    
    self.pageControl = [self createPageControl];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//mark UIScroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/self.view.bounds.size.width;
    self.pageControl.currentPage = index;
}

@end
