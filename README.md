# SEVideoSDK
SEVideoSDK 为开发者提供短视频拍摄功能，支持断点续拍、美颜。

录制视频
====
在头部导入#import "SERecordViewController.h",#import "SEParameterModel.h"，创建实例，并设置代理。

```
SEParameterModel *model =[[SEParameterModel alloc] init];;
   model.enableBeauty = YES;
   model.cameraPosition = SESDKCameraPositionFront;
   model.minDuration = 3;
   model.maxDuration = 23;
   model.savePhotoAlbum=YES;
    
```
1.）可选设置需要在创建控制器前设置方可生效。如无需要，可以不用设置。目前支持的个性化设置如下：

```
@property (nonatomic, assign) BOOL      enableBeauty;                      /* 是否开启美颜效果，默认开启 */
@property(nonatomic,assign)SESDKCameraPosition secameraPosition;           /* 摄像头位置，默认为前摄像头 */
@property(nonatomic,assign)CGFloat minDuration;                            /* 最短录制时间  默认2s(0-10之间)*/
@property(nonatomic,assign)CGFloat maxDuration;                            /* 最长录制时间 默认15s(最长60)*/
@property(nonatomic,assign)BOOL savePhotoAlbum;                           /* 是否保存到相册 默认YES*/
```


2.)直接跳转控制器

```
SERecordViewController *s =[[SERecordViewController alloc] initWithParameter:model];
s.recordDelegate = self;
[self presentViewController:s animated:YES completion:nil];
```
3.）结束录制
录制完成会触发代理方法：
```
- (void)compeleteVideoPath:(NSURL *)videoPath thumbnailPath:(UIImage *)thumbnailPath savePhotoAlbum:(BOOL)save
```
其中，videoPath 为最终合成的视频地址 ，thumbnailImage为最终合成视频的缩略图 ，如果保存到相册save 为yes。

问题
====
如果你在使用过程中，出现了问题：
</br>请疯狂issue我
</br>也可以通过邮件： 18580228790@163.com 联系我

更新记录
=====
2017.05.24 ---bug：解决切换美颜之后，录制的偶尔崩溃问题。。 优化：增加切换摄像头高斯模糊，在切换瞬间无卡顿现象。

