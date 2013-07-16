//
//  specialImageView.h
//  iWish
//
//  Created by Suman Chatterjee on 10/05/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapImageViewBlock)(UIImage* content);


@interface specialImageView : UIView

@property (assign,nonatomic) NSInteger maxNumberImage;

- (void) addImageView:(UIImageView *) imageView withSize:(CGSize) size withTapImageBlock:(TapImageViewBlock) TapImage;


@end