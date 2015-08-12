//
//  WQJChooseClassController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/2.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJChooseClassController.h"
#import "WQJDateUtil.h"
#import "WQJHudUtil.h"

@interface WQJChooseClassController ()

@property (nonatomic, strong) UITableViewCell * selectedCell;
@property (nonatomic, strong) NSArray * classArray;

@end

@implementation WQJChooseClassController

-(NSArray *)classArray
{
    if (!_classArray) {
        _classArray = [NSArray array];
    }
    return _classArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self reloadData];
}


- (void)reloadData
{
    [[WQJHudUtil shareUtil] showSimpleOnView:self.view];
    NSString * userID = [BmobUser getCurrentUser].objectId;
    BmobQuery * query = [BmobQuery queryWithClassName:@"wqjClassUserRef"];
    [query whereKey:@"userId" equalTo:userID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //
        
        if (array.count>0) {
            NSMutableArray * classIdArray = [NSMutableArray array];
            for (BmobObject * obj in array) {
                [classIdArray addObject:[obj objectForKey:@"classId"]];
            }
            BmobQuery * classQuery = [BmobQuery queryWithClassName:@"wqjClass"];
            [classQuery whereKey:@"objectId" containedIn:classIdArray];
            [classQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count>0) {
                    self.classArray = array;
                    [[WQJHudUtil shareUtil] hide];
                    [self.tableView reloadData];
                } else {
                    NSLog(@"%@", error);
                    [[WQJHudUtil shareUtil] hide];
                }
                
            }];
            
        } else {
            NSLog(@"%@", error);
            [[WQJHudUtil shareUtil] hide];
        }
        
        
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseClassCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"chooseClassCell"];
    }
    
    BmobObject * obj = self.classArray[indexPath.row];
    
    cell.textLabel.text = [obj objectForKey:@"className"];
    NSString * createDate = [WQJDateUtil toStringWithDate:[obj createdAt]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"创建时间 %@", createDate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedCell) {
        [self.selectedCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [self.selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    BmobObject * obj = self.classArray[indexPath.row];
    NSString * classID = obj.objectId;
    NSString * className = [obj objectForKey:@"className"];
    self.setClassBlock(classID, className);
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
