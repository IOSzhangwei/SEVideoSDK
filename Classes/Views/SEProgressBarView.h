//
//  SEProgressBarView.h
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ProgressBarProgressStyleNormal,
    ProgressBarProgressStyleDelete,
} ProgressBarProgressStyle;
@interface SEProgressBarView : UIView
- (void)setLastProgressToStyle:(ProgressBarProgressStyle)style;
- (void)setLastProgressToWidth:(CGFloat)width;

- (void)deleteLastProgress;
- (void)addProgressView;

- (void)stopShining;
- (void)startShining;
@end
