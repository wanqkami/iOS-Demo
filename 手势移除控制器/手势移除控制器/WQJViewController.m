//
//  WQJViewController.m
//  手势移除控制器
//
//  Created by tarena on 15/8/12.
//  Copyright (c) 2015年 com.wanq. All rights reserved.
//

#import "WQJViewController.h"

@interface WQJViewController ()

@property (nonatomic, strong) NSMutableArray * images;
@property (nonatomic, strong) UIImageView * lastImageView;
@property (nonatomic, strong) UIView * cover;

@end

@implementation WQJViewController

-(UIImageView *)lastImageView
{
    if (!_lastImageView) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIImageView * lastImageView = [[UIImageView alloc] init];
        lastImageView.frame = window.bounds;
        self.lastImageView = lastImageView;
    }
    return _lastImageView;
}

- (UIView *)cover
{
    if (!_cover) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIView * cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor blackColor];
        cover.frame = window.bounds;
        cover.alpha = 0.5;
        self.cover = cover;
    }
    return _cover;
}

-(NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加拖动手势
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    
    [self.view addGestureRecognizer:recognizer];
}

- (void)dragging:(UIPanGestureRecognizer *)recognizer
{
    // 如果只有一个字控制器，不可以拖动
    if (self.viewControllers.count <=1)
        return;
    
    // 在x方向的拖动的距离
    CGFloat tx = [recognizer translationInView:self.view].x;
    // 不支持向右拖动
    if (tx < 0) return;
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat x= self.view.frame.origin.x;
        if (x>=self.view.frame.size.width*0.5) {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                [self.lastImageView removeFromSuperview];
                [self.cover removeFromSuperview];
                self.view.transform = CGAffineTransformIdentity;
                [self.images removeLastObject];
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            }];
        }
        
    } else {
        // 移动view
        self.view.transform = CGAffineTransformMakeTranslation(tx, 0);
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        self.lastImageView.image = self.images[self.images.count-2];
        [window insertSubview:self.lastImageView atIndex:0];
        [window insertSubview:self.cover aboveSubview:self.lastImageView];
    }
    
}


- (void)createScreenShot
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    [self.images addObject:image];    
    //    [UIImagePNGRepresentation(image) writeToFile:[NSString stringWithFormat:@"/Users/wanq/Desktop/%zd.png", self.viewControllers.count] atomically:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.images.count > 0) return;
    
    [self createScreenShot];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    [self createScreenShot];
    
}

@end
