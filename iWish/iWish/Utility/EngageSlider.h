//
//  UiSlider+EngageSlider.h
//  ActivEngage2
//
//  Created by Suman Chatterjee on 21/11/2012.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SliderUpdateBlock)(void);

@interface EngageSlider :UISlider

-(void)initEngageSlider:(BOOL) Transparent withBlock:(SliderUpdateBlock) sliderupdateblock;
-(void)setThumbImageForSlider:(UIImage*)thumb withvalue:(NSString *)value size:(CGSize)imageSize;
-(void)valueChanged;
-(CGSize) getThumbnilImageSize;
@property (nonatomic,copy) SliderUpdateBlock updateblock;

@end