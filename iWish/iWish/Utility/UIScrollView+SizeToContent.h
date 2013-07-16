//
//  UIScrollView+SizeToContent.h
//  ActivEngage2
//
//  Created by Mobile Dev on 11/19/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum Scrolling{
    HorizentalScrolling                       = 0,
    VerticalScrolling                         = 1
}ScrollingType;

@interface UIScrollView (SizeToContent)

- (void)sizeToContent;

- (void) disableScrollingForType:(ScrollingType) scrollingtype;

@end
