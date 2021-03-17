//
//  EFBaseViewController.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFBaseViewController.h"

@interface EFBaseViewController ()

@end

@implementation EFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
    self.zx_navLineView.hidden = YES;
    self.zx_navTitleColor = EFColorHex(@"#333333");
    
    
    @weakify(self)
    [self zx_setLeftBtnWithImgName:@"msg_icon_back_little" clickedBlock:^(UIButton * _Nonnull btn) {
        NSLog(@"点击了最左侧的Button");
        @strongify(self)
        if (self.backTapBlock) {
            self.backTapBlock();
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
//    [self.zx_navLeftBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    self.zx_navBarBackgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)dealloc {
    NSLog(@"%s^^^^^^^^^__^^dealloc",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
