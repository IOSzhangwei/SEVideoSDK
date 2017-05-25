//
//  SEOperateView.h
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SELeftButton.h"
@protocol OperateViewDelegate <NSObject>

-(void)leftBtnClick:(UIButton *)btn;
-(void)centerBtnClick:(UIButton *)btn;
-(void)rightBtnClick:(UIButton *)btn;
@end

@interface SEOperateView : UIView

@property(nonatomic,strong)SELeftButton *leftBtn;

@property(nonatomic,strong)UIButton *centerBtn;

@property(nonatomic,strong)UIButton *rightBtn;

@property(nonatomic,assign)id<OperateViewDelegate> operateViewDelegate;

@end
