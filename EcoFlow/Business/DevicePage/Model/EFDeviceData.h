
#import "BaseModel.h"

@class EFDeviceData;
@class EFStatus;
@class EFBmsM;
@class EFBmsS;
@class EFInv;
@class EFPD;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface EFDeviceDataEx : BaseModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, strong) EFDeviceData *data;
@end

@interface EFDeviceData : BaseModel
@property (nonatomic, copy)           NSString *sn;
@property (nonatomic, assign)         NSInteger model;
@property (nonatomic, assign)         NSInteger productType;
@property (nonatomic, assign)         BOOL connected;
//@property (nonatomic, nullable, copy) id upgradeState;
@property (nonatomic, copy)           NSString *updatedAt;
@property (nonatomic, copy)           NSString *ip;
@property (nonatomic, strong)         EFStatus *status;
@end

@interface EFStatus : BaseModel
@property (nonatomic, strong) EFPD *pd;
@property (nonatomic, strong) EFInv *inv;
@property (nonatomic, strong) EFBmsM *bms_m;
@property (nonatomic, strong) EFBmsS *bms_s;
@end

@interface EFBmsM : BaseModel
@property (nonatomic, assign) NSInteger error_code;
@property (nonatomic, assign) NSInteger sys_ver;
@property (nonatomic, assign) NSInteger soc;
@property (nonatomic, assign) NSInteger vol;
@property (nonatomic, assign) NSInteger amp;
@property (nonatomic, assign) NSInteger temp;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger remain_cap;
@property (nonatomic, assign) NSInteger full_cap;
@property (nonatomic, assign) NSInteger cycles;
@property (nonatomic, assign) NSInteger max_chg_soc;
@property (nonatomic, copy)   NSString  *updatedAt;
@end

@interface EFBmsS : BaseModel
@property (nonatomic, assign) NSInteger ambientLightAnimate;
@property (nonatomic, assign) NSInteger ambientLightBrightness;
@property (nonatomic, assign) NSInteger ambientLightColor;
@property (nonatomic, assign) NSInteger ambientLightMode;
@property (nonatomic, assign) NSInteger amp;
@property (nonatomic, assign) NSInteger bms_fault;
@property (nonatomic, assign) NSInteger bq_sys_stat_reg;
@property (nonatomic, assign) NSInteger cycles;
@property (nonatomic, assign) NSInteger error_code;
@property (nonatomic, assign) NSInteger full_cap;
@property (nonatomic, assign) NSInteger max_cell_temp;
@property (nonatomic, assign) NSInteger max_cell_vol;
@property (nonatomic, assign) NSInteger max_mos_temp;
@property (nonatomic, assign) NSInteger min_cell_temp;
@property (nonatomic, assign) NSInteger min_cell_vol;
@property (nonatomic, assign) NSInteger min_mos_temp;
@property (nonatomic, assign) NSInteger remain_cap;
@property (nonatomic, assign) NSInteger soc;
@property (nonatomic, assign) NSInteger temp;
@property (nonatomic, assign) NSInteger vol;
@property (nonatomic, copy)   NSString  *sys_ver;
@property (nonatomic, copy)   NSString  *updatedAt;
@end

@interface EFInv : BaseModel
@property (nonatomic, assign) NSInteger error_code;
@property (nonatomic, assign) NSInteger sys_ver;
@property (nonatomic, assign) NSInteger charger_type;
@property (nonatomic, assign) NSInteger input_watts;
@property (nonatomic, assign) NSInteger output_watts;
@property (nonatomic, assign) NSInteger inv_type;
@property (nonatomic, assign) NSInteger inv_out_vol;
@property (nonatomic, assign) NSInteger inv_out_amp;
@property (nonatomic, assign) NSInteger inv_out_freq;
@property (nonatomic, assign) NSInteger inv_in_vol;
@property (nonatomic, assign) NSInteger inv_in_amp;
@property (nonatomic, assign) NSInteger inv_in_freq;
@property (nonatomic, assign) NSInteger out_temp;
@property (nonatomic, assign) NSInteger dc_in_vol;
@property (nonatomic, assign) NSInteger dc_in_amp;
@property (nonatomic, assign) NSInteger in_temp;
@property (nonatomic, assign) NSInteger fan_state;
@property (nonatomic, assign) NSInteger inv_switch;
@property (nonatomic, assign) NSInteger xboost;
@property (nonatomic, assign) NSInteger inv_cfg_out_vol;
@property (nonatomic, assign) NSInteger inv_cfg_out_freq;
@property (nonatomic, assign) NSInteger work_mode;
@property (nonatomic, copy)   NSString  *updatedAt;
@end

@interface EFPD : BaseModel
@property (nonatomic, assign) NSInteger model;
@property (nonatomic, assign) NSInteger error_code;
@property (nonatomic, assign) NSInteger sys_ver;
@property (nonatomic, assign) NSInteger soc_sum;
@property (nonatomic, assign) NSInteger watts_out_sum;
@property (nonatomic, assign) NSInteger watts_in_sum;
@property (nonatomic, assign) NSInteger remain_time;
@property (nonatomic, assign) NSInteger car_switch;
@property (nonatomic, assign) NSInteger led_state;
@property (nonatomic, assign) NSInteger beep;
@property (nonatomic, assign) NSInteger typec_watts;
@property (nonatomic, assign) NSInteger usb1_watts;
@property (nonatomic, assign) NSInteger usb2_watts;
@property (nonatomic, assign) NSInteger usb3_watts;
@property (nonatomic, assign) NSInteger car_watts;
@property (nonatomic, assign) NSInteger led_watts;
@property (nonatomic, assign) NSInteger typec_temp;
@property (nonatomic, assign) NSInteger car_temp;
@property (nonatomic, assign) NSInteger standby_mode;
@property (nonatomic, assign) NSInteger chgPowerDC;
@property (nonatomic, assign) NSInteger chgSunPower;
@property (nonatomic, assign) NSInteger chgPowerAC;
@property (nonatomic, assign) NSInteger dsgPowerDC;
@property (nonatomic, assign) NSInteger dsgPowerAC;
@property (nonatomic, assign) NSInteger usb_used_time;
@property (nonatomic, assign) NSInteger usbqc_used_time;
@property (nonatomic, assign) NSInteger typec_used_time;
@property (nonatomic, assign) NSInteger car_used_time;
@property (nonatomic, assign) NSInteger inv_used_time;
@property (nonatomic, assign) NSInteger dc_in_used_time;
@property (nonatomic, assign) NSInteger mppt_used_time;
@property (nonatomic, copy)   NSString  *updatedAt;
@end

NS_ASSUME_NONNULL_END
