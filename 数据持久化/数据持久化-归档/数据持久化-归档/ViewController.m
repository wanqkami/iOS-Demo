//
//  ViewController.m
//  数据持久化-归档
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *education;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        //属性列表
        
        NSData *data = [[NSMutableData alloc]initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        Person *person = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        
        self.name.text = person.name;
        self.gender.text = person.gender;
        self.age.text = person.age;
        self.education.text = person.education;
        
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
}


-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFileName];
}

-(void)applicationWillResignActive:(NSNotification *)nofication{
    
    //属性列表

    
    Person *person = [[Person alloc]init];
    person.name = self.name.text;
    person.gender = self.gender.text;
    person.age = self.age.text;
    person.education = self.education.text;
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:person forKey:kDataKey];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}

@end
