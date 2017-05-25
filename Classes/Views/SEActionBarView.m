//
//  SEActionBarView.m
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SEActionBarView.h"
#import "UIResponder+SERouter.h"
#import "SEDefine.h"
#import "UIImage+SE.h"
#define top 15 //距离头部距离
#define margin 10 //关闭按钮和更多按钮的 边距
#define btnWidth 25 //按钮宽
#define btnHeight 25  //按钮高

@implementation SEActionBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if ( [super initWithFrame:frame]) {
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(margin, top, btnWidth, btnHeight);
        [closeBtn setImage:[UIImage se_imageName:@"cloneBtn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(SEWIDTH - margin - btnWidth, top, btnWidth, btnHeight);
        [moreBtn setImage:[UIImage se_imageName:@"more"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        
        CGFloat viewWidth = SEWIDTH - 2 * (btnWidth + margin);
        CGFloat btnMargin = (viewWidth - btnWidth *3)/4.f;
        for (int i = 0 ; i<3; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnMargin *(i+1)+ btnWidth * i +(btnWidth+ margin), top, btnWidth, btnHeight);
            btn.tag = 60 + i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        
        UIButton *btn = [self viewWithTag:62];
        [btn setImage:[UIImage se_imageName:@"reverseCamera"] forState:UIControlStateNormal];
        
    }
    return self;
}

-(void)closeBtnClick{
    [self routerEventWithName:@"closeBtnClick" userInfo:nil];
}

-(void)moreBtnBtnClick{
    [self routerEventWithName:@"moreBtnBtnClick" userInfo:nil];
}

-(void)btnClick:(UIButton *)btn{
    NSDictionary *dic = @{@"btn":btn};
    
    switch (btn.tag) {
        case 60:{
            [self routerEventWithName:@"skinCareClick" userInfo:dic];
        }
            break;
        case 61:{
            [self routerEventWithName:@"flashClick" userInfo:dic];
        }
            break;
        case 62:{
            [self routerEventWithName:@"cameraClick" userInfo:dic];
        }
            break;
            
        default:
            break;
    }
    
}

@end
