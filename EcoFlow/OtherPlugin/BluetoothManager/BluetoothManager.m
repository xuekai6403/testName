//
//  BluetoothManager.m
//  EcoFlow
//
//  Created by Curry on 2021/3/19.
//

#import "BluetoothManager.h"

@implementation BluetoothManager

+ (BluetoothManager *)sharedInstance {
    static BluetoothManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return self;
}
- (void)scanBegin{
    [self.manager scanForPeripheralsWithServices:nil options:nil];
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
    [self.bluetoothDelegate centralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
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
        self.peripheral = peripheral;
        if (characteristic.properties & CBCharacteristicPropertyWrite) {
            self.characteristic = characteristic;
        }else{
            self.readCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

#pragma mark - 读取值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic");
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    NSLog(@"didUpdateNotificationStateForCharacteristic");
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
}
@end
