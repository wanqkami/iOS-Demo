//
//  ViewController.m
//  数据持久化-sqlite3
//
//  Created by 万齐鹣 on 15/7/15.
//  Copyright (c) 2015年 万齐鹣. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

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
        //sqlite3
        sqlite3 *database;
        //打开数据库
        if(sqlite3_open([filePath UTF8String], &database)!=SQLITE_OK){//备注1
            //数据库打开失败，关闭数据库
            sqlite3_close(database);
            NSAssert(0,@"打开数据库失败");
        }
        
        char* errorMsg;
        NSString *createSQL = @"CREATE TABLE IF NOT EXISTS PERSON (name TEXT PRIMARY KEY,gender TEXT,age TEXT,education TEXT);";
        //创建表
        if(sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
            //创建表失败，关闭数据库
            sqlite3_close(database);
            NSAssert1(0, @"创建表失败：%s", errorMsg);
        }
        
        //查询表
        NSString *querySQL = @"SELECT name,gender,age,education FROM PERSON ORDER BY name";
        
        //执行查询，遍历查询结果
        sqlite3_stmt *statment;
        if(sqlite3_prepare_v2(database, [querySQL UTF8String], -1, &statment, nil) == SQLITE_OK){//备注3
            //查询成功，执行遍历操作
            while(sqlite3_step(statment) == SQLITE_ROW){//备注4
                const char* pName = (char*)sqlite3_column_text(statment, 0);//备注5
                if(pName!=NULL){
                    self.name.text = [[NSString alloc]initWithUTF8String:pName];
                }
                
                char* pGender = (char*)sqlite3_column_text(statment, 1);
                if(pGender!=NULL){
                    self.gender.text = [[NSString alloc]initWithUTF8String:pGender];
                }
                
                char* pAge = (char*)sqlite3_column_text(statment, 2);
                if(pAge!=NULL){
                    self.age.text = [[NSString alloc]initWithUTF8String:pAge];
                }
                
                char* pEducation = (char*)sqlite3_column_text(statment, 3);
                if(pEducation!=NULL){
                    self.education.text = [[NSString alloc]initWithUTF8String:pEducation];
                }
            }
            sqlite3_finalize(statment);//备注6
        }
        //关闭数据库
        sqlite3_close(database);//备注7
    }

    
   
    UIApplication *app = [UIApplication sharedApplication];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSLog(@"resign active");
    //sqlite3
    sqlite3 *database;
    //打开数据库
    if(sqlite3_open([[self dataFilePath] UTF8String], &database)!=SQLITE_OK){
        //数据库打开失败，关闭数据库
        sqlite3_close(database);
        NSAssert(0,@"打开数据库失败");
    }
    
    char* errorMsg;
    NSString *updateSQL = @"INSERT OR REPLACE INTO PERSON(name,gender,age,education) VALUES(?,?,?,?);";
    //执行插入或更新操作
    sqlite3_stmt *statment;
    
    if(sqlite3_prepare_v2(database, [updateSQL UTF8String], -1, &statment, nil) == SQLITE_OK){
        //绑定变量
        sqlite3_bind_text(statment, 1, [self.name.text UTF8String], -1, NULL);//备注8
        sqlite3_bind_text(statment, 2, [self.gender.text UTF8String], -1, NULL);
        sqlite3_bind_text(statment, 3, [self.age.text UTF8String], -1, NULL);
        sqlite3_bind_text(statment, 4, [self.education.text UTF8String], -1, NULL);
    }
    
    if(sqlite3_step(statment)!=SQLITE_DONE){
        NSAssert1(0, @"更新表失败：%s", errorMsg);
    }
    sqlite3_finalize(statment);
    
    //关闭数据库
    sqlite3_close(database);

}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}

@end
