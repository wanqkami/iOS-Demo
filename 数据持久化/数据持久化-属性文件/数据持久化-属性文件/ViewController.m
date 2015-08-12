//
//  ViewController.m
//  数据持久化-属性文件
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *edu;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIApplication * app = [UIApplication sharedApplication];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
    [self initData];
    
}

- (void)initData
{
    NSString * filePath = [self dataFilePath];
    NSLog(@"filePath = %@", filePath);
    
    // 从文件中读取数据，首先判断文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray * array = [[NSArray alloc] initWithContentsOfFile:filePath];
        self.name.text = [array objectAtIndex:0];
        self.sex.text = [array objectAtIndex:1];
        self.age.text = [array objectAtIndex:2];
        self.edu.text = [array objectAtIndex:3];
    }
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [array addObject:self.name.text];
    [array addObject:self.sex.text];
    [array addObject:self.age.text];
    [array addObject:self.edu.text];
    
    [array writeToFile:[self dataFilePath] atomically:YES];
}


// 获得文件路径
- (NSString *)dataFilePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFileName];
}
@end
