//
//  ViewController.m
//  数据持久化-fmdb
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

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
	
    NSString * database_path = [self dataFilePath];
    
    FMDatabase * db = [FMDatabase databaseWithPath:database_path];
    
    if ([db open]) {
        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS PERSON (name TEXT PRIMARY KEY,gender TEXT,age TEXT,education TEXT);"];
        if(res){
            NSLog(@"建表成功");
            
            
            NSString * sql = [NSString stringWithFormat:
                              @"SELECT name,gender,age,education FROM PERSON ORDER BY name"];
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                NSString * name = [rs stringForColumn:@"name"];
                if (name) {
                    self.name.text = name;
                }
                NSString * gender = [rs stringForColumn:@"gender"];
                if (gender) {
                    self.gender.text = gender;
                }
                NSString * age = [rs stringForColumn:@"age"];
                if (age) {
                    self.age.text = age;
                }
                NSString * education = [rs stringForColumn:@"education"];
                if (education) {
                    self.education.text = education;
                }
                
            }
            
        }else{
            NSLog(@"建表失败:%@", [db lastError]);
        }
        [db close];
    }
    
    
    UIApplication * app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
}

-(void)applicationWillResignActive:(NSNotification *)notification
{
    NSLog(@"resign active");
    
    NSString * database_path = [self dataFilePath];
    
    FMDatabase * db = [FMDatabase databaseWithPath:database_path];
    
    if ([db open]) {
        NSString * name = self.name.text;
        NSString * gender = self.gender.text;
        NSString * age = self.age.text;
        NSString * education = self.education.text;
     
        BOOL res = [db executeUpdate:@"INSERT OR REPLACE INTO PERSON(name,gender,age,education) VALUES(?,?,?,?);", name,gender,age,education];
        
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        [db close];
    }
    
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}

@end
