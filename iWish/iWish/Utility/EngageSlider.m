//
//  UiSlider+EngageSlider.m
//  ActivEngage2
//
//  Created by Suman Chatterjee on 21/11/2012.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import "EngageSlider.h"
#import "NSString+Promethean.h"
#import "UIImage+Promethean.h"

@interface EngageSlider()

 -(UIImage *)addText:(UIImage *)img text:(NSString *)text1 withSize:(CGFloat) textSize;
 -(void) makeSliderTransparent;


@end


@implementation EngageSlider 


-(void)initEngageSlider:(BOOL) Transparent withBlock:(SliderUpdateBlock) sliderupdateblock
{

          int SliderValue = roundf(self.value);
          self.backgroundColor = [UIColor clearColor];
          [self setValue:SliderValue];
          self.updateblock = sliderupdateblock;
          if(Transparent)
              [self makeSliderTransparent];
          if([NSString isBaseRTL])
                self.transform = CGAffineTransformRotate(self.transform, 180.0/180*M_PI);

}


-(void)valueChanged
{
    int SliderValue = roundf(self.value);
    [self setValue:SliderValue];
    UIImage * Thumb = [self thumbImageForState:UIControlStateReserved];
    [self setThumbImageForSlider:Thumb withvalue:[NSString stringWithFormat: @"%d", SliderValue] size:Thumb.size];
}


-(void) setThumbImageForSlider:(UIImage*)thumb withvalue:(NSString *)value size:(CGSize)imageSize
{
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [thumb drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGFloat TextSize = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)?20:60;

    UIImage *imageWithText = [self addText:newImage text:value withSize:TextSize];
    
    if([NSString isBaseRTL])
    {
        imageWithText= [imageWithText imageRotatedByDegrees:180] ;
    }
    
    [self setThumbImage: imageWithText forState:UIControlStateNormal];
    [self setThumbImage: imageWithText forState:UIControlStateHighlighted];
    [self setThumbImage: imageWithText forState:UIControlStateSelected];
    

}

-(CGSize)getThumbnilImageSize
{
    UIImage * Thumb = [self thumbImageForState:UIControlStateReserved];
    return Thumb.size;
}

/* Creates an image with a home-grown graphics context, burns the supplied string into it. 
   Need to remove the hardcoded values .. 
 */
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1 withSize:(CGFloat) textSize
{
    if (!img) return nil;
    
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    
    CGFloat xCordTextAtPointOffset;
    CGFloat yCordTextAtPointOffset;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        xCordTextAtPointOffset = 6;
        yCordTextAtPointOffset = w/2 - 6;
        
    }
    else
    {
        xCordTextAtPointOffset = 18;
        yCordTextAtPointOffset = w / 2 - 17;
        
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Helvetica", textSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    CGContextShowTextAtPoint(context, w / 2 - xCordTextAtPointOffset, yCordTextAtPointOffset, text, strlen(text));
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:imageMasked];
    CFRelease(imageMasked);
    return image;
}


-(void)makeSliderTransparent
{
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}


-(void) layoutSubviews
{
    [super layoutSubviews];
    if(self.updateblock)
        self.updateblock();
}



@end
