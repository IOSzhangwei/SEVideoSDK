# SEVideoSDK
SEVideoSDK 为开发者提供短视频拍摄功能，支持断点续拍、美颜。

环境搭建
====
下载SEVideoSDK demo在文件夹下找到以下框架：
  </br>SEVideoSDK.framework
  </br>SESDK.bundle

集成SDK
====
  1.将 SEVideoSDK.framework 和 SESDK.bundle 拖拽到自己的Xcode项目中。  
  2.打开项目的 app target，查看 Build Settings 中的 Linking – Other Linker Flags 选项，确保含有 -ObjC 一值，若没有则添加。  
  3.Build Settings 搜索 bitcode ，将Enable Bitcode 设置为NO  
  4.模拟器无法运行  
  
录制视频
====
在头部导入#import <SEVideoSDK/SEVideoSDK.h>，创建SDK实例，并设置代理。

```
SEVideoSDK *sdk = [SEVideoSDK shared];
sdk.delegte = (id<SESDKDelegate>) self;
```
1.）可选设置需要在创建控制器前设置方可生效。如无需要，可以不用设置。目前支持的个性化设置如下：

```
@property (nonatomic, assign) BOOL      enableBeauty;                      /* 是否开启美颜效果，默认开启 */
@property(nonatomic,assign)SESDKCameraPosition secameraPosition;           /* 摄像头位置，默认为前摄像头 */
@property(nonatomic,assign)CGFloat minDuration;                            /* 最短录制时间  默认2s(0-10之间)*/
@property(nonatomic,assign)CGFloat maxDuration;                            /* 最长录制时间 默认15s(最长60)*/
@property(nonatomic,assign)BOOL savePhotoAlbum;                           /* 是否保存到相册 默认YES*/
```
2.）创建控制器
```
/**
 创建录制页面，需要以 UINavigationController 为父容器

 @param bitRate 视频码率，建议800*1000-5000*1000,码率越大，视频越清析，视频文件也会越大。参考：8秒的视频以2000*1000的码率压缩，文件大小1.5M-2M。请开发者根据自己的业务场景设置时长和码率
 */
- (UIViewController *)createRecordViewControllerWithbitRate:(CGFloat)bitRate;
```

直接跳转控制器

```
UIViewController * sdk= [sdk createRecordViewControllerWithbitRate:6];
 [self presentViewController:sdk animated:YES completion:nil];
```
3.）结束录制
录制完成会触发代理方法：
```
- (void)SESDK:(id<SESDKDelegate>)sdk compeleteVideoPath:(NSURL *)videoPath thumbnailImage:(UIImage *)thumbnailImage savePhotoAlbum:(BOOL)save
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

