//
//  EFDiscoverPageViewController.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFDiscoverPageViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface EFDiscoverPageViewController ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong ,nonatomic)CBCentralManager *manager;
@property (strong ,nonatomic)UITableView *tableView;
@end

@implementation EFDiscoverPageViewController{
    NSMutableArray *_dicoveredPeripherals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 隐藏导航栏
    self.zx_hideBaseNavBar = YES;
    
    [self createUI];
    
    _dicoveredPeripherals = [[NSMutableArray alloc] initWithCapacity:0];
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    [self.manager scanForPeripheralsWithServices:nil options:nil];

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
        make.top.mas_equalTo(self.view).offset(80);
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
    CBPeripheral *cer = _dicoveredPeripherals[indexPath.row];
    if (cer.name != nil && cer.name != [NSNull null]) {
        [self.manager connectPeripheral:cer options:nil];
    }
}
#pragma mrk - 蓝牙扫描
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
            case CBCentralManagerStateUnknown:
                break;
            case CBCentralManagerStateResetting:
                break;
            case CBCentralManagerStateUnsupported:
                break;
            case CBCentralManagerStateUnauthorized:
                break;
            case CBCentralManagerStatePoweredOff:
                break;
            case CBCentralManagerStatePoweredOn:
                [self.manager scanForPeripheralsWithServices:nil options:nil];
                break;
            default:
                break;
        }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if(![_dicoveredPeripherals containsObject:peripheral])
        [_dicoveredPeripherals addObject:peripheral];
    
    [self.tableView reloadData];
}
#pragma mrk - 蓝牙连接
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
  NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
  NSLog(@">>>外设连接断开连接 %@: %@", [peripheral name], [error localizedDescription]);
}
#pragma mrk - 蓝牙的服务与特征
- (void)peripheral:(CBPeripheral*)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

#pragma mark - 读取值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    NSLog(@"str:____%@",characteristic.UUID.UUIDString);
    NSLog(@"data:____%@",characteristic.UUID.data);
    [self decodeData:characteristic.UUID.data];
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"02"]]) {
//        uint8_t val = 1;
//        NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
//        [peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//    }
}
#pragma mark - 解析
- (void)decodeData:(NSData*)rsvData{
    //1
//    uint32_t rawInt = 0;
//    NSLog(@"rawInt Value Before: %d", rawInt);
//
//    [rsvData getBytes:&rawInt length:sizeof(rawInt)];
//    NSLog(@"rawInt Value After: %d", rawInt);

    //2
    NSData* dat = rsvData;
    NSLog(@"Receive from Peripheral: %@\n",dat);
    NSUInteger len = [dat length];
    Byte *bytedata = (Byte*)malloc(len);
    [dat getBytes:bytedata length:len];
    int p = 0;
    while(p < len)
    {
        printf("%02x",bytedata[p]);
        if(p!=len-1)
        {
         printf("-");
        }
        p++;
    }
    printf("\n");
    // byte array manipulation

    free(bytedata);
}
@end
