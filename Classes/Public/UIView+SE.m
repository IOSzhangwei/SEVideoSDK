//
//  UIView+SE.m
//  DevSESDK
//
//  Created by 张伟 on 17/5/15.
//  Copyright © 2017年 ZWSE. All rights reserved.
//

#import "UIView+SE.h"

@implementation UIView (SE)
- (CGPoint) origin {
    return self.frame.origin;
}

- (void) setOrigin:(CGPoint) point {
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize) size {
    return self.frame.size;
}

- (void) setSize:(CGSize) size {
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat) x {
    return self.frame.origin.x;
}

- (void) setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat) y {
    return self.frame.origin.y;
}
- (void) setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat) height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)tail {
    return self.y + self.height;
}

- (void)setTail:(CGFloat)tail {
    self.frame = CGRectMake(self.x, tail - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.tail;
}

- (void)setBottom:(CGFloat)bottom {
    [self setTail:bottom];
}

- (CGFloat)right {
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

+(UIImage *)se_imageName:(NSString *)img{
   return [UIImage imageNamed:[NSString stringWithFormat:@"SESDK.bundle/%@",img]];
}

@end
