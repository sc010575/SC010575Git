//
//  UIViewController+FromNib.m
//  ActivEngage2
//
//  Created by Mobile Dev on 11/19/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import "UIViewController+FromNib.h"

@implementation UIViewController (FromNib)

+ (NSString*) fromNib
{
	NSString* className = NSStringFromClass([self class]);
	
	NSString* interfaceIdiom = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    ? @"iPhone" : @"iPad";
    
	return [NSString stringWithFormat:@"%@_%@", className, interfaceIdiom];
}

@end
