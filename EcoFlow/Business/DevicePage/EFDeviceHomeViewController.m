//
//  EFDeviceHomeViewController.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFDeviceHomeViewController.h"

#import "AFURLSessionManager.h"
#import "RoundProgressView.h"
#import "EFDeviceData.h"

#import "EcoFlow-Swift.h"

#import "GCDAsyncSocketCommunicationManager.h"
#import "GACConnectConfig.h"
#import "EFDeviceBottomViewController.h"
#import "EFDevicePresentViewController.h"
#import "EFDeviceBottomView.h"

@interface EFDeviceHomeViewController ()

@property (assign, nonatomic) NSInteger lightState;
@property (assign, nonatomic) NSInteger ACState;
@property (assign, nonatomic) NSInteger DCState;
@property (assign, nonatomic) NSInteger freqState;

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *batteryValueLab;
@property (strong, nonatomic) UILabel *temperatureValueLab;
@property (strong, nonatomic) UILabel *powerValueLab;
@property (strong, nonatomic) UILabel *timeValueLab;

@property (strong, nonatomic) RoundProgressView *progressView;

@property (nonatomic, weak) NSTimer *timer;
@property(nonatomic, assign) int countNum;

@property (nonatomic, strong) GACConnectConfig *connectConfig;

//底部滑块
@property (nonatomic, strong) EFDeviceBottomView *sliderView;

@end

@implementation EFDeviceHomeViewController{
    NSInteger _statue;
}

- (GACConnectConfig *)connectConfig {
    if (!_connectConfig) {
        _connectConfig = [[GACConnectConfig alloc] init];
        _connectConfig.host = @"192.168.4.1";
        _connectConfig.port = 8055;
    }
    _connectConfig.token = @"f14c4e6f6c89335ca5909031d1a6efa9";
    
    return _connectConfig;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[GCDAsyncSocketCommunicationManager sharedInstance] createSocketWithConfig:self.connectConfig];
    
    NSString *ipStr = [NSObject getIPAddressStr];
    NSLog(@"11");
    
//    BaseDevice *dev = [[BaseDevice alloc] ];
//    NSData *data = [BaseDevice configLEDByLanWithState:1];
    
//    CRCCheck *t = [[CRCCheck alloc] init];
//    UInt8 x = [t makeCRC8WithData:@[@1, @2, @3]];
//    NSLog(@"");
//    [[[CRCCheck alloc] init] checkCRC8WithBuf:@[@1, @2, @3]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.zx_hideBaseNavBar = YES;
    
    self.lightState = 0;
    
    UILabel *titleLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"设备首页";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KBFont(18);
        label.textColor = EFColorHex(@"#FF333333");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    self.titleLab = titleLab;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(8 + kTopBarSafeHeightNew);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(ScreenWidth-180);
    }];
    
    UIButton *moreBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
//        [btn setImage:KImage(@"Personal_Center_icon_back") forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateHighlighted];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickedMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn;
    });
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.top.mas_equalTo(8 + kTopBarSafeHeightNew);
        make.width.height.mas_equalTo(44);
    }];
    
    UIButton *contactBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor blueColor];
//        [btn setImage:KImage(@"Personal_Center_icon_back") forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateHighlighted];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickedContactAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn;
    });
    
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-4);
        make.top.mas_equalTo(8 + kTopBarSafeHeightNew);
        make.width.height.mas_equalTo(44);
    }];
    
    self.progressView =[[RoundProgressView alloc] initWithFrame:CGRectMake((ScreenWidth - 300)/2, 100, 300, 300)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.progressView setProgressColor:[UIColor greenColor]];
