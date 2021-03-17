//
//  EFBaseViewController.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "ZXNavigationBarController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EFBackTapBlock)(void);

@interface EFBaseViewController : ZXNavigationBarController

@property (nonatomic, copy) EFBackTapBlock backTapBlock;

@end

NS_ASSUME_NONNULL_END
