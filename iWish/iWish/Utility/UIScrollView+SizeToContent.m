//
//  UIScrollView+SizeToContent.m
//  ActivEngage2
//
//  Created by Mobile Dev on 11/19/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import "UIScrollView+SizeToContent.h"

@implementation UIScrollView (SizeToContent)

- (void)sizeToContent
{
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in self.subviews)
    {
        if (view.alpha > 0.0f)
        {
            //NSLog(@"self.subviews %@", [view description]);
            contentRect = CGRectUnion(contentRect, view.frame);
        }
    }
    
    //NSLog(@"contentRect: %@", CGRectCreateDictionaryRepresentation(contentRect));
    
    //NSLog(@"self.frame: %@", CGRectCreateDictionaryRepresentation(self.frame));
    
    if (contentRect.size.width < self.frame.size.width)
        contentRect.size.width = self.frame.size.width;
    
    if (contentRect.size.height < self.frame.size.height)
        contentRect.size.height = self.frame.size.height;

    self.contentSize = contentRect.size;
}

- (void) disableScrollingForType:(ScrollingType) scrollingtype
{
    CGFloat width;
    CGFloat height;
    if (scrollingtype == HorizentalScrolling)
   {
     width = [UIScreen mainScreen].bounds.size.width;
     height = self.contentSize.height;
   }
   else
   {
       width =  self.contentSize.width;
       height = [UIScreen mainScreen].bounds.size.height ;
   }
    CGSize scrollableSize = CGSizeMake(width, height);
    [self setContentSize:scrollableSize];
}

@end
