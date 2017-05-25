//
//  SERecordViewController.m
//  DevSESDK
//
//  Created by 张伟 on 17/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SERecordViewController.h"
#import "SEDefine.h"
#import "SEVideoRecorder.h"
#import "UIView+SE.h"
#import "UIImage+SE.h"
#import "SEMergeVideo.h"
#import <Photos/Photos.h>
//UI
#import "SEActionBarView.h"
#import "SEOperateView.h"
#import "SERecordingTimerView.h"
#import "SEProgressBarView.h"
#import "MBProgressHUD.h"
@interface SERecordViewController ()<OperateViewDelegate,RecordTimeDelegate>

@property(nonatomic,strong)SEVideoRecorder *videoRecorder;
//用来显示的view
@property(nonatomic,strong)UIView *showView;
//头部view
@property(nonatomic,strong)SEActionBarView *actionBarView;
///闪光灯按钮
@property(nonatomic,strong)UIButton *flashBtn;
///开关美颜
@property(nonatomic,strong)UIButton *beautifyBtn;
///录制操作view
@property(nonatomic,strong)SEOperateView *operateView;
///时间显示的view
@property(nonatomic,strong)SERecordingTimerView *rTimeView;
//进度条
@property(nonatomic,strong)SEProgressBarView *progressBarView;
///保存当前录制的视频时长
@property(nonatomic,assign)CGFloat videoDuration;
//参数model
@property(nonatomic,strong)SEParameterModel *model;
@end



@implementation SERecordViewController

-(instancetype)initWithParameter:(SEParameterModel *)model{
    if ([super init]) {
        
      _model = model;
      
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    [self initVideoRecorder];
    
    
}

-(void)setupUI{
    _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEWIDTH, SEHEIGHT)];
    _showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showView];
    
    _actionBarView = [[SEActionBarView alloc] initWithFrame:CGRectMake(0, 0, SEWIDTH, 60)];
    _actionBarView.backgroundColor = [UIColor clearColor];
    [_showView addSubview:_actionBarView];
    
    _flashBtn = [self.view viewWithTag:61];
    
    switch (_model.cameraPosition) {
        case SESDKCameraPositionFront:
            
            [_flashBtn setImage:[UIImage se_imageName:@"banFlash"] forState:UIControlStateNormal];
            _flashBtn.enabled = NO;
            break;
        case SESDKCameraPositionBack:
            [_flashBtn setImage:[UIImage se_imageName:@"cloneFlash"] forState:UIControlStateNormal];
            _flashBtn.enabled = YES;
            break;
        default:
            break;
    }

    
    _beautifyBtn = [self.view viewWithTag:60];
    self.beautifyBtn.selected = YES;  //默认选中美颜
    
    if (_model.enableBeauty) {
        self.beautifyBtn.selected = YES;  //默认选中美颜
        [_beautifyBtn setImage:[UIImage se_imageName:@"beautifulBtnS"] forState:UIControlStateNormal];
    }else{
        self.beautifyBtn.selected = NO;  //
        [_beautifyBtn setImage:[UIImage se_imageName:@"beautifulBtn"] forState:UIControlStateNormal];
    }
    
    
    _operateView = [[SEOperateView alloc] initWithFrame:CGRectMake(0, SEHEIGHT - 28 -87, SEWIDTH, 87)];
    _operateView.backgroundColor = [UIColor clearColor];
    _operateView.operateViewDelegate = self;
    [_showView addSubview:_operateView];
    
    _rTimeView=[[SERecordingTimerView alloc] initWithFrame:CGRectMake(30, 0,100 , 50)];
    _rTimeView.centerX = self.view.centerX;
    [_rTimeView starRecording];
    _rTimeView.hidden = YES;
    _rTimeView.recordTimeDelegate = self;
    [_showView addSubview:_rTimeView];
    
    _progressBarView = [[SEProgressBarView alloc] initWithFrame:CGRectMake(0, 0, SEWIDTH, 3)];
    [_showView addSubview:_progressBarView];
    [_progressBarView startShining];
}

-(void)initVideoRecorder{
    _videoRecorder = [[SEVideoRecorder alloc] initWithView:self.view parameter:_model];
}

#pragma mark ---- 录制过程中---
-(void)recordTimeDuration:(CGFloat)videoDuration totalDuration:(CGFloat)totalDuration{
    
    //    NSLog(@"当前录制的时长为===%f",videoDuration);
    //  NSLog(@"总长度为===%f",videoDuration/20.f*WIDTH);
    _videoDuration = videoDuration;
    [_progressBarView setLastProgressToWidth:videoDuration/_model.maxDuration*SEWIDTH];
  //  [_progressBarView setLastProgressToWidth:videoDuration/_model.maxDuration*WIDTH];
}

