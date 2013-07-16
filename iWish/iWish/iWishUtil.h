//
//  iWishUtil.h
//  iWish
//
//  Created by Suman Chatterjee on 28/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iWishUtil : NSObject

+ (iWishUtil*) shared;
- (UIImage*) GetProfileImage;

- (void) showAlart:(NSString*) text;
- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;

@property (copy,nonatomic) NSString * ProfileName;
@property (copy,nonatomic) NSString * ProfileLastName;
@property (copy,nonatomic) NSString * ImagePath;
@property (copy,nonatomic) NSString * ProfileCode;

@property (copy,nonatomic) NSArray  *WishDetails;

@end
