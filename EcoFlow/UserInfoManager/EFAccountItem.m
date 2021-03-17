//
//  EFAccountItem.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFAccountItem.h"

@implementation EFAccountItem

MJCodingImplementation

- (void)updateAppToken:(NSString *)appToken {
    if (appToken.length > 0) {
        EFAccountItem *account = [EFAccountManager account];
        account.appToken = appToken;
        [EFAccountManager save:account];
    } else {
        [EFAccountManager deleteAccount];
    }
}

- (void)updateAppLoginSuccessFlag:(NSString *)flag {
    EFAccountItem *account = [EFAccountManager account];
    account.LoginFlag = flag;
    [EFAccountManager save:account];
    
    
    NSString *channelStr = [EFAccountManager shareAccountManager].curLoginChannel;
    if (channelStr.length > 0) {
        [NSObject saveString:channelStr forKey:kAppLoginChannel];
        [EFAccountManager shareAccountManager].curLoginChannel = nil;
    }
    
}

/// 更新app avatar image
- (void)updateAppAvatarImage:(NSString *)avatarImage {
    if (avatarImage.length > 0) {
        EFAccountItem *account = [EFAccountManager account];
        account.avatarImage = avatarImage;
        [EFAccountManager save:account];
    }
}

- (void)updateHyMobile:(NSString *)hy_mobile {
    if (hy_mobile.length > 0) {
        EFAccountItem *account = [EFAccountManager account];
        account.hy_mobile = hy_mobile;
        [EFAccountManager save:account];
    }
}

- (void)updateUserInfo:(EFLoginCurrentUserInfo *)currentUserInfo {
    EFAccountItem *account = [EFAccountManager account];
//    account.currentUserInfo = currentUserInfo;
//    account.userInfo.productId = currentUserInfo.productId;
//    account.userInfo.userId = currentUserInfo.userId;
//    account.userInfo.userCode = currentUserInfo.userCode;
//    account.userInfo.userName = currentUserInfo.userName;
//    account.userInfo.headerImg = currentUserInfo.headerImg;
//    account.userInfo.userType = currentUserInfo.userType;
//    account.userInfo.userRole = currentUserInfo.userRole;
//    account.userInfo.mobile = currentUserInfo.mobile;
//    account.userInfo.tokenExpires = currentUserInfo.tokenExpires;

    [EFAccountManager save:account];
}

@end
