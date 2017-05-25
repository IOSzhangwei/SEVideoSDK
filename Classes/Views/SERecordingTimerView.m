//
//  SERecordingTimerView.m
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SERecordingTimerView.h"
static CGFloat _time;
static CGFloat _videoDuration;

@interface SERecordingTimerView ()

@property(nonatomic,strong)UIView *redView;

@property(nonatomic,strong)UILabel *timeLabel;

@end

@implementation SERecordingTimerView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame: frame]) {
        
        _redView =[[UIView alloc] initWithFrame:CGRectMake(30, 20, 10, 10)];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = 5.f;
        _redView.layer.masksToBounds = YES;

        [self addSubview:_redView];
        
        _timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 60, 30)];
        _timeLabel.text = @"0.0";
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        
        self.timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        
        
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 0.1 * NSEC_PER_SEC, 0);
        
        _time =0.0;
        dispatch_source_set_event_handler(self.timer, ^{
            
            _time = _time + 0.1;
            _times+=0.1;
            _timeLabel.text = [NSString stringWithFormat:@"%.1f",_times];
            _videoDuration +=0.1;
            if ([_recordTimeDelegate respondsToSelector:@selector(recordTimeDuration:totalDuration:)]) {
                [_recordTimeDelegate recordTimeDuration:_videoDuration totalDuration:_time];
            }
            
        });
        dispatch_suspend(_timer);
        
    }
    return self;
}

-(void)starRecording{
    dispatch_resume(self.timer);
    
    _videoDuration = 0;
    [_redView.layer addAnimation:[self opacityForever_Animation:0.4] forKey:nil];
}

-(void)pausedRecording{
    dispatch_suspend(_timer);
    _videoDuration = 0;
    [_redView.layer removeAllAnimations];
}

#pragma mark --- 闪烁动画 ---
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];    return animation;
    
}

@end
