//
//  LoginViewController.m
//  MBProject
//
//  Created by yindongbo on 2017/5/25.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"1");
}
- (IBAction)loginAction:(UIButton *)sender {
    
    [kMBNotificationCetner postNotificationName:kAppDelegate_PushToMainVC object:nil];
    [kMBUserDefaults setValue:@"1" forKey:kUserName];
    NSLog(@"登录");
}

@end
