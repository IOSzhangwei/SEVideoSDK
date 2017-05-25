//
//  SEParameterModel.m
//  DevSESDK
//
//  Created by lskt on 2017/5/17.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SEParameterModel.h"

@implementation SEParameterModel

-(instancetype)init{
    if ([super init]) {  //配置默认参数
        self.enableBeauty = YES;
        self.cameraPosition = SESDKCameraPositionFront;
        self.minDuration = 2;
        self.maxDuration = 15;
        self.savePhotoAlbum = YES;
    }
    return self;
}

@end