#pragma mark ---operateView Clicks---
-(void)leftBtnClick:(UIButton *)btn{
    //初始颜色为灰色 --动态贴纸
    //btn.backgroundColor = [UIColor grayColor];
    
    if (_operateView.leftBtn.style ==SEDeleteButtonStyleStickers) {
        NSLog(@"你点击的是贴纸");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"贴纸敬请期待。";
        [hud hide:YES afterDelay:2];
    }else if (_operateView.leftBtn.style ==SEDeleteButtonStyleNormal){ //第一次按下删除按钮
        //1.进度栏变色
        [_progressBarView setLastProgressToStyle:ProgressBarProgressStyleDelete];
        [_operateView.leftBtn setButtonStyle:SEDeleteButtonStyleDelete];
    }else if (_operateView.leftBtn.style ==SEDeleteButtonStyleDelete){  //第二次按下删除按钮
        //1. 删除数组里边的最后一个视频
       [self.videoRecorder deleteLastVideo:^(CGFloat isDeleteTime) {
            _rTimeView.times = _rTimeView.times - isDeleteTime;
       }];
        //2. 删除进度栏
        [_progressBarView deleteLastProgress];
        //3、对比时间是否低于最少时间
        if (_model.minDuration > _rTimeView.times) {
            //  NSLog(@"录制时间不足隐藏右边按钮");
            _operateView.rightBtn.hidden = YES;
        }else{
            _operateView.rightBtn.hidden = NO;
        }
        if ([self.videoRecorder recordedFragments]) {
            [_operateView.leftBtn setButtonStyle:SEDeleteButtonStyleNormal];
        }else{
            [_operateView.leftBtn setButtonStyle:SEDeleteButtonStyleStickers];
            _rTimeView.times = 0.0;
        }
    }

}

-(void)centerBtnClick:(UIButton *)btn{
    //  NSLog(@"中间按钮");
    //_model.minDuration
    
    self.videoRecorder.videoDuration = _videoDuration;    //考虑作为参数传进去，
    [self.videoRecorder startVideoRecorder:^(BOOL isPaused) {
        if (isPaused) {
            //更新其他按钮状态
           // _operateView.centerBtn.backgroundColor = [UIColor redColor]; //开始时候显示的颜色
            [_operateView.centerBtn setImage:[UIImage se_imageName:@"icon_pause"] forState:UIControlStateNormal];
            _actionBarView.hidden = YES;
             [_rTimeView starRecording]; _rTimeView.hidden = NO;
            _operateView.leftBtn.hidden = _operateView.rightBtn.hidden = YES;
            //进度条
            [_progressBarView addProgressView];
            [_progressBarView stopShining];
            _operateView.rightBtn.hidden = YES;
          //  NSLog(@"开始录制");
        }else{
            _operateView.leftBtn.hidden = _operateView.rightBtn.hidden = NO;
           // _operateView.centerBtn.backgroundColor = [UIColor yellowColor];   //暂停时候显示的颜色
            [_operateView.centerBtn setImage:[UIImage se_imageName:@"iocn_play"] forState:UIControlStateNormal];
            [_rTimeView pausedRecording]; _rTimeView.hidden = YES;
            _actionBarView.hidden = NO;
            _operateView.rightBtn.hidden = NO;
            [_progressBarView startShining];
           // NSLog(@"暂停录制");
            if (_model.minDuration > _rTimeView.times) {
               // NSLog(@"录制时间不足隐藏右边按钮");
                _operateView.rightBtn.hidden = YES;
            }else{
                _operateView.rightBtn.hidden = NO;
            }
        }
    }];
    
    
    //如果有录制内容， 动态贴纸变为删除标志  为黑色
    if ([self.videoRecorder recordedFragments]) {
        [_operateView.leftBtn setButtonStyle:SEDeleteButtonStyleNormal];
        [_operateView.rightBtn setImage:[UIImage se_imageName:@"icon_complete"] forState:UIControlStateNormal];
    }else{
        [_operateView.leftBtn setButtonStyle:SEDeleteButtonStyleStickers];
        [_operateView.rightBtn setImage:[UIImage se_imageName:@"icon_upload"] forState:UIControlStateNormal];
    }
}

-(void)rightBtnClick:(UIButton *)btn{
    if (_rTimeView.times !=0) {
       // NSLog(@"你点击的是上传");
//        if ([self.recordDelegate respondsToSelector:@selector(recordedSuccessfully)]) {
//            [_recordDelegate recordedSuccessfully];
//        }
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status ==PHAuthorizationStatusNotDetermined) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
            }];
            dispatch_source_t timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());;
            dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), 2.0 * NSEC_PER_SEC, 0);
            //要执行的时间
            dispatch_source_set_event_handler(timer, ^{
                PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
                if (status!=PHAuthorizationStatusNotDetermined) {
                    [self recorder];
                    dispatch_cancel(timer);
                }
            });
            dispatch_resume(timer);
            return;
        }
        [_videoRecorder.videoCamera stopCameraCapture];
        [self recorder];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"本地视频敬请期待。";
        [hud hide:YES afterDelay:2];
      //  NSLog(@"你点击的是打开本地视频");
    }
}

