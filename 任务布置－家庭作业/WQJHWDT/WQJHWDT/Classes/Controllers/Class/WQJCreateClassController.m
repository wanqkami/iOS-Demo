//
//  WQJCreateClassController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "WQJCreateClassController.h"
#import "NSObject+WQJExpand.h"
#import "NSString+WQJExpand.h"
#import "WQJAlertUtil.h"
#import "WQJHudUtil.h"
#import "WQJClassDetailController.h"

@interface WQJCreateClassController ()
@property (weak, nonatomic) IBOutlet UITextField *classNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *classDescTextVIew;

@end

@implementation WQJCreateClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.classNameTextField.text = @"";
    self.classDescTextVIew.text = @"";
}

- (IBAction)submitClassData:(id)sender {
    NSString * className = self.classNameTextField.text;
    NSString * classDesc = self.classDescTextVIew.text;
    if ([className isEmpty]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"班级名称不能为空" rightBtnText:@"知道了"];
        return;
    } else {
        [[WQJHudUtil shareUtil]showOnWindowOnView:self.view];
        [self createClassWithName:className description:classDesc];
        
    }
    
}

- (void)createClassWithName:(NSString *)name description:(NSString *)desc
{
    //当前用户的id
    NSString * userId = [BmobUser getCurrentUser].objectId;
    BmobObject * obj = [[BmobObject alloc] initWithClassName:@"wqjClass"];
    [obj setObject:name forKey:@"className"];
    [obj setObject:desc forKey:@"classDescription"];
    [obj setObject:userId forKey:@"createByUserId"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        
        if (isSuccessful) {
            BmobObject * classUserRef = [[BmobObject alloc] initWithClassName:@"wqjClassUserRef"];
            [classUserRef setObject:obj.objectId forKey:@"classId"];
            [classUserRef setObject:userId forKey:@"userId"];
            [classUserRef saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [[WQJHudUtil shareUtil] hide];
                if (isSuccessful) {
                    WQJClass * wqjClass = [[WQJClass alloc] init];
                    wqjClass.className = name;
                    wqjClass.classDesc = desc;
                    wqjClass.createByUserId = userId;
                    wqjClass.classID = obj.objectId;
                    
                    WQJClassDetailController * detailClassController = [[WQJClassDetailController alloc] init];
                    
                    detailClassController.wqjClass = wqjClass;
                    
                    [self.navigationController pushViewController:detailClassController animated:YES];
                } else {
                    NSLog(@"%@", error);
                }
                
            }];
        } else {
            NSLog(@"%@", error);
        }
        
        
        
        
    }];
    
}


@end
