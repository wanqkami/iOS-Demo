//
//  WQJMyClassController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJMyClassController.h"
#import "WQJHudUtil.h"
#import "WQJAlertUtil.h"
#import "WQJDateUtil.h"
#import "WQJClassDetailController.h"

@interface WQJMyClassController ()

@property (nonatomic, strong) NSMutableArray * classArray;

@end

@implementation WQJMyClassController

- (NSMutableArray *)classArray
{
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadData];
}

- (void)loadData
{
    
    [[WQJHudUtil shareUtil] showOnWindowOnView:self.view];
    NSString * usreID = [BmobUser getCurrentUser].objectId;
    
    BmobQuery * classUserRefQuery = [BmobQuery queryWithClassName:@"wqjClassUserRef"];
    [classUserRefQuery whereKey:@"userId" equalTo:usreID];
    [classUserRefQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray * classIdArray = [NSMutableArray array];
        for (BmobObject * obj in array) {
            NSString * classId = [obj objectForKey:@"classId"];
            [classIdArray addObject:classId];
        }
       //查询所有的班级
        BmobQuery * classQuery = [BmobQuery queryWithClassName:@"wqjClass"];
        [classQuery whereKey:@"objectId" containedIn:classIdArray];
        [classQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                for (BmobObject * obj in array) {
                    [self.classArray addObject:obj];
                }
                [self.tableView reloadData];
                [[WQJHudUtil shareUtil] hide];
            } else {
                [[WQJHudUtil shareUtil] hide];
                [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"加载数据异常" rightBtnText:@"好吧"];
                NSLog(@"%@",error);
            }
        }];
        
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    BmobObject * obj = self.classArray[indexPath.row];
    cell.textLabel.text = [obj objectForKey:@"className"];
    
    NSString * createDate = [WQJDateUtil toStringWithDate:[obj createdAt]];
    
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"创建日期：%@", createDate];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"班级列表";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BmobObject * obj = self.classArray[indexPath.row];
    NSString * classID = obj.objectId;
    NSString * className = [obj objectForKey:@"className"];
    NSString * classDesc = [obj objectForKey:@"classDescription"];
    NSString * userID = [BmobUser getCurrentUser].objectId;
    WQJClass * wqjClass = [[WQJClass alloc] initWithID:classID name:className description:classDesc createByUserId:userID];
    
    WQJClassDetailController * detailController = [[WQJClassDetailController alloc] init];
    detailController.wqjClass = wqjClass;
    
    [self.navigationController pushViewController:detailController animated:YES];
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