#pragma mark ---actionBarView Clicks---
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"closeBtnClick"]) {  //关闭
        [_videoRecorder.videoCamera stopCameraCapture];
         NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else{
            //present方式
            [self dismissViewControllerAnimated:YES completion:nil];
        }
       // [self.navigationController popViewControllerAnimated:YES];
    }else if ([eventName isEqualToString:@"moreBtnBtnClick"]){ //更多
      //  NSLog(@"更多");
    }else if ([eventName isEqualToString:@"skinCareClick"]){ //美颜
      //  NSLog(@"美颜");
        if (self.beautifyBtn.selected) {
            //取消美颜，背景色变橙色
            [self.videoRecorder cancelBeauty];
            [_beautifyBtn setImage:[UIImage se_imageName:@"beautifulBtn"] forState:UIControlStateNormal];
        }else{
            //开启美颜
            [self.videoRecorder startBeauty];
            [_beautifyBtn setImage:[UIImage se_imageName:@"beautifulBtnS"] forState:UIControlStateNormal];
        }
        self.beautifyBtn.selected = !self.beautifyBtn.selected;
    }else if ([eventName isEqualToString:@"flashClick"]){   //闪光灯
        if (self.videoRecorder.isFlash) { //开启
            [_flashBtn setImage:[UIImage se_imageName:@"cloneFlash"] forState:UIControlStateNormal];
        }else{ //关闭
            [_flashBtn setImage:[UIImage se_imageName:@"openFlash"] forState:UIControlStateNormal];
        }
        [self.videoRecorder FlashLight:self.videoRecorder.isFlash];
        self.videoRecorder.isFlash = !self.videoRecorder.isFlash;
    }else if ([eventName isEqualToString:@"cameraClick"]){ //转换摄像头
        if (self.videoRecorder.isFront) {
            _flashBtn.enabled = YES;
            [_flashBtn setImage:[UIImage se_imageName:@"cloneFlash"] forState:UIControlStateNormal];
        }else{
            [_flashBtn setImage:[UIImage se_imageName:@"banFlash"] forState:UIControlStateNormal];
            _flashBtn.enabled = NO;
        }
        [self.videoRecorder changeCameraAnimation];
        self.videoRecorder.isFront = !self.videoRecorder.isFront;
        self.videoRecorder.isFlash = NO; //转换摄像头需要更改闪光灯状态
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self permissions];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)showMessage:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *donAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        if ([str rangeOfString:@"你的相册权限没有打开"].location!=NSNotFound) {
            return ;
        }
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            //present方式
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    //[donAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alert addAction:donAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)permissions{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (![_videoRecorder cameraPermissions]) {
        [self showMessage:[NSString stringWithFormat:@"你的相机权限没有打开，无法拍摄视频。请打开“设置-隐私-相机”，找到“%@”后进行设置",app_Name]];
        
    }else if(![_videoRecorder cameraMicrophone]){
        [self showMessage:[NSString stringWithFormat:@"你的麦克风权限没有打开，无法录制视频声音。请打开“设置-隐私-相机”，找到“%@”后进行设置",app_Name]];
    }
    if (![_videoRecorder cameraPhotoAlbum]) {
        
       
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)recorder{
   
    
    BOOL save;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"处理中。";
    if (![_videoRecorder cameraPhotoAlbum]) {
        save = NO;
    }else{
        save = YES;
    }
    
    SEMergeVideo *m = [SEMergeVideo new];
    [m mergeAndExportVideosAtFileURLs:[self.videoRecorder getMergeVideoFiles] result:^(NSURL *filePath) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (_model.savePhotoAlbum) {
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:filePath];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"处理完成！";
                    [hud hide:YES afterDelay:2];
                    UIImage *img= [_videoRecorder thumbnailImageForVideo:filePath atTime:1];
                    if ([_recordDelegate respondsToSelector:@selector(compeleteVideoPath:thumbnailPath:savePhotoAlbum:)]) {
                        [_recordDelegate compeleteVideoPath:filePath thumbnailPath:img savePhotoAlbum:save];
                    }
                });
            }];
        }else{
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"处理完成！";
            [hud hide:YES afterDelay:2];
             UIImage *img= [_videoRecorder thumbnailImageForVideo:filePath atTime:1];
            if ([_recordDelegate respondsToSelector:@selector(compeleteVideoPath:thumbnailPath:savePhotoAlbum:)]) {
                [_recordDelegate compeleteVideoPath:filePath thumbnailPath:img savePhotoAlbum:NO];
            }
        }
        
    }];
}

@end
