//
//  SELeftButton.h
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SEDeleteButtonStyleDelete,
    SEDeleteButtonStyleNormal,
    SEDeleteButtonStyleStickers,
}SEDeleteButtonStyle;

@interface SELeftButton : UIButton{
   
}


@property (assign, nonatomic) SEDeleteButtonStyle style;

- (void)setButtonStyle:(SEDeleteButtonStyle)style;
@end
