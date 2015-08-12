//
//  WQJHomeworkReportController.m
//  WQJHWDT
//
//  Created by tarena on 15/8/4.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//


#import <BmobSDK/Bmob.h>
#import "WQJHomeworkReportController.h"
#import "WQJHudUtil.h"
#import "WQJDateUtil.h"

@interface WQJHomeworkReportController ()

@property (nonatomic, strong) NSArray * taskUserRefArray;
@property (nonatomic, strong) NSArray * libArray;
@property (nonatomic, strong) NSArray * taskArray;

@end

@implementation WQJHomeworkReportController

-(NSArray *)taskUserRefArray
{
    if (!_taskUserRefArray) {
        _taskUserRefArray = [NSArray array];
    }
    
    return _taskUserRefArray;
}

-(NSArray *)libArray
{
    if (!_libArray) {
        _libArray = [NSArray array];
    }
    return _libArray;
}

-(NSArray *)taskArray
{
    if (!_taskArray) {
        _taskArray = [NSArray array];
    }
    return _taskArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

// 读取数据
- (void)loadData
{
    [[WQJHudUtil shareUtil] showSimpleOnView:self.view];
    BmobQuery * taskQuery = [BmobQuery queryWithClassName:@"wqjHomeworkTask"];
    NSString * userID = [BmobUser getCurrentUser].objectId;
    [taskQuery whereKey:@"userId" equalTo:userID];
    [taskQuery orderByDescending:@"createdAt"];
    [taskQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //taskArray
        if (array.count > 0) {
//            [[WQJHudUtil shareUtil] hide];
            self.taskArray = array;
            NSMutableArray * taskIdArray = [NSMutableArray array];
            NSMutableArray * libIdArray = [NSMutableArray array];
            
            for (BmobObject * obj in array) {
                NSString * taskID = obj.objectId;
                [taskIdArray addObject:taskID];
                
                NSString * libID = [obj objectForKey:@"libId"];
                [libIdArray addObject:libID];
            }
            
            // 查找所有的用户任务关系
            BmobQuery * taskUserRefQuery = [BmobQuery queryWithClassName:@"wqjTaskUserRef"];
            [taskUserRefQuery whereKey:@"taskId" containedIn:taskIdArray];
            [taskUserRefQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//                self.taskUserRefArray = array;
                
                if (array.count > 0) {
                    self.taskUserRefArray = array;
                    
                    BmobQuery * libQuery = [BmobQuery queryWithClassName:@"wqjHomeworkLib"];
                    [libQuery whereKey:@"objectId" containedIn:libIdArray];
                    [libQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        self.libArray = array;
                        [[WQJHudUtil shareUtil]hide];
                        
                        
                        [self.tableView reloadData];
                        
                    }];
                    
                } else {
                    [[WQJHudUtil shareUtil] hide];
                }

            }];
        } else {
            [[WQJHudUtil shareUtil] hide];
        }
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.taskUserRefArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskReportCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"taskReportCell"];
    }
    
    // Configure the cell...
    BmobObject * taskObj = self.taskArray[indexPath.row];
    NSString * libID = [taskObj objectForKey:@"libId"];
    NSString * taskID= taskObj.objectId;
    BmobObject * libObj = [[BmobObject alloc] init];
    for (BmobObject * libObjTemp in self.libArray) {
        NSString * libIdTemp = libObjTemp.objectId;
        if ([libIdTemp isEqual: libID]) {
            libObj = libObjTemp;
            break;
        }
    }
    
    // 计算 完成 与 未完成的数量
    int undoneNum = 0;
    int doneNum = 0;
    for (int i=0; i<self.taskUserRefArray.count; i++) {
        BmobObject * tuRefObj = self.taskUserRefArray[i];
        NSString * taskIdTemp = [tuRefObj objectForKey:@"taskId"];
        if ([taskID isEqual:taskIdTemp]) {
            NSString * state = [tuRefObj objectForKey:@"state"];
            if ([@"none" isEqual:state]) {
                undoneNum ++;
            } else {
                doneNum ++;
            }
        }
    }
    
    NSString * libTitle = [libObj objectForKey:@"title"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, 完成：%d 未完成：%d", libTitle, undoneNum, doneNum];
    
    NSDate * createDate = [taskObj createdAt];
    cell.detailTextLabel.text = [WQJDateUtil toStringWithDate:createDate];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