//    self.progressView.lineDashPattern = @[@(8),@(8)];
    self.progressView.progressFont = [UIFont systemFontOfSize:70];
    [self.view addSubview:self.progressView];
    
    [self.progressView updateProgress:50];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(108 + kTopBarSafeHeightNew);
        make.width.height.mas_equalTo(300);
    }];
    
    UIButton *lightSWBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setImage:KImage(@"Personal_Center_icon_back") forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateHighlighted];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickedLightSWAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn;
    });
    
    [lightSWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressView);
        make.top.mas_equalTo(self.progressView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *ACSWBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"AC" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = KFont(20);
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setImage:KImage(@"Personal_Center_icon_back") forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateHighlighted];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickedACSWAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
//        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn;
    });
    
    [ACSWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.progressView.mas_centerX).offset(-3);
        make.bottom.mas_equalTo(self.progressView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *DCSWBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"DC" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = KFont(20);
//        btn.backgroundColor = [UIColor blueColor];
//        [btn setImage:KImage(@"Personal_Center_icon_back") forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateHighlighted];
//        [btn setImage:[UIImage imageNamed:@"Personal_Center_icon_back"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickedDCSWAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
//        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn;
    });
    
    [DCSWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressView.mas_centerX).offset(3);
        make.bottom.mas_equalTo(self.progressView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(44);
    }];
    
    UIImageView *batteryIcon = [UIImageView new];
    batteryIcon.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:batteryIcon];
    
    [batteryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressView.mas_left);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(80);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *batteryValueLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"--%";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KBFont(22);
        label.textColor = EFColorHex(@"#FF333333");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    self.batteryValueLab = batteryValueLab;
    
    [batteryValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(batteryIcon.mas_centerY);
        make.left.mas_equalTo(batteryIcon.mas_right).offset(12);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *batteryNameLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Battery";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KFont(14);
        label.textColor = EFColorHex(@"#FF666666");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    
    [batteryNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(batteryValueLab.mas_left);
        make.top.mas_equalTo(batteryValueLab.mas_bottom).offset(3);
        make.height.mas_equalTo(18);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(70);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(64);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(batteryIcon.mas_left);
        make.right.mas_equalTo(line1.mas_left).offset(-15);
        make.top.mas_equalTo(line1.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *temperatureIcon = [UIImageView new];
    temperatureIcon.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:temperatureIcon];
    
    [temperatureIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).offset(15);
        make.top.mas_equalTo(batteryIcon.mas_top);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *temperatureValueLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"--℃";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KBFont(22);
        label.textColor = EFColorHex(@"#FF333333");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    self.temperatureValueLab = temperatureValueLab;
    
    [temperatureValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(temperatureIcon.mas_centerY);
        make.left.mas_equalTo(temperatureIcon.mas_right).offset(12);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *temperatureNameLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Temperature";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KFont(14);
        label.textColor = EFColorHex(@"#FF666666");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    
    [temperatureNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(temperatureValueLab.mas_left);
        make.top.mas_equalTo(temperatureValueLab.mas_bottom).offset(3);
        make.height.mas_equalTo(18);
    }];
    
    UIView *line3 = [UIView new];
    line3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(line1.mas_bottom).offset(30);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(64);
    }];
    
    UIView *line4 = [UIView new];
    line4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line4];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(line2.mas_width);
        make.left.mas_equalTo(line1.mas_right).offset(15);
        make.top.mas_equalTo(line1.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *powerIcon = [UIImageView new];
    powerIcon.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:powerIcon];
    
    [powerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressView.mas_left);
        make.top.mas_equalTo(line3.mas_top).offset(9);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *powerValueLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"--W";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KBFont(22);
        label.textColor = EFColorHex(@"#FF333333");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    self.powerValueLab = powerValueLab;
    
    [powerValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(powerIcon.mas_centerY);
        make.left.mas_equalTo(powerIcon.mas_right).offset(12);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *powerNameLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Power";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KFont(14);
        label.textColor = EFColorHex(@"#FF666666");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    
    [powerNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(powerValueLab.mas_left);
        make.top.mas_equalTo(powerValueLab.mas_bottom).offset(3);
        make.height.mas_equalTo(18);
    }];
    
    UIImageView *timeIcon = [UIImageView new];
    timeIcon.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:timeIcon];
    
    [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(temperatureIcon.mas_left);
        make.top.mas_equalTo(powerIcon.mas_top);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *timeValueLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"--";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KBFont(22);
        label.textColor = EFColorHex(@"#FF333333");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    self.timeValueLab = timeValueLab;
    
    [timeValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeIcon.mas_centerY);
        make.left.mas_equalTo(timeIcon.mas_right).offset(12);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *timeNameLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Time";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KFont(14);
        label.textColor = EFColorHex(@"#FF666666");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    
    [timeNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeValueLab.mas_left);
        make.top.mas_equalTo(timeValueLab.mas_bottom).offset(3);
        make.height.mas_equalTo(18);
    }];
    
    [self getDeviceDetailData:YES];
    
