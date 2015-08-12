//
//  WQJClassDetailController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJClassDetailController.h"
#import "WQJHudUtil.h"
#import "WQJAlertUtil.h"

@interface WQJClassDetailController ()


@end

@implementation WQJClassDetailController

-(NSArray *)studentArray
{
    if (!_studentArray) {
        _studentArray = [NSArray array];
    }
    return _studentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级信息";
    
    [[WQJHudUtil shareUtil] showOnWindowOnView:self.view];
    // 查询学员纪录
    // 通过班级查询学员
    BmobQuery * refQuery = [BmobQuery queryWithClassName:@"wqjClassUserRef"];
    [refQuery whereKey:@"classId" equalTo:self.wqjClass.classID];
    [refQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count>0) {
            NSMutableArray * userIdArray = [NSMutableArray array];
            for (BmobObject * obj in array) {
                NSString * userID = [obj objectForKey:@"userId"];
                [userIdArray addObject:userID];
            }
            BmobQuery *query = [BmobUser query];
            [query whereKey:@"objectId" containedIn:userIdArray];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                self.studentArray = array;
                
                [[WQJHudUtil shareUtil] hide];
                [self.tableView reloadData];
            }];

        } else {
            [[WQJHudUtil shareUtil] hide];
            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"加载数据失败" rightBtnText:@"好的"];
            
        }
        
    }];
    
//    NSString * bsql = [NSString stringWithFormat:@"select u.objectId, u.name, u.name from _User u, wqjClassRef r where u.objectId = r.classId and r.classId = '%@' order by r.createdAt", self.wqjClass.classID];
//    NSString * bsql = [NSString stringWithFormat:@"select * from _User"];
//    
//    BmobQuery * query = [[BmobQuery alloc] init];
//    [query queryInBackgroundWithBQL:bsql block:^(BQLQueryResult *result, NSError *error) {
//        if (result.resultsAry.count >0 ) {
//            for (int i=0; i<result.resultsAry.count; i++) {
//                BmobObject * obj = result.resultsAry[i];
//                [self.studentArray addObject:obj];
//            }
//            [[WQJHudUtil shareUtil] hide];
//            [self.tableView reloadData];
//        } else {
//            NSLog(@"%@", error);
//            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"加载数据失败" rightBtnText:@"好的"];
//            [[WQJHudUtil shareUtil] hide];
//            
//        }
//    }];
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:239/255.0 alpha:1];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return self.studentArray.count;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"classDetailCell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"classDestailCell1"];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"班级编号";//[NSString stringWithFormat:@"班级编号 %@", self.wqjClass.classID
            cell.detailTextLabel.text = self.wqjClass.classID;
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"班级名称";//[NSString stringWithFormat:@"班级名称 %@", self.wqjClass.className];
            cell.detailTextLabel.text = self.wqjClass.className;
        }
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"classDetailCell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classDestailCell2"];
        }
        BmobObject * obj = self.studentArray[indexPath.row];
        cell.textLabel.text = [obj objectForKey:@"name"];
        
    } else if (indexPath.section == 2) {

        cell = [tableView dequeueReusableCellWithIdentifier:@"classDetailCell3"];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"classDetailCell3" forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classDetailCell3"];
        }
        
        cell.textLabel.text = self.wqjClass.classDesc;
        
        cell.textLabel.numberOfLines = 0;
       
    }
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"班级信息";
    } else if (section == 1) {
        return @"学员";
    } else if (section == 2) {
        return @"班级描述";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 160.0f;
    } else {
        return 45.0f;
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
