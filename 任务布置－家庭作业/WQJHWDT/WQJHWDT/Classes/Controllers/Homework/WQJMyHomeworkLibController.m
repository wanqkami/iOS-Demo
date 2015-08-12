//
//  WQJMyHomeworkLibController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "WQJMyHomeworkLibController.h"
#import "WQJHudUtil.h"
#import "WQJAlertUtil.h"
#import "WQJDateUtil.h"
#import "WQJHomeworkReadOnlyController.h"

@interface WQJMyHomeworkLibController ()

@property (nonatomic, strong) NSArray * allLibArray;

@end

@implementation WQJMyHomeworkLibController

-(NSArray *)allLibArray
{
    if (!_allLibArray) {
        _allLibArray = [NSArray array];
    }
    return _allLibArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (IBAction)addHomeworkLib:(id)sender {
    NSLog(@"add lib");
}


-(void) loadData
{
    [[WQJHudUtil shareUtil] showOnWindowOnView:self.view];
    BmobQuery * query = [BmobQuery queryWithClassName:@"wqjHomeworkLib"];
    NSString * userID = [BmobUser getCurrentUser].objectId;
    [query whereKey:@"userId" equalTo:userID];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
//            for (BmobObject * obj in array) {
//                [self.allLibArray addObject:obj];
//            }
            self.allLibArray = array;
            [[WQJHudUtil shareUtil] hide];
            [self.tableView reloadData];
        } else {
            [[WQJHudUtil shareUtil] hide];
            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"请求出错" rightBtnText:@"知道了"];
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allLibArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"libcell" ];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"libcell"];
    }
    
    BmobObject * obj = self.allLibArray[indexPath.row];
    cell.textLabel.text = [obj objectForKey:@"title"];
    
    NSString * createDate = [WQJDateUtil toStringWithDate:[obj createdAt]];
    
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"创建日期：%@", createDate];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"作业标题";
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BmobObject * lib = self.allLibArray[indexPath.row];
    
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
    
//    WQJHomeworkReadOnlyController * homeworkReadOnlyController = [storyboard instantiateViewControllerWithIdentifier:@"homeworkReadOnly"];
    
    WQJHomeworkReadOnlyController * homeworkReadOnlyController = [[WQJHomeworkReadOnlyController alloc] init];
    
    homeworkReadOnlyController.libID = lib.objectId;
    homeworkReadOnlyController.libTitle = [lib objectForKey:@"title"];
    homeworkReadOnlyController.libContent = [lib objectForKey:@"content"];
    homeworkReadOnlyController.userID = [lib objectForKey:@"userId"];
    
    [self.navigationController pushViewController:homeworkReadOnlyController animated:YES];
    
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
