//
//  ViewController.m
//  数据持久化-UserDefaults
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *server;
@property (weak, nonatomic) IBOutlet UITextField *port;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 初始化数据
    [self initData];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",path);
    
    // 订阅通知, 程序进入后台，数据保存
    UIApplication * app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
}

// 初始化数据
- (void)initData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.server.text = [defaults objectForKey:@"server"];
    self.port.text = [defaults objectForKey:@"port"];
}

- (void)applicationWillDidEnterBackground:(NSNotification *)notification
{
    NSLog(@"#applicationWillDidEnterBackground");
    [self saveData];
}

- (void)saveData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.server.text forKey:@"server"];
    [defaults setObject:self.port.text forKey:@"port"];
    [defaults synchronize];
}


@end
