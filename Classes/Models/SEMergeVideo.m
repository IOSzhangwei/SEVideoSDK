 //
//  SEMergeVideo.m
//  DevSESDK
//
//  Created by 张伟 on 17/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SEMergeVideo.h"
#import <AVFoundation/AVFoundation.h>
#define Video_PATH [NSString stringWithFormat:@"%@/tmp/videos",NSHomeDirectory()] //视频存储路径
@implementation SEMergeVideo
- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray result:(void(^)(NSURL *filePath))rblock{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        
        CGSize renderSize = CGSizeMake(0, 0);
        
        NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
        
        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        
        CMTime totalDuration = kCMTimeZero;
        
        //先去assetTrack 也为了取renderSize
        NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
        NSMutableArray *assetArray = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileURLArray) {
            AVAsset *asset = [AVAsset assetWithURL:fileURL];
            
            if (!asset) {
                continue;
            }
            
            [assetArray addObject:asset];
            
            AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            [assetTrackArray addObject:assetTrack];
            
            renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
            renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
        }
        
        CGFloat renderW = MIN(renderSize.width, renderSize.height);
        
        for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
            
            
            
            AVAsset *asset = [assetArray objectAtIndex:i];
            AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
            AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                 atTime:totalDuration
                                  error:nil];

            
            AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetTrack
                                 atTime:totalDuration
                                  error:&error];
            
            //fix orientationissue
            AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            totalDuration = CMTimeAdd(totalDuration, asset.duration);
            
            CGFloat rate;
            rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
            
            CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
            //裁剪地方。
            //            layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
            layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
            
            [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
            [layerInstruciton setOpacity:0.0 atTime:totalDuration];
            
            //data
            [layerInstructionArray addObject:layerInstruciton];
        }
        
        //get save path
        NSURL *mergeFileURL = [NSURL fileURLWithPath:[self getVideoPath]];
        
        //export
        AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
        mainInstruciton.layerInstructions = layerInstructionArray;
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = @[mainInstruciton];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(320, 568);
        
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
        exporter.videoComposition = mainCompositionInst;
        exporter.outputURL = mergeFileURL;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            
          //  fileURLArray
            NSFileManager *manager = [NSFileManager defaultManager];
            for (NSURL *filePath in fileURLArray) {
                NSString *path = [NSString stringWithFormat:@"%@",filePath];
                NSRange range = [path rangeOfString:@"videos/"];
                
                path = [path substringFromIndex:range.location + 7];
                
                BOOL isVideo = [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",Video_PATH,path] error:nil];
                if (isVideo) {
                 //   NSLog(@"删除视频成功==%@",path);
                }else {
                  //  NSLog(@"删除视频失败");
                }
            }
            if ([manager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",Video_PATH,[self getVideoFileName:mergeFileURL]]]) {
                ;
              //  NSLog(@"合成视频大小为===%f",[[manager attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",Video_PATH,[self getVideoFileName:mergeFileURL]] error:nil] fileSize]/(1024.0*1024.0));
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                rblock(mergeFileURL);
            });
        }];
    });
    
}

-(NSString *)getVideoFileName:(NSURL *)file{
    
    NSString *path = [NSString stringWithFormat:@"%@",file];
    NSRange range = [path rangeOfString:@"videos/"];
    path = [path substringFromIndex:range.location + 7];
    return path;
}

-(NSString *)getVideoPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:Video_PATH];
    if (isExist) {
    }else {
        // 如果不存在就创建文件夹
        [fileManager createDirectoryAtPath:Video_PATH withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    ;
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",timeStr,@"mp4"];
    
    return [NSString stringWithFormat:@"%@/%@",Video_PATH,fileName];
}

+(NSString *)getVideoPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:Video_PATH];
    if (isExist) {
    }else {
        // 如果不存在就创建文件夹
        [fileManager createDirectoryAtPath:Video_PATH withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    ;
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",timeStr,@"mp4"];
    
    return [NSString stringWithFormat:@"%@/%@",Video_PATH,fileName];
}

@end
