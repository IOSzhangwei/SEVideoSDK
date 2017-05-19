# SEVideoSDK
SEVideoSDK 为开发者提供短视频拍摄功能，支持断点续拍、美颜。

环境搭建
-----
下载SEVideoSDK demo在文件夹下找到以下框架：
  SEVideoSDK.framework
  SESDK.bundle

集成SDK
-----
  1.将 SEVideoSDK.framework 和 SESDK.bundle 拖拽到自己的Xcode项目中。  
  2.打开项目的 app target，查看 Build Settings 中的 Linking – Other Linker Flags 选项，确保含有 -ObjC 一值，若没有则添加。  
  3.Build Settings 搜索 bitcode ，将Enable Bitcode 设置为NO  
  4.模拟器无法运行  
  
2、录制视频
------
在头部导入#import <QPSDK/QPSDK.h>，创建趣拍SDK实例，并设置代理。
