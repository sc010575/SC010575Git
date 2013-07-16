//
//  MainViewController.m
//  iWish
//
//  Created by Suman Chatterjee on 19/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "MainViewController.h"
#import "DbController.h"
#import "iWishUtil.h"
#import "WishListViewViewController.h"
#import "UIImage+Promethean.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *CreateNewWish;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *ProfileLabel;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.CreateNewWish.enabled = YES;
    self.ProfileLabel.text = [iWishUtil shared].ProfileName;
    self.ProfileImage.image = [UIImage imageResize:[[iWishUtil shared] GetProfileImage] withSize:self.ProfileImage.frame.size];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"WishCreation"])
    {

        //create the wish table
        NSLog(@"Preparing WISHMAIN table if not exists");
        
        NSMutableDictionary  *wishOwner = [[NSMutableDictionary alloc] init];
        [wishOwner setObject:@"Wish_Owner" forKey:@"columnname"];
        [wishOwner setObject:@"TEXT" forKey:@"Type"];

        
        NSMutableDictionary  *wishNumber = [[NSMutableDictionary alloc] init];
        [wishNumber setObject:@"Wish_Number" forKey:@"columnname"];
        [wishNumber setObject:@"TEXT" forKey:@"Type"];

        
        NSMutableDictionary  *wishName = [[NSMutableDictionary alloc] init];
        [wishName setObject:@"wish_Name" forKey:@"columnname"];
        [wishName setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *wishDetails = [[NSMutableDictionary alloc] init];
        [wishDetails setObject:@"Wish_Details" forKey:@"columnname"];
        [wishDetails setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *PicturePath1 = [[NSMutableDictionary alloc] init];
        [PicturePath1 setObject:@"Picture1" forKey:@"columnname"];
        [PicturePath1 setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *PicturePath2 = [[NSMutableDictionary alloc] init];
        [PicturePath2 setObject:@"Picture2" forKey:@"columnname"];
        [PicturePath2 setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *PicturePath3 = [[NSMutableDictionary alloc] init];
        [PicturePath3 setObject:@"Picture3" forKey:@"columnname"];
        [PicturePath3 setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *PicturePath4 = [[NSMutableDictionary alloc] init];
        [PicturePath4 setObject:@"Picture4" forKey:@"columnname"];
        [PicturePath4 setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *PicturePath5 = [[NSMutableDictionary alloc] init];
        [PicturePath5 setObject:@"Picture5" forKey:@"columnname"];
        [PicturePath5 setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *step1 = [[NSMutableDictionary alloc] init];
        [step1 setObject:@"Wish_Step1" forKey:@"columnname"];
        [step1 setObject:@"TEXT" forKey:@"Type"];

        NSMutableDictionary  *step2 = [[NSMutableDictionary alloc] init];
        [step2 setObject:@"Wish_Step2" forKey:@"columnname"];
        [step2 setObject:@"TEXT" forKey:@"Type"];

        NSMutableDictionary  *step3 = [[NSMutableDictionary alloc] init];
        [step3 setObject:@"Wish_Step3" forKey:@"columnname"];
        [step3 setObject:@"TEXT" forKey:@"Type"];

        NSMutableDictionary  *step4 = [[NSMutableDictionary alloc] init];
        [step4 setObject:@"Wish_Step4" forKey:@"columnname"];
        [step4 setObject:@"TEXT" forKey:@"Type"];

        NSMutableDictionary  *step5 = [[NSMutableDictionary alloc] init];
        [step5 setObject:@"Wish_Step5" forKey:@"columnname"];
        [step5 setObject:@"TEXT" forKey:@"Type"];

        NSMutableDictionary  *Progress = [[NSMutableDictionary alloc] init];
        [Progress setObject:@"Progress" forKey:@"columnname"];
        [Progress setObject:@"TEXT" forKey:@"Type"];
      
        NSMutableDictionary  *Status = [[NSMutableDictionary alloc] init];
        [Status setObject:@"Status" forKey:@"columnname"];
        [Status setObject:@"TEXT" forKey:@"Type"];
        
        
        NSMutableDictionary  *currentDate = [[NSMutableDictionary alloc] init];
        [currentDate setObject:@"Wish_Date" forKey:@"columnname"];
        [currentDate setObject:@"TEXT" forKey:@"Type"];

        NSMutableDictionary  *wishMatureDate = [[NSMutableDictionary alloc] init];
        [wishMatureDate setObject:@"Wish_Mature_Date" forKey:@"columnname"];
        [wishMatureDate setObject:@"TEXT" forKey:@"Type"];
        
         
        
        NSArray *colDataArray = [NSArray arrayWithObjects:wishOwner,wishNumber,wishName,wishDetails,PicturePath1,PicturePath2,PicturePath3,PicturePath4,PicturePath5,step1,step2,step3,step4,step5,Progress,Status,currentDate,wishMatureDate,nil];
  
        //temp one 
      //  [[DbController shared] dropTable:@"WISHMAIN" withCompletionBlock:nil];
        
        [[DbController shared] CreateTableIfNotExists:@"WISHMAIN" withColumn:colDataArray withPrimaryKey:@"Wish_Owner,Wish_Number,Wish_Mature_Date" withCompletionBlock:nil];

        NSLog(@"Prepare WISHMAIN table if not exists");
    }
    
    else if ([[segue identifier] isEqualToString:@"CurrentWishList"] )
    {
        // select all the wishes
        
        NSArray *colName = [ NSArray arrayWithObjects:@"wish_Name", @"Wish_Details",@"Picture1",@"Progress",@"Status",@"Wish_Mature_Date", nil];
        NSString * make_where = [NSString stringWithFormat:@"Wish_Owner=\"%@\"",[iWishUtil shared].ProfileName];

        [[DbController shared] selectDataFromTable:@"WISHMAIN" withColumn:colName  withWhareClause:make_where withCompletionBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error != nil)
                {
                    // show the error
                 [[iWishUtil shared] showAlart:[NSString stringWithFormat:@"%@ and Code %d",error.description,error.code]];
                }
            });
        } andResultBlock:^(NSArray *result){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result.count > 0 )
                {
                    WishListViewViewController * WVC = [segue destinationViewController];
                    WVC.WishListArray = result;
                    [iWishUtil shared].WishDetails = result;
                }
                else
                {
                    [[iWishUtil shared] showAlart:@"No Wishes booked. Please create a wish first"];
                    
                }
                
            });
        }];
        

         
    }
    
}

@end
