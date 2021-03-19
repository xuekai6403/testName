//
//  EFDeviceBottomView.m
//  EcoFlow
//
//  Created by Curry on 2021/3/16.
//

#import "EFDeviceBottomView.h"
#import <Masonry.h>
@implementation EFDeviceBottomView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, ScreenWidth, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    topView.layer.cornerRadius = 15;
    topView.layer.shadowColor = [UIColor blackColor].CGColor;
    topView.layer.shadowOffset = CGSizeMake(0, 0);
    topView.layer.shadowOpacity = 0.1;
    
    UIView *topTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    topTwoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topTwoView];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-20, 0, 40, 4)];
    tipView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:tipView];
    tipView.layer.cornerRadius = 2;
    tipView.layer.masksToBounds = YES;
    
    self.oneContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 350)];
    [self addSubview:self.oneContentView];
    
    UIView *oneTopView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 80)];
    oneTopView.backgroundColor = [UIColor colorWithHextColorString:@"DDDDDD"];
    [self.oneContentView addSubview:oneTopView];
    oneTopView.layer.cornerRadius = 5;
    oneTopView.layer.masksToBounds = YES;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(0, 0)];
    [bezier addLineToPoint:CGPointMake((ScreenWidth-30)/2+10, 0)];
    [bezier addLineToPoint:CGPointMake((ScreenWidth-30)/2-10, 80)];
    [bezier addLineToPoint:CGPointMake(0, 80)];
    [bezier addLineToPoint:CGPointMake(0,0)];
    layer.path = bezier.CGPath;
    layer.fillColor = [UIColor colorWithHextColorString:@"EEEEEE"].CGColor;
    
    [oneTopView.layer addSublayer:layer];
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(15, 100, (ScreenWidth-45)/2, 70)];
    oneView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.oneContentView addSubview:oneView];
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
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(15+15+(ScreenWidth-45)/2, 100, (ScreenWidth-45)/2, 70)];
    twoView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.oneContentView addSubview:twoView];
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
    
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(15, 180, (ScreenWidth-45)/2, 70)];
    threeView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.oneContentView addSubview:threeView];
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
    
    UIView *fourView = [[UIView alloc] initWithFrame:CGRectMake(15+15+(ScreenWidth-45)/2, 180, (ScreenWidth-45)/2, 70)];
    fourView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.oneContentView addSubview:fourView];
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
    
    //2
    self.twoContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, ScreenHeight-50-KTabBarHeight-30)];
    self.twoContentView.contentSize = CGSizeMake(ScreenWidth, 900);
    [self addSubview:self.twoContentView];
    self.twoContentView.hidden = YES;
    
    UILabel *twoDataLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 20)];
    twoDataLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    twoDataLB.text = @"Device Data";
    twoDataLB.font = [UIFont systemFontOfSize:15];
    [self.twoContentView addSubview:twoDataLB];
    
    //电池数据
    UIView *twoTopView = [[UIView alloc] init];
    twoTopView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.twoContentView addSubview:twoTopView];
    twoTopView.layer.cornerRadius = 5;
    twoTopView.layer.masksToBounds = YES;
    [twoTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(90);
        make.top.mas_equalTo(twoDataLB.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.twoContentView).offset(15);
    }];
    
    //电池
    UILabel *batteryTitLB = [[UILabel alloc] init];
    batteryTitLB.textAlignment = NSTextAlignmentCenter;
    batteryTitLB.textColor = [UIColor colorWithHextColorString:@"FFFFFF"];
    batteryTitLB.text = @"Battery";
    batteryTitLB.font = [UIFont systemFontOfSize:15];
    [twoTopView addSubview:batteryTitLB];
    [batteryTitLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth-30)/4);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(twoTopView).offset(-5);
        make.leading.mas_equalTo(twoTopView);
    }];
    
    //Management
    UILabel *twoManaLB = [[UILabel alloc] init];
    twoManaLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    twoManaLB.text = @"Device Magagement";
    twoManaLB.font = [UIFont systemFontOfSize:15];
    [self.twoContentView addSubview:twoManaLB];
    [twoManaLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(twoTopView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.twoContentView).offset(15);
    }];
    
    UIView *twoOneView = [[UIView alloc] init];
    twoOneView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.twoContentView addSubview:twoOneView];
    twoOneView.layer.cornerRadius = 5;
    twoOneView.layer.masksToBounds = YES;
    [twoOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth-45)/2);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(twoManaLB.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.twoContentView).offset(15);
    }];
    
    UILabel *twoOneLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    twoOneLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    twoOneLB.text = @"电池信息";
    twoOneLB.font = [UIFont systemFontOfSize:15];
    [twoOneView addSubview:twoOneLB];
    
    UILabel *twoOneContentLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 90, 20)];
    twoOneContentLB.textColor = [UIColor colorWithHextColorString:@"111111"];
    twoOneContentLB.text = @"100%";
    twoOneContentLB.font = [UIFont systemFontOfSize:20];
    [twoOneView addSubview:twoOneContentLB];
    
    UIView *twoTwoView = [[UIView alloc] init];
    twoTwoView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.twoContentView addSubview:twoTwoView];
    twoTwoView.layer.cornerRadius = 5;
    twoTwoView.layer.masksToBounds = YES;
    [twoTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth-45)/2);
        make.height.mas_equalTo(80);
        make.centerY.mas_equalTo(twoOneView);
        make.left.mas_equalTo(twoOneView.mas_right).offset(15);
    }];
    
    UILabel *twoTwoLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 20)];
    twoTwoLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    twoTwoLB.text = @"电池信息";
    twoTwoLB.font = [UIFont systemFontOfSize:15];
    [twoTwoView addSubview:twoTwoLB];

    UILabel *twoTwoContentLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 90, 20)];
    twoTwoContentLB.textColor = [UIColor colorWithHextColorString:@"111111"];
    twoTwoContentLB.text = @"100%";
    twoTwoContentLB.font = [UIFont systemFontOfSize:20];
    [twoTwoView addSubview:twoTwoContentLB];
    
    UILabel *threeManaLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 230, 150, 20)];
    threeManaLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    threeManaLB.text = @"Device Information";
    threeManaLB.font = [UIFont systemFontOfSize:15];
    [self.twoContentView addSubview:threeManaLB];
    [threeManaLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(twoOneView.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.twoContentView).offset(15);
    }];
    
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.twoContentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(260);
        make.centerX.mas_equalTo(self.twoContentView);
        make.top.mas_equalTo(threeManaLB.mas_bottom).offset(10);
    }];
    infoView.layer.cornerRadius = 5;
    infoView.layer.masksToBounds = YES;
    
    UILabel *setTitleLB = [[UILabel alloc] init];
    setTitleLB.textColor = [UIColor colorWithHextColorString:@"666666"];
    setTitleLB.text = @"Setting";
    setTitleLB.font = [UIFont systemFontOfSize:15];
    [self.twoContentView addSubview:setTitleLB];
    [setTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.leading.mas_equalTo(self.twoContentView).offset(15);
        make.top.mas_equalTo(infoView.mas_bottom).offset(10);
    }];
    
    UIView *ttView = [[UIView alloc] init];
    ttView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.twoContentView addSubview:ttView];
    ttView.layer.cornerRadius = 5;
    ttView.layer.masksToBounds = YES;
    [ttView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth-45)/2);
        make.height.mas_equalTo(80);
        make.leading.mas_equalTo(self.twoContentView).offset(15);
        make.top.mas_equalTo(setTitleLB.mas_bottom).offset(10);
    }];
    
    UIView *mmView = [[UIView alloc] init];
    mmView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self.twoContentView addSubview:mmView];
    mmView.layer.cornerRadius = 5;
    mmView.layer.masksToBounds = YES;
    [mmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((ScreenWidth-45)/2);
        make.height.mas_equalTo(80);
        make.left.mas_equalTo(ttView.mas_right).offset(15);
        make.centerY.mas_equalTo(ttView);
    }];
}

@end
