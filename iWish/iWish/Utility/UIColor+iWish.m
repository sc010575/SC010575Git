//
//  UIColor+iWish.m
//  iWish
//
//  Created by Suman Chatterjee on 07/05/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "UIColor+iWish.h"

@implementation UIColor (iWish)

+ (UIColor*) fromHex:(int) rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0f
                           green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0f
                            blue:((float)(rgbValue & 0xFF)) / 255.0f
                           alpha:1.0f];
}

+ (UIColor*) fromR:(int) r G:(int)g B:(int)b
{
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

- (UIImage*)imageWithColor
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (NSString *) HexStringFromUIColor:(UIColor *)_color
{
    if (CGColorGetNumberOfComponents(_color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(_color.CGColor);
        _color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(_color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(_color.CGColor))[0]*255.0), (int)((CGColorGetComponents(_color.CGColor))[1]*255.0), (int)((CGColorGetComponents(_color.CGColor))[2]*255.0)];
}


@end
