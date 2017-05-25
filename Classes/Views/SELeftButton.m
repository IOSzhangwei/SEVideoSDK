//
//  SELeftButton.m
//  DevSESDK
//
//  Created by lskt on 2017/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "SELeftButton.h"
#import "UIImage+SE.h"
#import "UIView+SE.h"
#define DELETE_BTN_NORMAL_IAMGE @"record_delete_normal.png"
#define DELETE_BTN_DELETE_IAMGE @"record_deletesure_normal.png"
#define DELETE_BTN_DISABLE_IMAGE @"record_delete_disable.png"
@implementation SELeftButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize
{

    [self setImage:[UIImage se_imageName:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
    [self setImage:[UIImage se_imageName:DELETE_BTN_DISABLE_IMAGE] forState:UIControlStateDisabled];
}

- (void)setButtonStyle:(SEDeleteButtonStyle)style
{
    self.style = style;
    switch (style) {
        case SEDeleteButtonStyleNormal:
        {
            self.enabled = YES;
            [self setImage:[UIImage se_imageName:@"icon_call-off"] forState:UIControlStateNormal];
        }
            break;
        case SEDeleteButtonStyleStickers:
        {
            [self setImage:[UIImage se_imageName:@"icon_call-off_Cant-choose"] forState:UIControlStateNormal];
            self.enabled = NO;
        }
            break;
        case SEDeleteButtonStyleDelete:
        {
            self.enabled = YES;
            [self setImage:[UIImage se_imageName:@"icon_delete"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

@end
