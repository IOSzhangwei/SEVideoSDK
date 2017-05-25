//
//  SEParameterModel.h
//  DevSESDK
//
//  Created by lskt on 2017/5/17.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SESDKCameraPosition){
    SESDKCameraPositionFront,  // 摄像头方向
    SESDKCameraPositionBack,
    
};
@interface SEParameterModel : NSObject


@property (nonatomic, assign) BOOL      enableBeauty;                       /* 是否开启美颜效果，默认开启 */
@property(nonatomic,assign)SESDKCameraPosition cameraPosition;           /* 摄像头位置，默认为前摄像头 */
@property(nonatomic,assign)CGFloat minDuration;                            /* 最短录制时间 */
@property(nonatomic,assign)CGFloat maxDuration;                            /* 最长录制时间 */
@property(nonatomic,assign)BOOL savePhotoAlbum;                           /* 是否保存到相册 默认YES*/


//@property (nonatomic, assign) BOOL      enableImport;                       /* 是否开启导入 */
//@property (nonatomic, assign) BOOL      enableMoreMusic;                    /* 是否添加更多音乐按钮 */
//@property (nonatomic, assign) BOOL      enableVideoEffect;                  /* 是否开启视频编辑页面 */
//@property (nonatomic, assign) BOOL      enableWatermark;                    /* 是否开启水印图片 */
//@property (nonatomic, assign) BOOL      enableGuide;                        /* 是否开启引导 */
//@property (nonatomic, assign) CGFloat   thumbnailCompressionQuality;        /* 首帧图图片质量:压缩质量 0-1 */
//@property (nonatomic, strong) UIColor   *tintColor;                         /* 颜色 */
//@property (nonatomic, strong) UIImage   *watermarkImage;                    /* 水印图片 */

-(instancetype)init;

@end
