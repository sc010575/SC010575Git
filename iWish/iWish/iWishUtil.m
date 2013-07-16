//
//  iWishUtil.m
//  iWish
//
//  Created by Suman Chatterjee on 28/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "iWishUtil.h"

@implementation iWishUtil


//static method to implement the class singleton object
+ (iWishUtil*) shared
{
	static iWishUtil* shared = nil;
	
    // singleton allocate
    if (shared == nil){
        shared = [[iWishUtil alloc] init];
    }
    
	return shared;
}


- (UIImage*) GetProfileImage
{
    // Extract image from the picker and save it
    UIImage *image = [UIImage imageWithContentsOfFile:self.ImagePath];
    return image;
}


- (void) showAlart:(NSString*) text
{
    
   UIAlertView * saveNote = [[UIAlertView alloc]
                initWithTitle:@"Alert"
                message:text
                delegate:nil
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];
    [saveNote show];
}


- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}

@end
