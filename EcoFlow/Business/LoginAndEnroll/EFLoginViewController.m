//
//  EFLoginViewController.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFLoginViewController.h"

@interface EFLoginViewController ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation EFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLab = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"登录/注册 更精彩";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = KBFont(21);
        label.textColor = EFColorHex(@"#FF333333");
        [self.view addSubview:label];
        [label sizeToFit];
        label;
    });
    self.titleLab = titleLab;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hy_adapt_size(42));
        make.top.mas_equalTo(hy_adapt_size(107) + kTopBarSafeHeightNew);
    }];
}

@end
