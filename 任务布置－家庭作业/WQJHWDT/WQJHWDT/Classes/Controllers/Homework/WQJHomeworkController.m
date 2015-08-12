//
//  WQJHomeworkController.m
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJHomeworkController.h"
#import "WQJHudUtil.h"
#import "WQJDateUtil.h"
#import "WQJHomeworkReadOnlyController.h"

@interface WQJHomeworkController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *homeworkStateSegment;


@property (nonatomic, strong) NSArray * homeworkLibArray;

@property (weak, nonatomic) IBOutlet UITableView *homeworkTableView;


@end

@implementation WQJHomeworkController

- (NSMutableArray *)unDoneArray
{
    if (!_unDoneArray) {
        _unDoneArray = [NSMutableArray array];
    }
    return _unDoneArray;
}

- (NSMutableArray *)doneArray
{
    if (!_doneArray) {
        _doneArray = [NSMutableArray array];
    }
    return _doneArray;
}

-(NSArray *)homeworkLibArray
{
    if (!_homeworkLibArray) {
        _homeworkLibArray = [NSArray array];
    }
    return  _homeworkLibArray;
}

- (IBAction)stateChange:(UISegmentedControl *)sender {
    
    NSLog(@"%d", self.homeworkStateSegment.selectedSegmentIndex);
    [self loadData];
    
}

- (void)loadData
{
    [self.unDoneArray removeAllObjects];
    [self.doneArray removeAllObjects];
    [[WQJHudUtil shareUtil] showSimpleOnView:self.view];
    NSString * userID = [BmobUser getCurrentUser].objectId;
    BmobQuery * query = [BmobQuery queryWithClassName:@"wqjTaskUserRef"];
    [query whereKey:@"userId" equalTo:userID];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            [[WQJHudUtil shareUtil] hide];
        }
        for (BmobObject * obj in array) {
            NSString * state = [obj objectForKey:@"state"];
            if ([state isEqualToString:@"none"]) {
                [self.unDoneArray addObject:obj];
            } else {
                [self.doneArray addObject:obj];
            }
        }

        
        
        NSMutableArray * libArray  = [NSMutableArray array];
        for (BmobObject * obj in array) {
            NSString * libID = [obj objectForKey:@"libId"];
            [libArray addObject:libID];
        }
        
        BmobQuery * libQuery = [BmobQuery queryWithClassName:@"wqjHomeworkLib"];
        [libQuery whereKey:@"objectId" containedIn:libArray];
        [libQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            //
            [[WQJHudUtil shareUtil] hide];
            self.homeworkLibArray = array;
            [self.homeworkTableView reloadData];
        }];
        
        
        
    }];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self.navigationController.tabBarItem setImage:[UIImage imageNamed:@"todo"]];
        [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"todo_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
        
        
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        //设置背景色
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:176/255.0 blue:227/255.0 alpha:1]];
        //设置有导航条时,状态栏的文字颜色
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.homeworkStateSegment.selectedSegmentIndex == 0) {
        return self.unDoneArray.count;
    } else {
        return self.doneArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    BmobObject * obj;
    if (self.homeworkStateSegment.selectedSegmentIndex == 0) {
        obj = self.unDoneArray[indexPath.row];
    } else {
        obj = self.doneArray[indexPath.row];
    }
    
    NSString * libID = [obj objectForKey:@"libId"];
    
    for (BmobObject * tempObj in self.homeworkLibArray) {
        NSString * tempLibID = [tempObj objectId];
        if ([tempLibID isEqual:libID]) {
            cell.textLabel.text = [tempObj objectForKey:@"title"];
        }
    }
    
    NSString * submitDate = [WQJDateUtil toStringWithDate:[obj createdAt]];
    
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"发布日期：%@", submitDate];
    
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BmobObject * obj = [[BmobObject alloc] init];
    if (self.homeworkStateSegment.selectedSegmentIndex == 0) {
        obj = self.unDoneArray[indexPath.row];
    }
    if (self.homeworkStateSegment.selectedSegmentIndex == 1) {
        obj = self.doneArray[indexPath.row];
    }
    
    NSString * libID = [obj objectForKey:@"libId"];
    
    BmobObject * libObj = [[BmobObject alloc] init];
    for (BmobObject * libObjTemp in self.homeworkLibArray) {
        NSString * libIdTemp = libObjTemp.objectId;
        if ([libID isEqual:libIdTemp]) {
            libObj = libObjTemp;
        }
    }
    
    WQJHomeworkReadOnlyController * libController = [[WQJHomeworkReadOnlyController alloc] init];
    
    NSString * libTitle = [libObj objectForKey:@"title"];
    NSString * libObjectID = libObj.objectId;
    NSString * libContent = [libObj objectForKey:@"content"];
    NSString * userID = [libObj objectForKey:@"userId"];
    
    libController.libID = libObjectID;
    libController.libTitle = libTitle;
    libController.libContent = libContent;
    libController.userID = userID;
    libController.done = YES;
    libController.taskUserRefID = obj.objectId;
    
    [self.navigationController pushViewController:libController animated:YES];
    
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
