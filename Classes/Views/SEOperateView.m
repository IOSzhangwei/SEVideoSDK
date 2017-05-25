//
//  SEOperateView.m
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SEOperateView.h"
#import "SEDefine.h"
#import "UIView+SE.h"
#import "UIImage+SE.h"
#define btnH 70
#define btnW 54
#define btnY (87-70)/2.f
@implementation SEOperateView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        //DeleteButtonStyleStickers
        _leftBtn = [SELeftButton buttonWithType:UIButtonTypeCustom] ;
        [_leftBtn setButtonStyle:SEDeleteButtonStyleStickers];
        _leftBtn.frame = CGRectMake(47, btnY, btnW, btnH);

        
        [_leftBtn addTarget:self action:@selector(leftBtnSender:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerBtn.frame = CGRectMake(0, 0, 87, 87);
        _centerBtn.centerX = self.centerX;
        [_centerBtn setImage:[UIImage se_imageName:@"iocn_play"] forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(centerBtnSender:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_centerBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];;
        _rightBtn.frame = CGRectMake(SEWIDTH - 47 -btnW , btnY, btnW, btnH);
        [_rightBtn setImage:[UIImage se_imageName:@"icon_upload"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnSender:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
    }
    return self;
}

-(void)leftBtnSender:(UIButton *)btn{
    if ([_operateViewDelegate respondsToSelector:@selector(leftBtnClick:)]) {
        [_operateViewDelegate leftBtnClick:btn];
    }
}
-(void)centerBtnSender:(UIButton *)btn{
    if ([_operateViewDelegate respondsToSelector:@selector(leftBtnClick:)]) {
        [_operateViewDelegate centerBtnClick:btn];
    }
}
-(void)rightBtnSender:(UIButton *)btn{
    if ([_operateViewDelegate respondsToSelector:@selector(leftBtnClick:)]) {
        [_operateViewDelegate rightBtnClick:btn];
    }
}


@end
