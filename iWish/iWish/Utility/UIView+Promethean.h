//
//  UIView+Promethean.h - Promethean extensions on UIView
//  ActivEngage2
//
//  Created by Mobile Dev on 11/15/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Promethean)

// loads based on class name + device category iphone / ipad
- (id) loadFromNib;

// supports ARC, properly swaps out self for a nib loaded version
- (id) handleAwakeAfterUsingCoder;

// position one view after another
- (void) positionBelowView:(UIView*) view withPadding:(CGFloat) padding;

// Reverse subviews for Right to left allaignment
- (void) ReverseSubviews;
@end
