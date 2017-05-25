//
//  SERecordingTimerView.h
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RecordTimeDelegate <NSObject>

-(void)recordTimeDuration:(CGFloat)videoDuration totalDuration:(CGFloat)totalDuration;

@end
@interface SERecordingTimerView : UIView
@property (nonatomic, strong) dispatch_source_t timer;
-(void)starRecording;

-(void)pausedRecording;

@property(nonatomic,assign)CGFloat times;

@property(nonatomic,assign)id<RecordTimeDelegate> recordTimeDelegate;
@end
