//
//  CustomPopTipView.h
//  ActivEngage2
//
//  Created by Suman Chatterjee on 22/11/2012.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import <UIKit/UIKit.h>


/** \brief	Display a speech bubble-like popup on screen, pointing at the
 designated view or button.
 
 A UIView subclass drawn using core graphics. Pops up (optionally animated)
 a speech bubble-like view on screen, a rounded rectangle with a gradiant
 fill containing a specified text message, drawn with a pointer dynamically
 positioned to point at the center of the designated button or view.
**/

typedef enum {
	PointDirectionUp = 0,
	PointDirectionDown
} PointDirection;

typedef enum {
    CMPopTipAnimationSlide = 0,
    CMPopTipAnimationPop
} CMPopTipAnimation;


@protocol CMPopTipViewDelegate;


@interface CustomPopTipView : UIView
{
}

@property (nonatomic) CMPopTipAnimation animation;
@property (nonatomic, unsafe_unretained) id<CMPopTipViewDelegate> delegate;
@property (nonatomic) BOOL dismissTapAnywhere;
@property (unsafe_unretained, nonatomic, readonly)	id targetObject;

/* Contents can be either a message or a UIView */
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithCustomView:(UIView *)aView;

// Determoine the point where the popup point will be created , if PointX is 0 then it will calculate from the available view's frame origine 
- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated withPointerPosition:(CGFloat) PointX;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal;
- (PointDirection) getPointDirection;

@end


@protocol CMPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(CustomPopTipView *)popTipView;
@end
