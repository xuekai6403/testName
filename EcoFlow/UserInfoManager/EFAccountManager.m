//
//  EFAccountManager.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFAccountManager.h"

#import <Contacts/Contacts.h>
#import <Photos/Photos.h>

#import "EFLoginViewController.h"
#import "AppDelegate.h"

#define EFAccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.plist"]

@implementation EFAccountManager

SingleImplementation(AccountManager);

// 存储帐号
+ (void)save:(EFAccountItem *)account
{
    [EFAccountManager shareAccountManager].accountInfo = account;
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:EFAccountFilepath];
}

// 读取帐号
+ (EFAccountItem *)account
{
    EFAccountItem *account = [NSKeyedUnarchiver unarchiveObjectWithFile:EFAccountFilepath];
    if (account) {
        [EFAccountManager shareAccountManager].accountInfo = account;
        return account;
    } else {
        EFAccountItem *account = [[EFAccountItem alloc] init];
        //基本设置
//        account.userInfo = [HYLoginUserInfo new];
//        account.currentUserInfo = [HYLoginCurrentUserInfo new];
        return account;
    }
}

// 删除帐号
+ (EFAccountItem *)deleteAccount {
    EFAccountItem *account = [EFAccountManager account];
    // 把token置为空
    account.appToken = nil;//填补数据后显示
    account.avatarImage = nil;
    account.LoginFlag = nil;
    account.youngStyleCode = nil;
    account.isYoungStyle = NO;
        
    [EFAccountManager save:account];
    
    return account;
}

/// 唤起登录页
+ (void)callLoginPage {
    EFLoginViewController *vc = [EFLoginViewController new];
    ZXNavigationBarNavigationController *nav = [[ZXNavigationBarNavigationController  alloc] initWithRootViewController:vc];
    if ([UIApplication sharedApplication].keyWindow) {
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    } else {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = nav;
    }
}

/// 获取用户信息
- (void)getUserInfo:(NSString *)tokenStr completionHandler:(void (^) (id responseObj, bool isSuccess))completionHandler {
    if (tokenStr.length > 0) {
        [[EFAccountManager shareAccountManager] getUserInfoDirect:completionHandler];
    } else {
        if ([EFAccountManager account].appToken.length>0) {
            [[EFAccountManager shareAccountManager] getUserInfoDirect:completionHandler];
        } else {
            //  未登录
            completionHandler(nil, NO);
        }
    }
}

/// 仅供内部使用方法
- (void)getUserInfoDirect:(void (^) (id responseObj, bool isSuccess))completionHandler {
    [EFProgressHUD show];
    [QBBaseNetTool postWithUrl:@"app/ums/info/getInfo" param:@{} resultClass:[EFLoginUserInfoEx class] isRawData:YES success:^(EFLoginUserInfoEx *responseObj) {
        [EFProgressHUD dismiss];
        BOOL isSuccess = NO;
        if (responseObj.data != nil) {
            isSuccess = YES;
            [[EFAccountManager account] updateUserInfo:responseObj.data];
            [[EFAccountManager account] updateAppLoginSuccessFlag:@"true"];
            
        }
        completionHandler(responseObj, isSuccess);
        NSLog(@"%@", responseObj);
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        completionHandler(nil, NO);
        [EFProgressHUD dismiss];
    }];
}


//MARK:- 通讯录权限检测
- (void)requestContactAuthorAfterSystemVersion9:(BOOL)isSimpleOne {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
            }else {
                NSLog(@"成功授权");
                [self openContact];
            }
            
            [self requestPhotoLibraryAuth:^(BOOL isSuccess) {
                if (isSuccess) {
                    NSLog(@"Auth Success");
                }
                
                [self requestLocationAuth];
            }];
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝");
//        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝");
//        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
}

//有通讯录权限-- 进行下一步操作
- (void)openContact {
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"-------------------------------------------------------");
        
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        
//        CNPhoneNumber  * cnphoneNumber = contact.phoneNumbers[0];
//        NSString * phoneNumber = cnphoneNumber.stringValue;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue ;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
        }
    }];
}

//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact {
    
//    UIAlertController *alertController = [UIAlertController
//        alertControllerWithTitle:@"请授权通讯录权限"
//        message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录"
//        preferredStyle: UIAlertControllerStyleAlert];
//
//    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:OKAction];
//    [self presentViewController:alertController animated:YES completion:nil];
}


//MARK:- 相册权限检测
- (void)requestPhotoLibraryAuth:(void (^)(BOOL isSuccess))completeBlock {
    
    if (PHAuthorizationStatusDenied == [PHPhotoLibrary authorizationStatus]) {
        [EFProgressHUD showErrorWithStatus:@"请到系统设置中允许对相册的访问"];
        completeBlock(NO);
        return;
    } else if (PHAuthorizationStatusNotDetermined == [PHPhotoLibrary authorizationStatus]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (PHAuthorizationStatusAuthorized == status) {
                    completeBlock(YES);
                } else {
                    [EFProgressHUD showErrorWithStatus:@"请到系统设置中允许对相册的访问"];
                    completeBlock(NO);
                }
            });
            
        }];
    } else if (PHAuthorizationStatusAuthorized == [PHPhotoLibrary authorizationStatus]){
        completeBlock(YES);
    }
}


//MARK:- 位置权限检测
- (void)requestLocationAuth {
    _locationManager = [CLLocationManager new];
    [_locationManager requestWhenInUseAuthorization];
}

@end
