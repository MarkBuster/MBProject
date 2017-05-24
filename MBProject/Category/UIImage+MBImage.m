//
//  UIImage+MBImage.m
//  MBProject
//
//  Created by yindongbo on 2017/4/6.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import "UIImage+MBImage.h"

@implementation UIImage (MBImage)

- (UIImage *)mb_imageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO,
                                           UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect
                                                cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
