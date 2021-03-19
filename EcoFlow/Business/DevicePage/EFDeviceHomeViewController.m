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
#import "GCDAsyncSocketCommunicationManager.h"
#import "GACConnectConfig.h"
#import "EFDeviceBottomViewController.h"
#import "EFDevicePresentViewController.h"
#import "EFDeviceBottomView.h"
#import "BlueToothListViewController.h"
#import "EcoFlow-Swift.h"
@interface EFDeviceHomeViewController ()<GACSocketDelegate>

@property (nonatomic, weak) NSTimer *timer;
@property(nonatomic, assign) int countNum;

@property (nonatomic, strong) GACConnectConfig *connectConfig;

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *serviceBtn;

@property (nonatomic, strong) UILabel *chargeLB;
@property (nonatomic, strong) UILabel *hourLB;

@property (nonatomic, strong) UIButton *acBtn;
@property (nonatomic, strong) UIButton *dcBtn;
@property (nonatomic, strong) UIButton *carBtn;
//底部滑块
@property (nonatomic, strong) EFDeviceBottomView *sliderView;

@end

@implementation EFDeviceHomeViewController{
    NSInteger _statue;
    NSInteger freqState;
    NSInteger lightState;
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
    [GCDAsyncSocketCommunicationManager sharedInstance].socketDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HeartBeat) name:@"HeartBeatNotification" object:nil];
    
    
}
- (void)HeartBeat{
    self.chargeLB.text = [NSString stringWithFormat:@"%d%%",[ParsingTool sharedInstance].statePD.socSum];
    self.hourLB.text = [NSString stringWithFormat:@"%d hours",[ParsingTool sharedInstance].statePD.remainTime/60];
}
#pragma mark - UI
- (void)createUI{
    self.zx_hideBaseNavBar = YES;
    
    self.view.backgroundColor = [UIColor colorWithHextColorString:@"FAFAFA"];
    
    self.titleBtn = [[UIButton alloc] init];
    [self.titleBtn setTitle:@"R600 >" forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.titleBtn setTitleColor:[UIColor colorWithHextColorString:@"111111"] forState:UIControlStateNormal];
    [self.view addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.view).offset(40);
        make.leading.mas_equalTo(self.view).offset(20);
    }];
    
    self.serviceBtn = [[UIButton alloc] init];
    self.serviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.serviceBtn setTitle:@"👤" forState:UIControlStateNormal];
    self.serviceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.serviceBtn setTitleColor:[UIColor colorWithHextColorString:@"111111"] forState:UIControlStateNormal];
    [self.view addSubview:self.serviceBtn];
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.titleBtn);
        make.trailing.mas_equalTo(self.view).offset(-20);
    }];
    
    UILabel *chargeTitleLB = [[UILabel alloc] init];
    chargeTitleLB.text = @"charging";
    chargeTitleLB.textColor = [UIColor colorWithHextColorString:@"222222"];
    chargeTitleLB.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:chargeTitleLB];
    [chargeTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.leading.mas_equalTo(self.view).offset(15);
        make.top.mas_equalTo(self.view).offset(KNavBarHeight+35);
    }];
    
    self.chargeLB = [[UILabel alloc] init];
    self.chargeLB.text = @"80%";
    self.chargeLB.textColor = [UIColor colorWithHextColorString:@"000000"];
    self.chargeLB.font = [UIFont systemFontOfSize:35];
    [self.view addSubview:self.chargeLB];
    [self.chargeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.leading.mas_equalTo(self.view).offset(15);
        make.top.mas_equalTo(chargeTitleLB.mas_bottom).offset(5);
    }];
    
    self.hourLB = [[UILabel alloc] init];
    self.hourLB.text = @"12.35 h";
    self.hourLB.textColor = [UIColor colorWithHextColorString:@"000000"];
    self.hourLB.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.hourLB];
    [self.hourLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
        make.leading.mas_equalTo(self.view).offset(15);
        make.top.mas_equalTo(self.chargeLB.mas_bottom).offset(5);
    }];
    
    
    self.acBtn = [[UIButton alloc] init];
    [self.acBtn setTitle:@"AC" forState:UIControlStateNormal];
    self.acBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.acBtn.backgroundColor = [UIColor colorWithHextColorString:@"DDDDDD"];
    [self.acBtn setTitleColor:[UIColor colorWithHextColorString:@"111111"] forState:UIControlStateNormal];
    [self.acBtn addTarget:self action:@selector(pressAc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.acBtn];
    [self.acBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.hourLB.mas_bottom).offset(30);
        make.leading.mas_equalTo(self.view).offset(20);
    }];
    self.acBtn.layer.cornerRadius = 25;
    self.acBtn.layer.masksToBounds = YES;
    
    self.dcBtn = [[UIButton alloc] init];
    [self.dcBtn setTitle:@"DC" forState:UIControlStateNormal];
    self.dcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dcBtn.backgroundColor = [UIColor colorWithHextColorString:@"DDDDDD"];
    [self.dcBtn addTarget:self action:@selector(pressDc) forControlEvents:UIControlEventTouchUpInside];
    [self.dcBtn setTitleColor:[UIColor colorWithHextColorString:@"111111"] forState:UIControlStateNormal];
    [self.view addSubview:self.dcBtn];
    [self.dcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.hourLB.mas_bottom).offset(30);
        make.left.mas_equalTo(self.acBtn.mas_right).offset(15);
    }];
    self.dcBtn.layer.cornerRadius = 25;
    self.dcBtn.layer.masksToBounds = YES;
    
    self.carBtn = [[UIButton alloc] init];
    [self.carBtn setTitle:@"CAR" forState:UIControlStateNormal];
    self.carBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.carBtn.backgroundColor = [UIColor colorWithHextColorString:@"DDDDDD"];
    [self.carBtn setTitleColor:[UIColor colorWithHextColorString:@"111111"] forState:UIControlStateNormal];
    [self.view addSubview:self.carBtn];
    [self.carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.hourLB.mas_bottom).offset(30);
        make.left.mas_equalTo(self.dcBtn.mas_right).offset(15);
    }];
    self.carBtn.layer.cornerRadius = 25;
    self.carBtn.layer.masksToBounds = YES;
    
    UIButton *bluetooth = [[UIButton alloc] init];
    [bluetooth setTitle:@"蓝牙" forState:UIControlStateNormal];
    bluetooth.titleLabel.font = [UIFont systemFontOfSize:14];
    bluetooth.backgroundColor = [UIColor colorWithHextColorString:@"DDDDDD"];
    [bluetooth addTarget:self action:@selector(pressBluetooth) forControlEvents:UIControlEventTouchUpInside];
    [bluetooth setTitleColor:[UIColor colorWithHextColorString:@"111111"] forState:UIControlStateNormal];
    [self.view addSubview:bluetooth];
    [bluetooth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.hourLB.mas_bottom).offset(30);
        make.left.mas_equalTo(self.carBtn.mas_right).offset(15);
    }];
    bluetooth.layer.cornerRadius = 25;
    bluetooth.layer.masksToBounds = YES;
    
    //滑块方案1
