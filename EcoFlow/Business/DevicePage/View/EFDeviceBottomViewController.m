//
//  EFDeviceBottomViewController.m
//  EcoFlow
//
//  Created by Curry on 2021/3/16.
//

#import "EFDeviceBottomViewController.h"

@interface EFDeviceBottomViewController ()

@end

@implementation EFDeviceBottomViewController
- (BOOL)hidesBottomBarWhenPushed{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.masksToBounds = YES;
    self.hidesBottomBarWhenPushed = NO;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, ScreenWidth, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    topView.layer.cornerRadius = 15;
    topView.layer.shadowColor = [UIColor blackColor].CGColor;
    topView.layer.shadowOffset = CGSizeMake(0, 0);
    topView.layer.shadowOpacity = 0.1;
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoView];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-20, 0, 40, 4)];
    tipView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tipView];
    tipView.layer.cornerRadius = 2;
    tipView.layer.masksToBounds = YES;
    
    [self createUI];
}
- (void)createUI{
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(15, 50, (ScreenWidth-45)/2, 100)];
    oneView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.view addSubview:oneView];
    oneView.layer.cornerRadius = 5;
    oneView.layer.masksToBounds = YES;
    
    UILabel *oneLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    oneLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    oneLB.text = @"电池信息";
    oneLB.font = [UIFont systemFontOfSize:15];
    [oneView addSubview:oneLB];
    
    UILabel *oneContentLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 90, 20)];
    oneContentLB.textColor = [UIColor colorWithHextColorString:@"111111"];
    oneContentLB.text = @"100%";
    oneContentLB.font = [UIFont systemFontOfSize:20];
    [oneView addSubview:oneContentLB];
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(15+15+(ScreenWidth-45)/2, 50, (ScreenWidth-45)/2, 100)];
    twoView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.view addSubview:twoView];
    twoView.layer.cornerRadius = 5;
    twoView.layer.masksToBounds = YES;
    
    UILabel *twoLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    twoLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    twoLB.text = @"温度";
    twoLB.font = [UIFont systemFontOfSize:15];
    [twoView addSubview:twoLB];
    
    UILabel *twoContentLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 90, 20)];
    twoContentLB.textColor = [UIColor colorWithHextColorString:@"111111"];
    twoContentLB.text = @"37.C";
    twoContentLB.font = [UIFont systemFontOfSize:20];
    [twoView addSubview:twoContentLB];
    
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(15, 50+15+100, (ScreenWidth-45)/2, 100)];
    threeView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.view addSubview:threeView];
    threeView.layer.cornerRadius = 5;
    threeView.layer.masksToBounds = YES;
    
    UILabel *threeLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    threeLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    threeLB.text = @"电池信息";
    threeLB.font = [UIFont systemFontOfSize:15];
    [threeView addSubview:threeLB];
    
    UILabel *threeContentLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 90, 20)];
    threeContentLB.textColor = [UIColor colorWithHextColorString:@"111111"];
    threeContentLB.text = @"100%";
    threeContentLB.font = [UIFont systemFontOfSize:20];
    [threeView addSubview:threeContentLB];
    
    UIView *fourView = [[UIView alloc] initWithFrame:CGRectMake(15+15+(ScreenWidth-45)/2, 50+15+100, (ScreenWidth-45)/2, 100)];
    fourView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.view addSubview:fourView];
    fourView.layer.cornerRadius = 5;
    fourView.layer.masksToBounds = YES;
    
    UILabel *fourLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    fourLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    fourLB.text = @"关于本机";
    fourLB.font = [UIFont systemFontOfSize:15];
    [fourView addSubview:fourLB];
    
    UILabel *fourContentLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 90, 20)];
    fourContentLB.textColor = [UIColor colorWithHextColorString:@"111111"];
    fourContentLB.text = @"37.C";
    fourContentLB.font = [UIFont systemFontOfSize:20];
    [fourView addSubview:fourContentLB];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 300, ScreenWidth-80, 40)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [closeBtn setTitleColor:[UIColor colorWithHextColorString:@"111111"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(pressClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    closeBtn.layer.cornerRadius = 20;
    closeBtn.layer.masksToBounds = YES;
}
- (void)pressClose{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
