//
//  MBToolsManager.h
//  MBCategory
//
//  Created by yindongbo on 17/1/22.
//  Copyright © 2017年 Nxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MBToolsManager : NSObject


/**
 abstact:根据文本内容获取其显示大小
 textInfo:文本内容
 fontSize:字体大小
 width:所在view的宽度
 */
+ (CGSize)getSizeOfTextInfo:(NSString *)textInfo andFontSize:(CGFloat)fontSize andWidth:(CGFloat)width;

/*!
 @function getSizeOfTextInfo:andFontSize:andHeight:
 @abstract 计算固定高度显示文字的宽度
 @param (NSString*)textInfo: 文字信息
 @param (CGFloat)fontSize: 字体大小
 @param (CGFloat)height: 显示字体控件高度
 @return 显示字体控件的Size
 */		
+ (CGSize)getSizeOfTextInfo:(NSString *)textInfo andFontSize:(CGFloat)fontSize andHeight:(CGFloat)height;

/*
 MD5 加密
 */
+ (NSString*)md5:(NSString*) str;


/**
 图片旋转按照指定方向
 */
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;


/**
 等比例压缩算法
 */
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 制定图片大小压缩
 */
+ (UIImage *)imageCompressForLength:(UIImage *)sourceImage targetLength:(NSInteger)length;

//图片处理
+ (NSData *)setCTPickedImage:(UIImage *) image withSize:(CGSize ) size;

/*! 将NSData转化为图片 */
+ (UIImage *)imageTransformWithData:(NSData *)imageData;


/**
 * 返回传入veiw的所有层级结构
 * @param view 需要获取层级结构的view
 * @return 字符串
 */
+ (NSString *)digView:(UIView *)view;

/* 随机颜色 **/
+ (UIColor *)randomColor;
@end
