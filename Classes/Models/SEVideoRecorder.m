//
//  SEVideoRecorder.m
//  DevSESDK
//
//  Created by 张伟 on 17/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SEVideoRecorder.h"
#import "SEDefine.h"
#import "GPUImage.h"
#import "GPUImageMovieComposition.h"
#import <Photos/Photos.h>
#import "GPUImageBeautifyFilter.h"
#import "SEMergeVideo.h"

#import "GPUImageGammaFilter.h"  
#import "GPUImageSepiaFilter.h"                     //褐色（怀旧）
@interface SEVideoRecorder ()<GPUImageVideoCameraDelegate,CAAnimationDelegate>


///视频写入
@property (nonatomic , strong) GPUImageMovieWriter *movieWriter;
///滤镜 输入设备
@property (nonatomic , strong) GPUImageOutput<GPUImageInput> *filter;
///显示的view
@property (nonatomic, strong) GPUImageView *filterView;

@property (nonatomic , strong) GPUImageUIElement *faceView;

@property (nonatomic , strong) GPUImageAddBlendFilter *blendFilter;

@property(nonatomic,strong)UIView *bgView;
/**
 是否暂停  yes：暂停
 */
@property(nonatomic,assign)BOOL paused;

//视频路径
@property(nonatomic,copy)NSString *pathStr;

///用于保存单个视频段
@property(nonatomic,strong)NSMutableArray *dataS;
///保存每个视频段录制的时间
@property(nonatomic,strong)NSMutableArray *timeDataS;
@property(nonatomic,strong)SEParameterModel *model;
//是否有美颜效果
@property(nonatomic)BOOL beauty;
@end


@implementation SEVideoRecorder

-(instancetype)initWithView:(UIView *)view parameter:(SEParameterModel *)model{
    if ([super init]) {
        _model = model;
        _beauty = _model.enableBeauty; //默认有美颜
        [self initSession:view];
    }
    
    return self;
}

-(void)initSession:(UIView *)view{
    _bgView = view;
    view.backgroundColor =[UIColor blackColor];
    _paused = YES;  //默认是暂停（未开始录制）
  //  _isFront = YES;  //默认为前摄像头
    AVCaptureDevicePosition ameraPosition;
    switch (_model.cameraPosition) {
        case SESDKCameraPositionFront:
            _isFront = YES;
            ameraPosition = AVCaptureDevicePositionFront;
            break;
        case SESDKCameraPositionBack:
            _isFront = NO;
            ameraPosition = AVCaptureDevicePositionBack;
            break;
            
        default:
            break;
    }
    
    _dataS = [NSMutableArray array];
    _timeDataS = [NSMutableArray array];
    
    self.faceView = [[GPUImageUIElement alloc] initWithView:view];
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:ameraPosition];
    self.videoCamera.delegate = self;
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    [self.videoCamera addAudioInputsAndOutputs];
    self.filterView = [[GPUImageView alloc] initWithFrame:view.frame];


    if (_model.enableBeauty) {
        _filter = [[GPUImageBeautifyFilter alloc] init];
        [_videoCamera addTarget:_filter];
        [_filter addTarget:_filterView];
        [self.videoCamera addAudioInputsAndOutputs];
    }else{
 
        [self.videoCamera addTarget:self.filterView];
    }
    
    [view insertSubview:_filterView atIndex:0];
    [self.videoCamera startCameraCapture];
    
    _pathStr =[SEMergeVideo getVideoPath];
    NSURL *movieURL = [NSURL fileURLWithPath:_pathStr];
    unlink([_pathStr UTF8String]);  // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(SEWIDTH, SEHEIGHT)];
        _movieWriter.encodingLiveVideo = YES;
        if (_model.enableBeauty) {
            [_filter addTarget:_movieWriter];
        }else{
            [self.videoCamera addTarget:_movieWriter];
        }
        [_videoCamera addAudioInputsAndOutputs];
        _movieWriter.shouldPassthroughAudio = YES;
        _videoCamera.audioEncodingTarget = _movieWriter;
        self.movieWriter.encodingLiveVideo = YES ;
    });
}




