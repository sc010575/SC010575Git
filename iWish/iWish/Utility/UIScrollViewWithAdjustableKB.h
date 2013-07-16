//
//  UIKBAvoidingScrollView.h
//  ActivEngage2
//
//  Created by Chatterjee,Suman on 07/03/2013.
//  Copyright (c) 2013 Promethean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollViewWithAdjustableKB : UIScrollView

- (void)adjustOffsetToIdealIfNeeded;

- (void)sizeToContent;

@end
