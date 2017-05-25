//
//  UIImage+SE.m
//  DevSESDK
//
//  Created by lskt on 2017/5/18.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "UIImage+SE.h"

@implementation UIImage (SE)
+(UIImage *)se_imageName:(NSString *)img{
    
    //NSString * bundlePath = [[ NSBundle mainBundle] pathForResource:@"SESDK" ofType :@"bundle"];
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"SESDK.bundle/%@",img]];
    
}
@end