#pragma mark ---GPUImageVideoCameraDelegate---
-(void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    // NSLog(@"准备开始录制了。。");
    
}

-(void)cancelBeauty{
    _beauty = NO;
    [self.videoCamera removeAllTargets];
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera addTarget:_movieWriter];   //重要
}

-(void)startBeauty{
    _beauty = YES;
    [self.videoCamera removeAllTargets];
    _filter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:_filter];
    [_filter addTarget:_movieWriter];  //添加到写入文件中
    [_filter addTarget:_filterView];   //添加到显示view 中
}

-(void)FlashLight:(BOOL)isFlash{
    
    if (!isFlash) {  //开启
        [self.videoCamera.inputCamera lockForConfiguration:nil];
        [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
        [self.videoCamera.inputCamera unlockForConfiguration];

    }else{   //关闭
        
        [self.videoCamera.inputCamera lockForConfiguration:nil];
        [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
        [self.videoCamera.inputCamera unlockForConfiguration];

    }
   
}


#pragma mark - 切换动画
- (void)changeCameraAnimation {
    NSLog(@"转换摄像头");
    
    CATransition *changeAnimation = [CATransition animation];
    changeAnimation.delegate = self;
    changeAnimation.duration = 0.55;
    changeAnimation.type = @"oglFlip";
    changeAnimation.subtype = kCATransitionFromRight;

    changeAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.filterView.layer addAnimation:changeAnimation forKey:@"changeAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, SEWIDTH, SEHEIGHT);
    [_bgView addSubview:effectView];
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        effectView.alpha = 0;
    } completion:^(BOOL finished) {
        [_bgView willRemoveSubview:effectView];
    }];
    
    [self.videoCamera rotateCamera];
}

- (void)deleteLastVideo:(void(^)(CGFloat isDeleteTime))rblock{
    
    if (_dataS.count>0) {
        [_dataS removeLastObject];
        NSNumber *timeNumber = [_timeDataS lastObject];
        rblock([timeNumber floatValue]);
        [_timeDataS removeLastObject];
       
    }else{
      
    }
}

-(void)startVideoRecorder:(void(^)(BOOL isPaused))rblock{
    if (_paused) {
        _paused = NO;
        rblock(YES);
        [_movieWriter startRecording];

    }else{

        _paused = YES;
        rblock(NO);
        
        // 录制成功
        [_movieWriter finishRecording];
        [_dataS addObject:[NSURL fileURLWithPath:_pathStr]];
        //保存时长。
        [_timeDataS addObject:[NSNumber numberWithFloat:_videoDuration]];
       
        
        _pathStr = [SEMergeVideo getVideoPath];
        NSURL *movieURL = [NSURL fileURLWithPath:_pathStr];
        unlink([_pathStr UTF8String]);
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(SEWIDTH, SEHEIGHT)];
        if (_beauty) {
            //有美颜效果加载
            [_filter addTarget:_movieWriter];
        }else{
            
            [self.videoCamera addTarget:_filterView];
            [self.videoCamera addTarget:_movieWriter];
        }
        _movieWriter.encodingLiveVideo = YES;
        [_videoCamera addAudioInputsAndOutputs];
        _movieWriter.shouldPassthroughAudio = YES;
        _videoCamera.audioEncodingTarget = _movieWriter;
    }
}

-(BOOL)recordedFragments{
    if (_dataS.count>0) {
        return YES;
    }else{
        return NO;
    }
}

-(NSArray *)getMergeVideoFiles{
    return _dataS;
}

-(BOOL)cameraPermissions{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusDenied){
       

        return NO;
    }else{
        return YES;
    }
}

-(BOOL)cameraPhotoAlbum{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied || status ==PHAuthorizationStatusNotDetermined) {
        return NO;
    }else{
       return YES;
    }
    
}

-(BOOL)cameraMicrophone{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
   // CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0.2, 600)actualTime:NULL error:&thumbnailImageGenerationError];
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
    
}


@end
