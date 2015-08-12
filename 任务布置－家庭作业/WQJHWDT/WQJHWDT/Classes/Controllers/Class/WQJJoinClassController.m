//
//  WQJJoinClassController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "WQJJoinClassController.h"
#import "WQJAlertUtil.h"
#import "WQJHudUtil.h"
#import "WQJClassDetailController.h"

@interface WQJJoinClassController ()
@property (weak, nonatomic) IBOutlet UITextField *classIdTextField;

@end

@implementation WQJJoinClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.classIdTextField.text = @"";
}

- (IBAction)jionClass:(id)sender {
    NSString * classID = self.classIdTextField.text;
    NSString * userID = [BmobUser getCurrentUser].objectId;
    
    [[WQJHudUtil shareUtil] showOnWindowOnView:self.view];
    
    // 检查班级是否存在
    BmobQuery * bquery = [BmobQuery queryWithClassName:@"wqjClass"];
    [bquery getObjectInBackgroundWithId:classID block:^(BmobObject *object, NSError *error) {
        if (object) {
            BmobQuery * query = [BmobQuery queryWithClassName:@"wqjClassUserRef"];
            [query whereKey:@"classId" equalTo:classID];
            [query whereKey:@"userId" equalTo:userID];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                // 存在就提示。。已经添加，
                if (array.count > 0) {
                    [[WQJHudUtil shareUtil] hide];
                    [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"您已经加入了该班级" rightBtnText:@"知道了"];
                } else {
                    // 添加数据，请求
                    BmobObject * obj = [[BmobObject alloc] initWithClassName:@"wqjClassUserRef"];
                    [obj setObject:classID forKey:@"classId"];
                    [obj setObject:userID forKey:@"userId"];
                    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        // 班级用户关系数据 完成
                        if (isSuccessful) {
                            // 跳转页面
                            BmobQuery * query = [BmobQuery queryWithClassName:@"wqjClass"];
                            [query getObjectInBackgroundWithId:classID block:^(BmobObject *object, NSError *error) {
                                
                                NSString * className = [object objectForKey:@"className"];
                                NSString * classDesc = [object objectForKey:@"classDesc"];
                                NSString * createByUserId = [object objectForKey:@"createByUserId"];
                                
                                WQJClass * wqjClass = [[WQJClass alloc] initWithID:classID name:className description:classDesc createByUserId:createByUserId];
                                
                                WQJClassDetailController * classDetailController = [[WQJClassDetailController alloc] init];
                                classDetailController.wqjClass = wqjClass;
                                
                                [[WQJHudUtil shareUtil] hide];
                                
                                [self.navigationController pushViewController:classDetailController animated:YES];
                            }];
                        } else {
                            [[WQJHudUtil shareUtil] hide];
                            NSLog(@"%@", error);
                        }
                    }];
                }
            }];
        } else {
            [[WQJHudUtil shareUtil] hide];
           
            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"输入的班级ID不存在" rightBtnText:@"知道了"];
            NSLog(@"%@", error);
        }
    }];
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
