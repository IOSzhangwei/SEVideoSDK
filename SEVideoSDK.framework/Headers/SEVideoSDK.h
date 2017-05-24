//
//  SEVideoSDK.h
//  DevSESDK
//
//  Created by lskt on 2017/5/17.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<UIKit/UIKit.h>

@protocol SESDKDelegate <NSObject>

/**
 * @param videoPath      保存拍摄好视频的存储路径
 * @param thumbnailImage  保存拍摄好视频首侦图的存储路径
 * @param save             是否保存到相册
 */
- (void)SESDK:(id<SESDKDelegate>)sdk compeleteVideoPath:(NSURL *)videoPath thumbnailImage:(UIImage *)thumbnailImage savePhotoAlbum:(BOOL)save;

@end

typedef NS_ENUM(NSInteger,SESDKCameraPosition){
    SESDKCameraPositionFront,  // 摄像头方向
    SESDKCameraPositionBack,
    
};
@interface SEVideoSDK : NSObject

+ (instancetype)shared;

@property (nonatomic, weak) id<SESDKDelegate> delegte;
@property (nonatomic, assign) BOOL      enableBeauty;                      /* 是否开启美颜效果，默认开启 */
@property(nonatomic,assign)SESDKCameraPosition secameraPosition;           /* 摄像头位置，默认为前摄像头 */
@property(nonatomic,assign)CGFloat minDuration;                            /* 最短录制时间  默认2s(0-10之间)*/
@property(nonatomic,assign)CGFloat maxDuration;                            /* 最长录制时间 默认15s(最长60)*/
@property(nonatomic,assign)BOOL savePhotoAlbum;                           /* 是否保存到相册 默认YES*/
/**
 创建录制页面，需要以 UINavigationController 为父容器

 @param bitRate 视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率
 */
- (UIViewController *)createRecordViewControllerWithbitRate:(CGFloat)bitRate;

@end
