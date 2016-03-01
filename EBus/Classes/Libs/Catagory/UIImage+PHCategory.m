//
//  UIImage+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UIImage+PHCategory.h"

@implementation UIImage (PHCategory)
+ (UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

/**
 *  @brief  将一个 CIImage 的图片 替换为指定大小 UIImage 的方法
 *
 *  @param image 需要替换的 CIImage 的实例
 *  @param size  指定的 宽/高
 *
 *  @return 返回得到的额 UIImage 的实例
 */
- (UIImage *)nonInouterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    //保存 bitmap 到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
/**
 *  @brief  生成一个 CIImage 的二维码
 *
 *  @param qrString 二维码包含的信息字符串
 *
 *  @return 返回创建的二维码
 */
- (CIImage *)creatQRForString:(NSString *)qrString {
    //需要将字符串转换为 NSdata
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    //创建 CIFilter 第一种创建方法 和后一种是等效的
#if 0
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator" keysAndValues:@"inputMessage",stringData,@"inputCorrectionLevel",@"M", nil];
#else
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //设置 要输出的 信息 即 设置 内容
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    //设置纠错级别
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
#endif
    CIImage *resoultImage = qrFilter.outputImage;
    return resoultImage;
}




@end
