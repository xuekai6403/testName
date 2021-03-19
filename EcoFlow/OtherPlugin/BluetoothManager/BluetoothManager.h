//
//  BluetoothManager.h
//  EcoFlow
//
//  Created by Curry on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

@protocol BluetoothDelegate <NSObject>

@optional
/**
 *  监听到服务器发送过来的消息
 *
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;

@end

@interface BluetoothManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong ,nonatomic)CBCentralManager *manager;
@property (strong ,nonatomic)CBPeripheral *peripheral;
@property (strong ,nonatomic)CBPeripheral *readPeripheral;
@property (strong ,nonatomic)CBCharacteristic *characteristic;
@property (strong ,nonatomic)CBCharacteristic *readCharacteristic;

@property (nonatomic, weak, nullable) id<BluetoothDelegate> bluetoothDelegate;

+ (nullable BluetoothManager *)sharedInstance;

- (void)scanBegin;
@end

NS_ASSUME_NONNULL_END
