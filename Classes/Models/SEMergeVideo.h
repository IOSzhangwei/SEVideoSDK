//
//  SEMergeVideo.h
//  DevSESDK
//
//  Created by 张伟 on 17/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEMergeVideo : NSObject

- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray result:(void(^)(NSURL * filePath))rblock;

///随机生成一个视频存放地址
+(NSString *)getVideoPath;

@end
