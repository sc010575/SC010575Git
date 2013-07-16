//
//  NSString+Promethean.m
//  ActivEngage2
//
//  Created by Mobile Dev on 11/27/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import "NSString+Promethean.h"

@implementation NSString (Promethean)

- (NSString*)trimmed
{
    if ([self isKindOfClass:[NSNull class]])
        return @"";
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*)trimmedWithCharecterSet:(int)position withChar:(NSString*)str
{
    NSString *result;
    result = [NSString stringWithFormat:@"%@%@",[self substringToIndex:position],str];
    return result;

}


+ (BOOL)isBaseRTL {
    
    NSString *check = NSLocalizedString(@"Am_I_RTL", "RTL checkin");

    NSString *isoLangCode = (__bridge_transfer NSString*)CFStringTokenizerCopyBestStringLanguage((__bridge CFStringRef)check, CFRangeMake(0, check.length));
    
    NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:isoLangCode];
    if(direction == kCFLocaleLanguageDirectionRightToLeft)
        return YES;
    else
        return NO;
}

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

@end