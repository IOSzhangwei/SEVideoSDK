//
//  SERecordViewController.h
//  DevSESDK
//
//  Created by 张伟 on 17/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEParameterModel.h"

@protocol SERecordDelegate <NSObject>
/**
 * @param videoPath      保存拍摄好视频的存储路径
 * @param thumbnailPath  保存拍摄好视频首侦图的存储路径
 */
- (void)compeleteVideoPath:(NSURL *)videoPath thumbnailPath:(UIImage *)thumbnailPath savePhotoAlbum:(BOOL)save;

@end

@interface SERecordViewController : UIViewController



-(instancetype)initWithParameter:(SEParameterModel *)model;

@property(nonatomic,assign)id<SERecordDelegate> recordDelegate;

@end
