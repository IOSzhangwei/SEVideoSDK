//
//  ViewController.m
//  ssss
//
//  Created by lskt on 2017/5/18.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "ViewController.h"
#import <SEVideoSDK/SEVideoSDK.h>
@interface ViewController (){
    UIViewController *v;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)sender:(id)sender {
    
    SEVideoSDK *sdk = [SEVideoSDK shared];
    sdk.delegte = (id<SESDKDelegate>) self;
    sdk.enableBeauty = YES;
    sdk.secameraPosition = SESDKCameraPositionFront;
    sdk.minDuration = 3;
    sdk.maxDuration = 23;
    sdk.savePhotoAlbum=YES;
    
    
    v= [sdk createRecordViewControllerWithbitRate:6];
    [self presentViewController:v animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SESDK:(id<SESDKDelegate>)sdk compeleteVideoPath:(NSURL *)videoPath thumbnailImage:(UIImage *)thumbnailImage savePhotoAlbum:(BOOL)save{
    //  [v.navigationController popViewControllerAnimated:YES];
    [v dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"视频保存的路径为====%@",videoPath);
    //   imgView.image = thumbnailImage;
}

@end
