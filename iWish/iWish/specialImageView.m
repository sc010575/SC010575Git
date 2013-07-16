//
//  specialImageView.m
//  iWish
//
//  Created by Suman Chatterjee on 10/05/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "specialImageView.h"
#import "iWishUtil.h"
#import "UIColor+iWish.h"

@interface specialImageView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGSize pageControlSize;
}

@property (strong , nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray* imageArray;

@property (copy) TapImageViewBlock tapimageviewblock;

@end

@implementation specialImageView

//Lazy initialization of image array
@synthesize imageArray = _imageArray;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

- (UIScrollView*) scrollView
{
    if(_scrollView) return _scrollView;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    self.scrollView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                         UIViewAutoresizingFlexibleRightMargin |
                                         UIViewAutoresizingFlexibleTopMargin);
    
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;

    return _scrollView;
}


- (UIPageControl *)pageControl
{
    // Lazy instantiation.
    if (self->_pageControl) return self->_pageControl;
    self->_pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    
    self.pageControl.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                         UIViewAutoresizingFlexibleRightMargin |
                                         UIViewAutoresizingFlexibleTopMargin);
    
    return self->_pageControl;
}   // pageControl



- (NSMutableArray*)imageArray
{
    if (_imageArray) return _imageArray;
    _imageArray = [[NSMutableArray alloc] init];
    return _imageArray;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor fromHex:0x4B4545];
        
        CGRect frame = self.frame;
        self.scrollView.frame = frame;
        [self addSubview:self.scrollView];
        self.scrollView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        self.backgroundColor = [UIColor fromHex:0x4B4545];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.scrollView.backgroundColor = [UIColor clearColor];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    // position the scrollview
    CGRect frame = self.scrollView.frame;
    pageControlSize = [self.pageControl sizeForNumberOfPages:1];
    
    frame.size.width = self.frame.size.width - 20;
    frame.size.height  = self.frame.size.height -  pageControlSize.height - 10;
    frame.origin.y = 10;
    frame.origin.x = 10;
    self.scrollView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    // Get sample height of a page control - we need it to size the buttons
    // containers.

    

 }


- (void) addImageView:(UIImageView *) newImageView withSize:(CGSize) size withTapImageBlock:(TapImageViewBlock) TapImage;
{
    self.tapimageviewblock = TapImage;
    newImageView.backgroundColor = [UIColor whiteColor];
    
    //check the maximum number of image you can store 
    if (self.imageArray.count >= self.maxNumberImage) {
        
        [[iWishUtil shared] showAlart:@"Maximum number of image stored"];
        return;
    }
    [self.imageArray addObject:newImageView];
    //  CGSize pageSize = self.scrollView.frame.size; // scrollView is an IBOutlet for our UIScrollView
    CGFloat xPos = 0 ;
    int imageCount = 0;
    for(UIImageView* imageView in self.imageArray)
    {
        xPos += imageView.frame.size.width + 10;
        imageView.tag = imageCount++;
    }
    newImageView.frame = CGRectMake(xPos, 0, size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:newImageView];
    [self.scrollView setContentSize:CGSizeMake(xPos, [self.scrollView bounds].size.height)];
    
    //add gesture controll
    //Add Tap gesture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    newImageView.userInteractionEnabled = YES;
    [newImageView addGestureRecognizer:tapRecognizer];
    

    self.pageControl.numberOfPages = imageCount;
    CGRect frame = CGRectMake(CGRectGetMidX(self.bounds) - pageControlSize.width / 2,
                       CGRectGetHeight(self.bounds) - pageControlSize.height,
                       pageControlSize.width,
                       pageControlSize.height);
    self.pageControl.frame = frame;
 
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

-(void)contentViewTapped:(id)sender {
	
    NSLog(@"contentViewTapped .. ");
    UIImageView *contentView = (UIImageView*)[(UITapGestureRecognizer*)sender view];
    if ([contentView isKindOfClass:[UIImageView class]])
    {
        self.pageControl.currentPage = contentView.tag;
        if (self.tapimageviewblock)
            self.tapimageviewblock(contentView.image);
    }
}




@end
