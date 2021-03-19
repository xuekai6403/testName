//
//  BluetoothDetailViewController.m
//  EcoFlow
//
//  Created by Curry on 2021/3/19.
//

#import "BluetoothDetailViewController.h"
#import "BluetoothManager.h"
@interface BluetoothDetailViewController ()

@end

@implementation BluetoothDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}
- (void)createUI{
    self.navigationController.title = [BluetoothManager sharedInstance].peripheral.name;
}
@end
