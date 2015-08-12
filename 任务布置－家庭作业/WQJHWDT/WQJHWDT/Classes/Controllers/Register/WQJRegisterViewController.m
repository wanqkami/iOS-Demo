//
//  WQJRegisterViewController.m
//  WQJHWDT
//
//  Created by tarena on 15/7/31.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJRegisterViewController.h"
#import "WQJHudUtil.h"
#import "WQJAlertUtil.h"
#import "NSObject+WQJExpand.h"
#import "NSString+WQJExpand.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "WQJHomeworkController.h"

@interface WQJRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *userRePwdTextField;

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end

@implementation WQJRegisterViewController
- (IBAction)touchRegisterButton:(id)sender {
    NSString * email = self.emailTextField.text;
    NSString * name = self.userNameTextField.text;
    NSString * pwd = self.userPwdTextField.text;
    NSString * repwd = self.userRePwdTextField.text;
    
    // 数据检查
    // 1.数据是否为空
    if ([email isEmpty] || [name isEmpty] || [pwd isEmpty] || [repwd isEmpty]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"数据不能空" rightBtnText:@"知道了"];
        return;
    }
    // 2.检查邮箱是否合法
    if (![email isValidateEmail]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"邮箱不合法" rightBtnText:@"知道了"];
        return;
    }
    
    // 3.检查两次密码是否相同
    if (![pwd isEqual:repwd]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"两次密码输入不同" rightBtnText:@"知道了"];
        return;
    }
    
    [[WQJHudUtil shareUtil] showOnWindowOnView:self.view];
    
    // 4.可以检查 该邮箱是否已经注册过了
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"username" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            // 用户不存在
            // 执行注册的过程
            
            [self doRegiestWithEmail:email name:name password:pwd];
            
        } else {
            // 已经被注册了
            [[WQJHudUtil shareUtil] hide];
            [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"该邮箱已经注册过了" rightBtnText:@"知道了"];
            return;
        }
    }];
    
    
//    [[WQJHudUtil shareUtil] showOnWindowOnView:self.view];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden= NO;
    self.registerButton.layer.cornerRadius = 8.0f;
    self.registerButton.layer.masksToBounds = YES;
    
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
}

- (void)doRegiestWithEmail:(NSString *)email name:(NSString *)name password:(NSString *)pwd
{
    BmobUser * user = [[BmobUser alloc] init];
    [user setUsername:email];
    [user setPassword:pwd];
    [user setObject:name forKey:@"name"];
    
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        [[WQJHudUtil shareUtil] hide];
        if (isSuccessful){
            
//            [WQJAlertUtil showOneBtnAlertWithTitle:@"系统" content:@"注册成功" rightBtnText:@"好的"];
            [WQJAlertUtil showOneBtnAlertWithTitle:@"系统" content:@"注册成功，请确定登录！" rightBtnText:@"好的" block:^{
               //注册成功，模拟登录，跳转页面
                [BmobUser loginInbackgroundWithAccount:email andPassword:pwd block:^(BmobUser *user, NSError *error) {
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
            }];
        } else {
            
            NSLog(@"%@",error);
        }
    }];
    
}



@end
