//
//  UIImage+PHCategory.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PHCategory)
+ (UIImage *)resizedImageWithName:(NSString *)name;


- (UIImage *)nonInouterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGFloat)size;
- (CIImage *)creatQRForString:(NSString *)qrString;
@end
