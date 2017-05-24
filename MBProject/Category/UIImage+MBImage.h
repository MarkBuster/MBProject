//
//  UIImage+MBImage.h
//  MBProject
//
//  Created by yindongbo on 2017/4/6.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MBImage)

/** 给UIImage 添加生成圆角图片扩展的KPI */
- (UIImage *)mb_imageWithCornerRadius:(CGFloat)radius;
@end
