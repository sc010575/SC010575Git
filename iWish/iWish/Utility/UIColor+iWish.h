//
//  UIColor+iWish.h
//  iWish
//
//  Created by Suman Chatterjee on 07/05/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (iWish)

+ (UIColor*) fromHex:(int) hex;
+ (UIColor*) fromR:(int) r G:(int)g B:(int)b;
+ (NSString *) HexStringFromUIColor:(UIColor *)_color;
- (UIImage*)imageWithColor;
@end
