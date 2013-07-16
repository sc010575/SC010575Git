//
//  UIView+Promethean.m
//  ActivEngage2
//
//  Created by Mobile Dev on 11/15/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import "UIView+Promethean.h"
#import "NSString+Promethean.h"
@implementation UIView (Promethean)

- (id) loadFromNib
{
	NSString* className = NSStringFromClass([self class]);
	
	NSString* interfaceIdiom = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		? @"iPhone" : @"iPad";

	NSString* nibName = [NSString stringWithFormat:@"%@_%@", className, interfaceIdiom];

	NSArray* elements = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	for (NSObject* anObject in elements)
	{
		if ([anObject isKindOfClass:[self class]])
		{
			return anObject;
		}
	}
	return nil;
}

// lock to prevent infinite recursion
BOOL lockAwake = NO;

// supports ARC, properly swaps out self for a nib loaded version
- (id) handleAwakeAfterUsingCoder
{
    // this prevents infinite recursion
    if (lockAwake == NO)
    {
        lockAwake = YES;
        UIView* theRealThing = [self loadFromNib];
        lockAwake = NO;
		
        // pass properties through
        theRealThing.frame = self.frame;
        theRealThing.autoresizingMask = self.autoresizingMask;
        theRealThing.alpha = self.alpha;
        theRealThing.hidden = self.hidden;
		
		// arc support
		//CFRelease((__bridge const void*)self);
		//CFRetain((__bridge const void*)theRealThing);
		
        return theRealThing;
    }

	return nil;
}

// position one view after another
- (void) positionBelowView:(UIView*) view withPadding:(CGFloat) padding
{
    CGRect frame = self.frame;
    frame.origin.y = view.frame.origin.y + view.frame.size.height + padding;
    self.frame = frame;
}

// arrange views if the language directions Right To Left 
- (void) ArrangeSubviewsRightToLeft:(UIView*)rView leftView:(UIView*)lView
{
    if ([NSString isBaseRTL])
    {
        CGRect frame = lView.frame;
        CGRect tempFrame = rView.frame;
        tempFrame.origin.x = frame.origin.x;
        rView.frame = tempFrame;
        
        frame.origin.x = rView.frame.size.width + rView.frame.origin.x;
        lView.frame = frame;
        
        rView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        lView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;

    }
}

// swap subviews for Right to left allaignment
- (void) SwapSubviewsRightToLeft:(UIView*)rView leftView:(UIView*)lView
{

    if ([NSString isBaseRTL])
    {
        rView.autoresizingMask = UIViewAutoresizingNone;
        lView.autoresizingMask = UIViewAutoresizingNone;
        
        CGRect frame = lView.frame;
        CGRect tempFrame = rView.frame;
        tempFrame.origin.x = frame.origin.x;
        frame.origin.x = rView.frame.origin.x;
        rView.frame = tempFrame;
        lView.frame = frame;
        
        rView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        lView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    }
}

-(void) ReverseSubviews
{
    CGAffineTransform T = CGAffineTransformMakeScale(-1,1);
    for(UIView *subView in self.subviews)
        subView.transform = T;
    self.transform = T;
}


@end