//    EFDeviceBottomViewController *vc = [[EFDeviceBottomViewController alloc] init];
//    EFDevicePresentViewController *pre = [[EFDevicePresentViewController alloc] initWithPresentedViewController:vc presentingViewController:self];
//    vc.transitioningDelegate = pre;
//    [self presentViewController:vc animated:YES completion:nil];
    
    //滑块方案2
    self.sliderView = [[EFDeviceBottomView alloc] init];
    self.sliderView.frame = CGRectMake(0, ScreenHeight-300-KTabBarHeight, ScreenWidth, 300);
    [self.view addSubview:self.sliderView];
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.sliderView addGestureRecognizer:tap];
}
#pragma mark - 按钮点击事件
- (void)pressAc{
    self.acBtn.selected = !self.acBtn.selected;
    [[GCDAsyncSocketCommunicationManager sharedInstance].socketManager socketWriteRawData:[[EncodeTool sharedInstance] generateSet_ACWithState:self.acBtn.selected]];
}
- (void)pressDc{
    self.dcBtn.selected = !self.dcBtn.selected;
    [[GCDAsyncSocketCommunicationManager sharedInstance].socketManager socketWriteRawData:[[EncodeTool sharedInstance] generateSet_DCWithState:self.dcBtn.selected]];
}
- (void)pressBluetooth{
    BlueToothListViewController *blueVC = [[BlueToothListViewController alloc] init];
    [self.navigationController pushViewController:blueVC animated:YES];
}
#pragma mark - 滑块手势
- (void)pan:(UIPanGestureRecognizer*)swipe{
    if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.sliderView]];
    }
    if (swipe.state == UIGestureRecognizerStateEnded) {
        if (_statue == 1) {
            [UIView animateWithDuration:0.20 animations:^{
                self.sliderView.frame = CGRectMake(0, 50, ScreenWidth, ScreenHeight-50-KTabBarHeight);
                self.sliderView.oneContentView.hidden = YES;
                self.sliderView.twoContentView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.15 animations:^{
                self.sliderView.frame = CGRectMake(0, ScreenHeight-300-KTabBarHeight, ScreenWidth, 300);
                self.sliderView.oneContentView.hidden = NO;
                self.sliderView.twoContentView.hidden = YES;
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
            if (self.sliderView.frame.origin.y>50) {
                [UIView animateWithDuration:0.20 animations:^{
                    self.sliderView.frame = CGRectMake(0, ScreenHeight-300-absY-KTabBarHeight, ScreenWidth, 300+absY);
                } completion:^(BOOL finished) {
                    
                }];
            }
            _statue = 1;
        }else{ //向下滑动
            if (self.sliderView.frame.origin.y<ScreenHeight-300-KTabBarHeight) {
                [UIView animateWithDuration:0.20 animations:^{
                    self.sliderView.frame = CGRectMake(0, 50+absY, ScreenWidth, ScreenHeight-50-absY-KTabBarHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }
            _statue = 2;
        }
    }
}

#pragma mark - GACDelegate
- (void)socketReadedData:(nullable id)data forType:(NSInteger)type{
    ParsingTool *parsing = [ParsingTool sharedInstance];
    [parsing parsingDataWithData:data];
}

- (void)socketDidConnect{
    //连接成功发送心跳包
    EncodeTool *encode = [EncodeTool sharedInstance];
    NSData *data = [encode generatePD_STATUS];
    [[GCDAsyncSocketCommunicationManager sharedInstance].socketManager socketWriteRawData:data];
}

- (void)connectionAuthAppraisalFailedWithErorr:(nonnull NSError *)error{
    NSLog(@"...");
}
//TODO:- 刷新设备数据
- (void)refreshDeviceShowData:(EFDeviceData *)deviceData {
    NSInteger soc = deviceData.status.bms_m.soc;
    NSInteger temperature = deviceData.status.bms_m.temp;
    NSInteger watts_out_sum = deviceData.status.pd.watts_out_sum;
    NSInteger timeH = deviceData.status.pd.remain_time / 60;
    NSInteger timeM = deviceData.status.pd.remain_time % 60;
    
    NSInteger led_state = deviceData.status.pd.led_state;
//    self.lightState = led_state;
//
//    self.batteryValueLab.text = [NSString stringWithFormat:@"%ld%%", soc];
//    self.temperatureValueLab.text = [NSString stringWithFormat:@"%ld℃", temperature];
//    self.powerValueLab.text = [NSString stringWithFormat:@"%ldW", watts_out_sum];
//    self.timeValueLab.text = [NSString stringWithFormat:@"%ldh%ldm", timeH,timeM];
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
    
//    if (self.freqState == 1) {
//        self.freqState = 2;
//    } else {
//        self.freqState = 1;
//    }
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"id" : @(66), @"out_freq" : @(freqState)}};
    [self setupDevice:dict];
}

- (void)clickedLightSWAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];
    
    NSLog(@"~~~~~~~~~~~~~~~clickedLightSWActionState:%ld", lightState);
    lightState = lightState + 1;
    if (lightState > 3) {
        lightState = 0;
    }
//    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"state" : @(self.lightState), @"id" : @(35), @"work_mode" : @(0), @"model" : @(0), @"brightness" : @(0), @"animateMode" : @(0), @"color" : @(0), @"enabled" : @(0), @"out_voltage" : @(0), @"out_freq" : @(0), @"xboost" : @(0), @"standby_mode" : @(0), @"lcd_time" : @(0), @"max_chg_soc" : @(0)}};
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"state" : @(lightState), @"id" : @(35)}};
    [self setupDevice:dict];
}

- (void)clickedACSWAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"enabled" : @(self.acBtn.selected), @"id" : @(66)}};
    [self setupDevice:dict];
}

- (void)clickedDCSWAction:(UIButton *)btn {
    [btn setUIKitShortLockTime];
    NSDictionary *dict = @{@"sn" : @"R7ABZ5HCC112218", @"cfg" : @{@"enabled" : @(self.dcBtn.selected), @"id" : @(34)}};
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
