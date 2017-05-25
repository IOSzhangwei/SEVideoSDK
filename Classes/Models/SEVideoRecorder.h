//
//  SEVideoRecorder.h
//  DevSESDK
//
//  Created by 张伟 on 17/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "SEParameterModel.h"
@interface SEVideoRecorder : NSObject
///视频输入设备
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
///是否开启闪光灯 默认关闭
@property(nonatomic)BOOL isFlash;
///切换前后摄像头，默认打开为前摄像头
@property(nonatomic)BOOL isFront;

///保存当前录制的视频时长
@property(nonatomic,assign)CGFloat videoDuration;

-(instancetype)initWithView:(UIView *)view parameter:(SEParameterModel *)model;

//开始录制
-(void)startVideoRecorder:(void(^)(BOOL isPaused))rblock;

//取消美颜
-(void)cancelBeauty;
-(void)startBeauty;

//切换摄像头
- (void)changeCameraAnimation;
//开关闪光灯
-(void)FlashLight:(BOOL)isFlash;

///删除最后一个视频 .删除成功会回调删除视频段的时间
- (void)deleteLastVideo:(void(^)(CGFloat isDeleteTime))rblock;

//是否有录制片段
-(BOOL)recordedFragments;

//获取视频段落
-(NSArray *)getMergeVideoFiles;

-(BOOL)cameraPermissions;

-(BOOL)cameraMicrophone;

-(BOOL)cameraPhotoAlbum;
- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
