//
//  HYUploadModel.h
//  EcoFlow
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYUploadModel : NSObject
/**0 图片 1gif图 2音频 3视频*/
@property (nonatomic, assign) NSInteger type;
/**数据流*/
@property (nonatomic, strong) NSData *data;
/**image数组*/
@property (nonatomic, strong) NSArray<UIImage *> *images;
@end

NS_ASSUME_NONNULL_END
