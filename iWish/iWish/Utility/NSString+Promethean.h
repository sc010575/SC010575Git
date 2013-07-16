//
//  NSString+Promethean.h
//  ActivEngage2
//
//  Created by Mobile Dev on 11/27/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Promethean)

- (NSString*)trimmed;

- (NSString*)trimmedWithCharecterSet:(int)position withChar:(NSString*)str;

- (NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str;


+ (BOOL)isBaseRTL;

@end