//    [self setupTimer];
    
    self.view.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    
    
    //滑块方案1
//    EFDeviceBottomViewController *vc = [[EFDeviceBottomViewController alloc] init];
//    EFDevicePresentViewController *pre = [[EFDevicePresentViewController alloc] initWithPresentedViewController:vc presentingViewController:self];
//    vc.transitioningDelegate = pre;
//    [self presentViewController:vc animated:YES completion:nil];
    
    //滑块方案2
    self.sliderView = [[EFDeviceBottomView alloc] init];
    self.sliderView.frame = CGRectMake(0, ScreenHeight-400-KTabBarHeight, ScreenWidth, 400);
    [self.view addSubview:self.sliderView];
//    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(ScreenWidth);
//        make.height.mas_equalTo(400);
//        make.top.mas_equalTo(self.view).offset(ScreenHeight-400-KTabBarHeight);
//        make.centerX.mas_equalTo(self.view);
//    }];
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.sliderView addGestureRecognizer:tap];
}
#pragma mark - 滑块手势
- (void)pan:(UIPanGestureRecognizer*)swipe{
    if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.sliderView]];
    }
    if (swipe.state == UIGestureRecognizerStateEnded) {
        if (_statue == 1) {
            [UIView animateWithDuration:0.20 animations:^{
                self.sliderView.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight-100-KTabBarHeight);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.15 animations:^{
                self.sliderView.frame = CGRectMake(0, ScreenHeight-400, ScreenWidth, 400-KTabBarHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
/** 判断手势方向  */
- (void)commitTranslation:(CGPoint)translation {
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;
    if (absX > absY ) {
        if (translation.x<0) {//向左滑动
        }else{//向右滑动
        }
    } else if (absY > absX) {
        if (translation.y<0) {//向上滑动
            if (self.sliderView.frame.origin.y>100) {
                [UIView animateWithDuration:0.20 animations:^{
                    self.sliderView.frame = CGRectMake(0, ScreenHeight-400-absY, ScreenWidth, (400+absY)-KTabBarHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }
            _statue = 1;
        }else{ //向下滑动
            if (self.sliderView.frame.origin.y<ScreenHeight-400) {
                [UIView animateWithDuration:0.20 animations:^{
                    self.sliderView.frame = CGRectMake(0, 100+absY, ScreenWidth, ScreenHeight-100-absY-KTabBarHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }
            _statue = 2;
        }
    }
}
//TODO:- 刷新设备数据
- (void)refreshDeviceShowData:(EFDeviceData *)deviceData {
    NSInteger soc = deviceData.status.bms_m.soc;
    NSInteger temperature = deviceData.status.bms_m.temp;
    NSInteger watts_out_sum = deviceData.status.pd.watts_out_sum;
    NSInteger timeH = deviceData.status.pd.remain_time / 60;
    NSInteger timeM = deviceData.status.pd.remain_time % 60;
    
    NSInteger led_state = deviceData.status.pd.led_state;
    self.lightState = led_state;
    
    self.batteryValueLab.text = [NSString stringWithFormat:@"%ld%%", soc];
    self.temperatureValueLab.text = [NSString stringWithFormat:@"%ld℃", temperature];
    self.powerValueLab.text = [NSString stringWithFormat:@"%ldW", watts_out_sum];
    self.timeValueLab.text = [NSString stringWithFormat:@"%ldh%ldm", timeH,timeM];
}

//TODO:- 获取设备详情
- (void)getDeviceDetailData:(BOOL)isFirst {
    if (isFirst) {
        [EFProgressHUD show];
    }
    
    NSDictionary *paramDic = @{@"sn" : @"R7ABZ5HCC112218"};
    
    @weakify(self)
    [QBBaseNetTool getWithUrl:@"v1/devices/getDeviceData" param:paramDic resultClass:[EFDeviceDataEx class] success:^(EFDeviceDataEx *responseObj) {
        @strongify(self)
        [EFProgressHUD dismiss];
        BOOL isSuccess = NO;
        if (responseObj.data != nil) {
            isSuccess = YES;
            [self refreshDeviceShowData:responseObj.data];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [EFProgressHUD dismiss];
    }];
}

- (void)setupDevice:(NSDictionary *)configDic {
    
    [EFProgressHUD show];
    
    [QBBaseNetTool postWithUrl:@"v1/devices/configDevice" param:configDic resultClass:[EFLoginUserInfoEx class] isRawData:YES success:^(EFLoginUserInfoEx *responseObj) {
        [EFProgressHUD dismiss];
        BOOL isSuccess = NO;
        if (responseObj.data != nil) {
            isSuccess = YES;
            
        }
        NSLog(@"%@", responseObj);
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [EFProgressHUD dismiss];
    }];
}

//TODO:- 点击事件
- (void)clickedMoreAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];

    //FIXME:- test code
    [self getDeviceDetailData:YES];
}

- (void)clickedContactAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];
    
    if (self.freqState == 1) {
        self.freqState = 2;
    } else {
        self.freqState = 1;
    }
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"id" : @(66), @"out_freq" : @(self.freqState)}};
    [self setupDevice:dict];
}

- (void)clickedLightSWAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];
    
    NSLog(@"~~~~~~~~~~~~~~~clickedLightSWActionState:%ld", self.lightState);
    self.lightState = self.lightState + 1;
    if (self.lightState > 3) {
        self.lightState = 0;
    }
//    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"state" : @(self.lightState), @"id" : @(35), @"work_mode" : @(0), @"model" : @(0), @"brightness" : @(0), @"animateMode" : @(0), @"color" : @(0), @"enabled" : @(0), @"out_voltage" : @(0), @"out_freq" : @(0), @"xboost" : @(0), @"standby_mode" : @(0), @"lcd_time" : @(0), @"max_chg_soc" : @(0)}};
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"state" : @(self.lightState), @"id" : @(35)}};
    [self setupDevice:dict];
}

- (void)clickedACSWAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];
    if (self.ACState == 0) {
        self.ACState = 1;
    } else {
        self.ACState = 0;
    }
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"enabled" : @(self.ACState), @"id" : @(66)}};
    [self setupDevice:dict];
}

