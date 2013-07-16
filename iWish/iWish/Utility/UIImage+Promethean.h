//
//  UIImage+Promethean.h
//  ActivEngage2
//
//  Created by Suman Chatterjee on 06/12/2012.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Promethean)

-(UIImage *)padding:(CGRect)rect;

-(UIImage*)maskWithImage:(UIImage*)mask;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

+ (UIImage *)imageResize:(UIImage*) image withSize:(CGSize)size;

@end
