//
//  EBTextField.m
//  EBus
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBTextField.h"

@implementation EBTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15;
    return iconRect;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super editingRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super textRectForBounds:bounds];
    iconRect.origin.x += 5;
    return iconRect;

}
@end
