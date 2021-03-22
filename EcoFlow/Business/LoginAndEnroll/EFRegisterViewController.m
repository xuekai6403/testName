//
//  EFRegisterViewController.m
//  EcoFlow
//
//  Created by Curry on 2021/3/22.
//

#import "EFRegisterViewController.h"

@interface EFRegisterViewController ()
@property (strong ,nonatomic) UITextField *accountTF;
@property (strong ,nonatomic) UITextField *passwordTF;
@property (strong ,nonatomic) UITextField *nameTF;
@property (strong ,nonatomic) UITextField *apasswordTF;
@property (strong ,nonatomic) UITextField *codeTF;
@end

@implementation EFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    accountTF = [[UITextField alloc] init];
    accountTF.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    accountTF.textColor = [UIColor blackColor];
    accountTF.placeholder = @"手机";
    [self.view addSubview:accountTF];
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100);
    }];
    
    nameTF = [[UITextField alloc] init];
    nameTF.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    nameTF.textColor = [UIColor blackColor];
    nameTF.placeholder = @"用户名";
    [self.view addSubview:nameTF];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(accountTF.mas_bottom).offset(20);
    }];
    
    passwordTF = [[UITextField alloc] init];
    passwordTF.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    passwordTF.textColor = [UIColor blackColor];
    passwordTF.placeholder = @"密码";
    [self.view addSubview:passwordTF];
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(nameTF.mas_bottom).offset(20);
    }];
    
    apasswordTF = [[UITextField alloc] init];
    apasswordTF.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    apasswordTF.textColor = [UIColor blackColor];
    apasswordTF.placeholder = @"确认密码";
    [self.view addSubview:apasswordTF];
    [apasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(passwordTF.mas_bottom).offset(20);
    }];
    
    codeTF = [[UITextField alloc] init];
    codeTF.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    codeTF.textColor = [UIColor blackColor];
    codeTF.placeholder = @"验证码";
    [self.view addSubview:codeTF];
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(apasswordTF.mas_bottom).offset(20);
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
        make.top.mas_equalTo(codeTF.mas_bottom).offset(40);
    }];
}
- (void)pressRegist{
    [QBBaseNetTool postWithUrl:@"v1/register" param:@{@"":,@"":,@"":,@"":,@"":,} resultClass:<#(__unsafe_unretained Class)#> isRawData:<#(BOOL)#> success:<#^(id responseObj)success#> failure:<#^(NSError *error)failure#>]
}
@end
