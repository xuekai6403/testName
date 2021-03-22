//
//  EFLoginViewController.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFLoginViewController.h"
#import "EFRegisterViewController.h"
@interface EFLoginViewController ()


@end

@implementation EFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextField *accountTF = [[UITextField alloc] init];
    accountTF.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    accountTF.textColor = [UIColor blackColor];
    accountTF.placeholder = @"账号";
    [self.view addSubview:accountTF];
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100);
    }];
    
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    passwordTF.textColor = [UIColor blackColor];
    passwordTF.placeholder = @"密码";
    [self.view addSubview:passwordTF];
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(accountTF.mas_bottom).offset(20);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn addTarget:self action:@selector(pressLogin) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor colorWithHextColorString:@"AAAAAA"];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 23;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(passwordTF.mas_bottom).offset(50);
    }];
    
    UIButton *registBtn = [[UIButton alloc] init];
    [registBtn addTarget:self action:@selector(pressRegist) forControlEvents:UIControlEventTouchUpInside];
    registBtn.backgroundColor = [UIColor colorWithHextColorString:@"AAAAAA"];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.layer.cornerRadius = 23;
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(20);
    }];
    
}
- (void)pressLogin{
    [self.navigationController pushViewController:[EFRegisterViewController new] animated:YES];
}
- (void)pressRegist{
    [self.navigationController pushViewController:[EFRegisterViewController new] animated:YES];
}
@end
