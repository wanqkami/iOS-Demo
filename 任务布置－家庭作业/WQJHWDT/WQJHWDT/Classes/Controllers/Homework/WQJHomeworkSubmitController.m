//
//  WQJHomeworkSubmitController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/2.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJHomeworkSubmitController.h"
#import "NSObject+WQJExpand.h"
#import "WQJAlertUtil.h"
#import "WQJHudUtil.h"
#import "WQJChooseClassController.h"
#import "WQJChooseLibController.h"
#import "WQJHomeworkBase.h"

@interface WQJHomeworkSubmitController ()

@end

@implementation WQJHomeworkSubmitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (IBAction)submit:(id)sender {
    // 检查 数据
    if ([self.classID isEmpty] || [self.className isEmpty]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"班级没有选择，不可以发布"  rightBtnText:@"好的"];
        return;
    }
    if ([self.libID isEmpty] || [self.libTitle isEmpty]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"作业没有选择，不可以发布"  rightBtnText:@"好的"];
        return;
    }
    
    [[WQJHudUtil shareUtil] showSimpleOnView:self.view];
    
    // 数据无误，提交数据
    BmobObject * obj = [[BmobObject alloc] initWithClassName:@"wqjHomeworkTask"];
    [obj setObject:self.classID forKey:@"classId"];
    [obj setObject:self.libID forKey:@"libId"];
    NSString * userId = [BmobUser getCurrentUser].objectId;
    [obj setObject:userId forKey:@"userId"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //
        if (isSuccessful) {
            NSString * taskId = obj.objectId;
            
            //创建任务数据，
            BmobQuery * query = [BmobQuery queryWithClassName:@"wqjClassUserRef"];
            [query whereKey:@"classId" equalTo:self.classID];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
               //
                 BmobObjectsBatch * batch = [[BmobObjectsBatch alloc] init] ;
                for (BmobObject * obj in array) {
                    
                    
                    
                    [batch saveBmobObjectWithClassName:@"wqjTaskUserRef" parameters:@{@"taskId": taskId, @"userId": userId, @"libId": self.libID, @"state": @"none"}];
                }
                [batch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [[WQJHudUtil shareUtil] hide];
                        // 发布成功，清理数据
                        self.classID = @"";
                        self.className = @"";
                        self.libID = @"";
                        self.libTitle = @"";
                        [self.tableView reloadData];
                        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"发布成功" rightBtnText:@"知道了"];
                        
                    } else {
                        [[WQJHudUtil shareUtil] hide];
                        NSLog(@"batch error %@",[error description]);
                    }
                    
                }];
                
            }];
            
        } else {
            [[WQJHudUtil shareUtil] hide];
            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"发布失败" rightBtnText:@"知道了"];
            NSLog(@"%@", error);
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitcell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"submitcell"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"班级名称";
//        cell.detailTextLabel.text = @"12312";
        cell.detailTextLabel.text = self.className;
    }
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"作业名称";
        cell.detailTextLabel.text = self.libTitle;
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 选择班级
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
        WQJChooseClassController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"WQJChooseClassController"];
        viewController.setClassBlock = ^(NSString * classID, NSString * className){
            self.classID = classID;
            self.className = className;
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (indexPath.row == 1) {
        // 选择作业
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
        WQJChooseLibController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"WQJChooseLibController"];
        viewController.setlibBlock = ^(NSString * libID, NSString * libTitle){
            self.libID = libID;
            self.libTitle = libTitle;
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
