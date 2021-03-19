//
//  BlueToothListViewController.m
//  EcoFlow
//
//  Created by Curry on 2021/3/19.
//

#import "BlueToothListViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BluetoothManager.h"
#import "EcoFlow-Swift.h"
#import "BluetoothDetailViewController.h"
@interface BlueToothListViewController ()<UITableViewDelegate,UITableViewDataSource,BluetoothDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@end

@implementation BlueToothListViewController{
    NSMutableArray *_dicoveredPeripherals;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [BluetoothManager sharedInstance].bluetoothDelegate = self;
    [[BluetoothManager sharedInstance] scanBegin];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    _dicoveredPeripherals = [[NSMutableArray alloc] initWithCapacity:0];
    
}
- (void)createUI {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight-80-KTabBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(KNavBarHeight);
    }];
}
#pragma mrk - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dicoveredPeripherals.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    CBPeripheral *cer = _dicoveredPeripherals[indexPath.row];
    if (cer.name != nil && cer.name != [NSNull null]) {
        cell.textLabel.text = cer.name;
    }else{
        cell.textLabel.text = @"未知设备";
    }
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral *peripheral = _dicoveredPeripherals[indexPath.row];
    [[BluetoothManager sharedInstance].manager connectPeripheral:peripheral options:nil];
    [BluetoothManager sharedInstance].peripheral = peripheral;
    BluetoothDetailViewController *vc = [[BluetoothDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - BluetoothDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if(![_dicoveredPeripherals containsObject:peripheral] && [peripheral.name containsString:@"ecoflow"])
        [_dicoveredPeripherals addObject:peripheral];
    [self.tableView reloadData];
}
@end
