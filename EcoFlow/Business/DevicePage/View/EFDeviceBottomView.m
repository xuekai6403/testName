//
//  EFDeviceBottomView.m
//  EcoFlow
//
//  Created by Curry on 2021/3/16.
//

#import "EFDeviceBottomView.h"

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
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(15, 50, (ScreenWidth-45)/2, 100)];
    oneView.backgroundColor = [UIColor colorWithHextColorString:@"EEEEEE"];
    [self addSubview:oneView];
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
    [self addSubview:twoView];
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
    [self addSubview:threeView];
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
    [self addSubview:fourView];
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
}

@end
