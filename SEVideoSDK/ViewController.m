//
//  ViewController.m
//  ssss
//
//  Created by lskt on 2017/5/18.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "ViewController.h"
#import "SERecordViewController.h"
#import "SEParameterModel.h"
@interface ViewController ()<SERecordDelegate>{
   
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)sender:(id)sender {
    
   SEParameterModel *model =[[SEParameterModel alloc] init];;
   model.enableBeauty = YES;
   model.cameraPosition = SESDKCameraPositionFront;
   model.minDuration = 3;
   model.maxDuration = 23;
   model.savePhotoAlbum=YES;
    
    SERecordViewController *s =[[SERecordViewController alloc] initWithParameter:model];
    s.recordDelegate = self;
   [self presentViewController:s animated:YES completion:nil];
    
}


- (void)compeleteVideoPath:(NSURL *)videoPath thumbnailPath:(UIImage *)thumbnailPath savePhotoAlbum:(BOOL)save{
    NSLog(@"保存的视频路径为====%@",videoPath);
}



@end
