//
//  WQJLoginViewController.m
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJLoginViewController.h"
#import "WQJHomeworkController.h"
#import "NSObject+WQJExpand.h"
#import "NSString+WQJExpand.h"
#import "WQJHudUtil.h"
#import "WQJAlertUtil.h"

@interface WQJLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation WQJLoginViewController
- (IBAction)touchLoginButton:(id)sender {
    NSString * username = self.emailTextField.text;
    NSString * userpwd = self.pwdTextField.text;
    
    // 检查数据
    if ([username isEmpty] || [userpwd isEmpty]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"数据不能为空" rightBtnText:@"知道了"];
        return;
    }
    
    if (![username isValidateEmail]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"账号不符合邮箱规范，重新输入" rightBtnText:@"知道了"];
        return;
    }
    
    [BmobUser loginInbackgroundWithAccount:username andPassword:userpwd block:^(BmobUser *user, NSError *error) {
        if (user) {
            // 登录成功，跳转
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
            WQJHomeworkController * homeController = [storyBoard instantiateViewControllerWithIdentifier:@"main"];
            
            [self.view.window setRootViewController:homeController];
            
        } else {
            // 登录失败，账号或密码错误
            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"账号或密码不正确，登录失败" rightBtnText:@"知道了"];
        }
    }];
    
    
    
    // 检查用户是否存在，账号密码是否正确
//    BmobQuery *query = [BmobUser query];
//    [query whereKey:@"username" equalTo:username];
//    [query whereKey:@"password" equalTo:userpwd];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (array.count>0) {
//            [self doLoginWithName:username password:userpwd];
//        } else {
//            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"账号或密码不正确，登录失败" rightBtnText:@"知道了"];
//        }
//    }];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.logoLabel.layer.cornerRadius = 6.0f;
    self.logoLabel.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius = 8.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    self.registerButton.layer.cornerRadius = 6.0f;
    self.registerButton.layer.masksToBounds = YES;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置背景色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255/255.0 green:54/255.0 blue:122/255.0 alpha:1]];
    //设置有导航条时,状态栏的文字颜色
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchMainButton:(id)sender {
    
//    WQJMainViewController * mainVC = [[WQJMainViewController alloc] init];
//    [self presentViewController:mainVC animated:YES completion:nil];
    
    
    UIStoryboard *story = [UIStoryboard  storyboardWithName:@"Homework"   bundle:nil];
    
    //3.从storyboard取得newViewCtroller对象，通过Identifier区分
    WQJHomeworkController *nvc = [story instantiateViewControllerWithIdentifier:@"main"];

    [self presentViewController:nvc animated:YES completion:nil];
    
}


//-(void)doLoginWithName:(NSString *)name password:(NSString *)pwd
//{
//}

@end
