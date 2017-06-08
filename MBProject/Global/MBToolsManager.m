//
//  MBToolsManager.m
//  MBCategory
//
//  Created by yindongbo on 17/1/22.
//  Copyright © 2017年 Nxin. All rights reserved.
//

#import "MBToolsManager.h"
#import <CommonCrypto/CommonDigest.h>
@implementation MBToolsManager

+ (CGSize)getSizeOfTextInfo:(NSString *)textInfo andFontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    CGSize textSize = CGSizeZero;
    if (textInfo == nil)
    {
        return textSize;
    }
    
    NSAttributedString * attributeString = [[NSAttributedString alloc] initWithString:textInfo attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
    textSize= [attributeString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return textSize;
}

+ (CGSize)getSizeOfTextInfo:(NSString *)textInfo andFontSize:(CGFloat)fontSize andHeight:(CGFloat)height {
    CGSize size = CGSizeMake(CGFLOAT_MAX, height);
    CGRect rect = [textInfo boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName] context:Nil];
    return rect.size;
}


+ (NSString*) md5:(NSString*) str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if(widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageCompressForLength:(UIImage *)sourceImage targetLength:(NSInteger)length {
    NSData * sendImageData = UIImageJPEGRepresentation(sourceImage, 1.0);
    NSUInteger sizeOrigin = [sendImageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    
    if (sizeOriginKB > length)
    {
        float a = length;
        float b = (float)sizeOriginKB;
        float q = sqrtf(a / b);
        
        CGSize sizeImage = [sourceImage size];
        CGFloat widthSmall = sizeImage.width * q;
        CGFloat heighSmall = sizeImage.height * q;
        CGSize sizeImageSmall = CGSizeMake(widthSmall, heighSmall);
        
        UIGraphicsBeginImageContext(sizeImageSmall);
        CGRect smallImageRect = CGRectMake(0, 0, sizeImageSmall.width, sizeImageSmall.height);
        [sourceImage drawInRect:smallImageRect];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return smallImage;
    }
    return sourceImage;
}

//图片处理
+ (NSData *)setCTPickedImage:(UIImage *) image withSize:(CGSize ) size {
    UIImage *getImage=[MBToolsManager rotateImage:image];
    //float flag=getImage.size.width/getImage.size.height;
    // UIImage *smallImage=[self thumbnailOfImage:getImage withSize:CGSizeMake(size.width*flag,size.height)];
    UIImage *smallImage=[MBToolsManager thumbnailOfImage:getImage withSize:size];
    return UIImageJPEGRepresentation(smallImage,0.5);
}

+ (UIImage *)rotateImage:(UIImage *)aImage {
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    
    UIImageOrientation orient = aImage.imageOrientation;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage*)thumbnailOfImage:(UIImage*)image withSize:(CGSize)aSize {
    
    if (!image)
        return nil;
    
    CGImageRef imageRef = [image CGImage];
    UIImage *thumb = nil;
    
    float _width = CGImageGetWidth(imageRef);
    float _height = CGImageGetHeight(imageRef);
    
    float _resizeToWidth;
    float _resizeToHeight;
    _resizeToWidth = aSize.width;
    _resizeToHeight = aSize.height;
    float _moveX = 0.0f;
    float _moveY = 0.0f;
    
    if ( (_width > _resizeToWidth) || (_height > _resizeToHeight) )
    {
        float _amount = 0.0f;
        if (_width > _resizeToWidth)
        {
            _amount = _resizeToWidth / _width;
            _width *= _amount;
            _height *= _amount;
        }
        
        if (_height > _resizeToHeight)
        {
            _amount = _resizeToHeight / _height;
            _width *= _amount;
            _height *= _amount;
        }
    }
    
    _width = (NSInteger)_width;
    _height = (NSInteger)_height;
    _resizeToWidth = _width;
    _resizeToHeight = _height;
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                _resizeToWidth,
                                                _resizeToHeight,
                                                CGImageGetBitsPerComponent(imageRef),
                                                CGImageGetBitsPerPixel(imageRef)*_resizeToWidth,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef)
                                                );
    
    _moveX = (_resizeToWidth - _width) / 2;
    _moveY = (_resizeToHeight - _height) / 2;
    
    NSLog(@"_moveX=%f;_moveY=%f",_moveX,_moveY);
    CGContextSetRGBFillColor(bitmap, 1.f, 1.f, 1.f, 1.0f);
    CGContextDrawImage( bitmap, CGRectMake(_moveX, _moveY, _width, _height), imageRef );
    CGImageRef ref = CGBitmapContextCreateImage( bitmap );
    thumb = [UIImage imageWithCGImage:ref];
    CGContextRelease( bitmap );
    CGImageRelease( ref );
    return thumb;
}


+ (UIImage *)imageTransformWithData:(NSData *)imageData {
    if (imageData != nil)
    {
        return [UIImage imageWithData:imageData];
    }
    return nil;
}


+ (NSString *)digView:(UIView *)view {
    if ([view isKindOfClass:[UITableViewCell class]]) return @"";
    // 1.初始化
    NSMutableString *xml = [NSMutableString string];
    
    // 2.标签开头
    [xml appendFormat:@"<%@ frame=\"%@\"", view.class, NSStringFromCGRect(view.frame)];
    if (!CGPointEqualToPoint(view.bounds.origin, CGPointZero)) {
        [xml appendFormat:@" bounds=\"%@\"", NSStringFromCGRect(view.bounds)];
    }
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)view;
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, scroll.contentInset)) {
            [xml appendFormat:@" contentInset=\"%@\"", NSStringFromUIEdgeInsets(scroll.contentInset)];
        }
    }
    
    // 3.判断是否要结束
    if (view.subviews.count == 0) {
        [xml appendString:@" />"];
        return xml;
    } else {
        [xml appendString:@">"];
    }
    
    // 4.遍历所有的子控件
    for (UIView *child in view.subviews) {
        NSString *childXml = [self digView:child];
        [xml appendString:childXml];
    }
    
    // 5.标签结尾
    [xml appendFormat:@"</%@>", view.class];
    
    return xml;
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}
@end