- (void)clickedDCSWAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];
    if (self.DCState == 0) {
        self.DCState = 1;
    } else {
        self.DCState = 0;
    }
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"enabled" : @(self.DCState), @"id" : @(34)}};
    [self setupDevice:dict];
}

- (void)ss {
    NSString *pwdStr = @"Fl100886*";
    
    NSData *pwdData = [pwdStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64PwdStr = [pwdData base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    
    NSDictionary *dict = @{@"account" : @"fqclovelal@qq.com", @"password" : base64PwdStr, @"user_type" : @"ecoflow_user", @"os" : @"ios", @"osVer" : @"13.0", @"appVer" : @"1.0"};
    
    [EFProgressHUD show];
    
    [QBBaseNetTool postWithUrl:@"v1/login" param:dict resultClass:[EFLoginUserInfoEx class] isRawData:YES success:^(EFLoginUserInfoEx *responseObj) {
        [EFProgressHUD dismiss];
        BOOL isSuccess = NO;
        if (responseObj.data != nil) {
            isSuccess = YES;
            
        }
        NSLog(@"%@", responseObj);
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [EFProgressHUD dismiss];
    }];
}

- (void)dd {
//    NSString *pwdStr = @"Aa123321";
    NSString *pwdStr = @"12345678";
    
    
    NSData *pwdData = [pwdStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64PwdStr = [pwdData base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    
    NSDictionary *dict = @{@"account" : @"kentz.zhang@ecoflow.com", @"password" : base64PwdStr, @"user_type" : @"ecoflow_user", @"os" : @"ios", @"osVer" : @"13.0", @"appVer" : @"1.0"};
    NSError *error;
    NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:dict
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://iot-ecoflow.com/api/v1/login" parameters:nil error:nil];

    req.timeoutInterval = 30;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [req setValue:IF_NEEDED forHTTPHeaderField:@"Authorization"];

    [req setHTTPBody:dataFromDict];
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"%@", responseObject);
                NSHTTPURLResponse *response1 = (NSHTTPURLResponse *)response;
                
                NSLog(@"%@", response1);
                NSLog(@"%@", response1.allHeaderFields);
            } else {
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            }
        }] resume];
}

//TODO:- 设置定时器
- (void)setupTimer {
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    _countNum = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(countNumAction) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)countNumAction {
    _countNum ++;
    
    [self getDeviceDetailData:NO];
}
@end
