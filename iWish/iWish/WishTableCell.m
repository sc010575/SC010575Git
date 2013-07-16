//
//  WishTableCell.m
//  iWish
//
//  Created by Suman Chatterjee on 07/05/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "WishTableCell.h"
#import "UIColor+iWish.h"
#import "iWishUtil.h"

@interface WishTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *WishImage;
@property (weak, nonatomic) IBOutlet UILabel *WishName;
@property (weak, nonatomic) IBOutlet UILabel *DaysLeft;
@property (weak, nonatomic) IBOutlet UILabel *WishDetails;
@property (weak, nonatomic) IBOutlet UILabel *ProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *WishStatus;
@end


@implementation WishTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellData:(NSString *)newData
{
    NSArray *subStrings = [newData componentsSeparatedByString:@","];
    self.WishName.text = [subStrings objectAtIndex:0];
    self.WishName.textColor = [UIColor fromHex:0x2B60DE];
    self.WishDetails.text = [subStrings objectAtIndex:1];
    self.WishDetails.textColor = [UIColor fromHex:0x25587E];
    
    //Main Image
    NSString *image = [subStrings objectAtIndex:2];
    if([image isEqualToString:@"Picture1"])
        self.WishImage.image = [UIImage imageNamed:@"Wishlist.png"];
    
    //progress
    NSString *progress = [subStrings objectAtIndex:3];
    self.ProgressLabel.text = [NSString stringWithFormat:@"Current Progress: %@%%",progress];
    self.ProgressLabel.textColor = [UIColor fromHex:0x25587E];
    
    
    //Calculate date
    NSString *finaldate_s = [subStrings objectAtIndex:5];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    NSDate *finaldate = [df dateFromString:finaldate_s];
    int diff = [[iWishUtil shared] daysBetween:[NSDate date] and:finaldate];
    self.DaysLeft.text = [NSString stringWithFormat:@"%d",diff];
    self.DaysLeft.textColor = [UIColor fromHex:0x25587E];
    
    //Wish Status
    NSString *status = [subStrings objectAtIndex:4];
    NSString *finalString;
    if([status isEqualToString:@"New"] && [progress intValue] == 0)
        finalString = [NSString stringWithFormat:@" Come on !! Fulfill your wish"];
    else if([status isEqualToString:@"New"] && [progress intValue] >=20 &&  [progress intValue] < 40)
        finalString = [NSString stringWithFormat:@" Carry On .. "];
    else if([status isEqualToString:@"New"] && [progress intValue] > 40)
        finalString = [NSString stringWithFormat:@" Come on !! Great Going .. Carry On"];
    
    self.WishStatus.text = finalString;
    self.WishStatus.textColor = [UIColor fromHex:0x2B60DE];
    
   

}



- (void)drawRect:(CGRect)rect
{
    //*
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGFloat locations[2] = { 0.0, 1.0 };
    
    // An ARC subtlety - assign UIColors to variables before using their
    // CGColors in a C array. Otherwise the UIColors can be immediately released
    // and leave us with the app crashing on CGGradientCreateWithColors
    // due to dangling pointers in the colors array.
    UIColor *color1 = [UIColor fromHex:0xFBFBFB];
    UIColor *color2 = [UIColor fromHex:0xDEDFE0];
    CGColorRef colors[2] = { color1.CGColor, color2.CGColor };
    
    CFArrayRef colorsArray = CFArrayCreate(NULL, (void *)colors, 2, NULL);
    
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(rgbColorspace,
                                                        colorsArray,
                                                        locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
    CGContextDrawLinearGradient(currentContext, gradient, topCenter, midCenter, 0);
    
    CGGradientRelease(gradient);
    
    CGContextSetFillColorWithColor(currentContext, [UIColor fromHex:0x939598].CGColor);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor fromHex:0x939598].CGColor);
    
    CGContextSetLineWidth(currentContext, 1.0f);
    
    CGFloat barX;
    CGFloat barY;
    
        barX = self.ProgressLabel.frame.origin.x;
        barY = self.ProgressLabel.frame.origin.y;
    
    CGContextMoveToPoint(currentContext, 0, barY);
    CGContextAddLineToPoint(currentContext, currentBounds.size.width, barY);
    
    CGContextMoveToPoint(currentContext, barX, barY);
    CGContextAddLineToPoint(currentContext, barX, currentBounds.size.height);
    
    CGContextStrokePath(currentContext);
    
    CGFloat spacerY = barY + self.ProgressLabel.frame.size.height;
    CGContextFillRect(currentContext, CGRectMake(0, spacerY, currentBounds.size.width, currentBounds.size.height - spacerY));
    
    CFRelease(colorsArray);
    CGColorSpaceRelease(rgbColorspace);
    //*/
    
    [super drawRect:rect];
}


@end
