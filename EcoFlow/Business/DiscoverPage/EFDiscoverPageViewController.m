//
//  EFDiscoverPageViewController.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFDiscoverPageViewController.h"

@interface EFDiscoverPageViewController ()

@end

@implementation EFDiscoverPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 隐藏导航栏
    self.zx_hideBaseNavBar = YES;
}

//- (void)pressBtn{
//    if(self.characteristic.properties & CBCharacteristicPropertyWrite){
//        NSData *data = [BaseDevice testBlueToothSNWithState:0];
//        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
//    }
//}
//- (void)pressBtnTwo{
//    if(self.characteristic.properties & CBCharacteristicPropertyWrite){
//        NSData *data = [BaseDevice testBlueToothWithState:0];
//        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
//    }
//}

@end
