//
//  ViewController.m
//  iWish
//
//  Created by Suman Chatterjee on 19/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "WishBuilderViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "DbController.h"
#import "iWishUtil.h"
#import "UIScrollView+SizeToContent.h"
#import "specialImageView.h"
#import "UIImage+Promethean.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WishBuilderViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL dataSaved;
    UIPopoverController *imagePickerPopover;
    NSString *imagePath;
    NSUInteger page;
    int count;
    

}
@property (weak, nonatomic) IBOutlet UITextField *WishTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *WishdatePicker;
@property (weak, nonatomic) IBOutlet UIButton *WishSave;
@property (weak, nonatomic) IBOutlet UIButton *WishCancle;
@property (weak, nonatomic) IBOutlet UITextView *WishDesView;
@property (weak, nonatomic) IBOutlet UIPickerView *namePicker;
@property (weak, nonatomic) IBOutlet UILabel *WishLabel;
@property (weak, nonatomic) IBOutlet UIButton *AddPhotoBtn;
@property (strong,  nonatomic) UIImagePickerController *imgPicker;
@property (weak,nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray* imageArray;
@property (weak, nonatomic) IBOutlet specialImageView   *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
-(IBAction)PhotoSelection:(id)sender;
-(IBAction)saveRecords:(id)sender;
-(void) scheduleNotification;
-(IBAction) clearNotification;

@end

@implementation WishBuilderViewController
@synthesize imageArray = _imageArray;



- (NSMutableArray*) imageArray
{
    if (_imageArray) return _imageArray;
    _imageArray = [[NSMutableArray alloc] init];
    return _imageArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.WishDesView.layer.borderWidth = 1.0f;
    self.WishDesView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.namePicker.delegate = self;
    self.namePicker.dataSource = self;
    dataSaved = NO;
    self.WishLabel.text = [NSString stringWithFormat:@"Wish Builder for %@",[iWishUtil shared].ProfileName];
    page = 0;
    self.imageView.maxNumberImage = 4;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark === Text Field Delegate ===
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark === View Actions ===
#pragma mark -

- (void)clearNotification {
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)saveRecords:(id) sender {
	
	[self.WishTitle resignFirstResponder];
    
    //Save data in database
    NSMutableDictionary  *wishOwner = [[NSMutableDictionary alloc] init];
    [wishOwner setObject:@"Wish_Owner" forKey:@"columnname"];
    [wishOwner setObject:[iWishUtil shared].ProfileName forKey:@"Value"];
   
    if(self.WishTitle.text.length == 0 ||
       self.WishDesView.text.length == 0){
        UIAlertView *saveNote = [[UIAlertView alloc]
                                 initWithTitle:@"Alert"
                                 message:@"Write a Wish And Its details to save the data "
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        
        // shows alert to user
        [saveNote show];
        return;
    }
    
    __block int wishNumber = 0;
    
    NSArray *colName = [ NSArray arrayWithObjects:@"wish_Number", nil];
    NSString * make_where = [NSString stringWithFormat:@"Wish_Owner=\"%@\"",[iWishUtil shared].ProfileName];
    [[DbController shared] selectDataFromTable:@"WISHMAIN" withColumn:colName  withWhareClause:make_where withCompletionBlock:^(NSError *error) {
                if(error != nil)
                {
                    // show the error
                    [[iWishUtil shared] showAlart:[NSString stringWithFormat:@"%@ and Code %d",error.description,error.code]];
                }
            }
         andResultBlock:^(NSArray *result){
                   
             wishNumber = ([[result objectAtIndex:0] isEqualToString:@"null"])? 0 : [[result objectAtIndex:0] intValue] ;
        }];
        
    
    // store wish name 
    NSMutableDictionary  *wistName = [[NSMutableDictionary alloc] init];
    [wistName setObject:@"wish_Name" forKey:@"columnname"];
    [wistName setObject:[NSString stringWithFormat:@"%@",self.WishTitle.text] forKey:@"Value"];

    // store wish number
    NSMutableDictionary  *wishNum = [[NSMutableDictionary alloc] init];
    [wishNum setObject:@"wish_Number" forKey:@"columnname"];
    [wishNum setObject:[NSString stringWithFormat:@"%d",(wishNumber+1)] forKey:@"Value"];

    // store wish details
    NSMutableDictionary  *wishDetails = [[NSMutableDictionary alloc] init];
    [wishDetails setObject:@"Wish_Details" forKey:@"columnname"];
    [wishDetails setObject:[NSString stringWithFormat:@"%@",self.WishDesView.text] forKey:@"Value"];
    
    // store pictures of the wish
    NSMutableDictionary  *PicturePath1 = [[NSMutableDictionary alloc] init];
    [PicturePath1 setObject:@"Picture1" forKey:@"columnname"];
    [PicturePath1 setObject:@"Picture1" forKey:@"Value"];
    

    NSMutableDictionary  *PicturePath2 = [[NSMutableDictionary alloc] init];
    [PicturePath2 setObject:@"Picture2" forKey:@"columnname"];
    [PicturePath2 setObject:@"Picture2" forKey:@"Value"];

    
    NSMutableDictionary  *PicturePath3 = [[NSMutableDictionary alloc] init];
    [PicturePath3 setObject:@"Picture3" forKey:@"columnname"];
    [PicturePath3 setObject:@"Picture3" forKey:@"Value"];
    
    NSMutableDictionary  *PicturePath4 = [[NSMutableDictionary alloc] init];
    [PicturePath4 setObject:@"Picture4" forKey:@"columnname"];
    [PicturePath4 setObject:@"Picture4" forKey:@"Value"];

    NSMutableDictionary  *PicturePath5 = [[NSMutableDictionary alloc] init];
    [PicturePath5 setObject:@"Picture5" forKey:@"columnname"];
    [PicturePath5 setObject:@"Picture5" forKey:@"Value"];
    
    NSMutableDictionary  *Step1 = [[NSMutableDictionary alloc] init];
    [Step1 setObject:@"Wish_Step1" forKey:@"columnname"];
    [Step1 setObject:@"Wish_Step1" forKey:@"Value"];
    
    NSMutableDictionary  *Step2 = [[NSMutableDictionary alloc] init];
    [Step2 setObject:@"Wish_Step2" forKey:@"columnname"];
    [Step2 setObject:@"Wish_Step2" forKey:@"Value"];

    NSMutableDictionary  *Step3 = [[NSMutableDictionary alloc] init];
    [Step3 setObject:@"Wish_Step3" forKey:@"columnname"];
    [Step3 setObject:@"Wish_Step3" forKey:@"Value"];

    NSMutableDictionary  *Step4 = [[NSMutableDictionary alloc] init];
    [Step4 setObject:@"Wish_Step4" forKey:@"columnname"];
    [Step4 setObject:@"Wish_Step4" forKey:@"Value"];

    NSMutableDictionary  *Step5 = [[NSMutableDictionary alloc] init];
    [Step5 setObject:@"Wish_Step5" forKey:@"columnname"];
    [Step5 setObject:@"Wish_Step5" forKey:@"Value"];
    
    //Store current Progress
    int progressValue = 20;
    NSMutableDictionary  *Progress = [[NSMutableDictionary alloc] init];
    [Progress setObject:@"Progress" forKey:@"columnname"];
    [Progress setObject:[NSString stringWithFormat:@"%d",progressValue] forKey:@"Value"];
    
    //Store current Status
    NSMutableDictionary  *Status = [[NSMutableDictionary alloc] init];
    [Status setObject:@"Status" forKey:@"columnname"];
    [Status setObject:@"New" forKey:@"Value"];
   
    
    // store current date
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    
    NSString * CurrentDate = [df stringFromDate:[NSDate date]];
    NSMutableDictionary  *wishDate = [[NSMutableDictionary alloc] init];
    [wishDate setObject:@"Wish_Date" forKey:@"columnname"];
    [wishDate setObject:CurrentDate forKey:@"Value"];
    
    // store wish mature date
    NSString *WishMatureDate = [df stringFromDate:[self.WishdatePicker date]];
     NSMutableDictionary  *wishMatureDate = [[NSMutableDictionary alloc] init];
    [wishMatureDate setObject:@"Wish_Mature_Date" forKey:@"columnname"];
    [wishMatureDate setObject:WishMatureDate forKey:@"Value"];

    
    NSArray *colDataArray = [NSArray arrayWithObjects:wishOwner,wishNum, wistName,wishDetails,PicturePath1,PicturePath2,PicturePath3,PicturePath4,PicturePath5,Step1,Step2,Step3,Step4,Step5,Progress,Status,wishDate,wishMatureDate,nil];
    dataSaved = NO;
    
    [[DbController shared] insertIntoTable:@"WISHMAIN" withColumn:colDataArray withCompletionBlock:^(NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               UIAlertView *saveNote;
               if(error == nil)
               {
                [self scheduleNotification];
                dataSaved = YES;
                saveNote = [[UIAlertView alloc]
                                                initWithTitle:@"Alert"
                                                message:@"Wish saved successfully"
                                                delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
                   
                // shows alert to user
                [saveNote show];
                [self performSegueWithIdentifier:@"SaveRecords" sender:sender];
               }
               else
               {
                   // show the error
                   saveNote = [[UIAlertView alloc]
                               initWithTitle:@"Alert"
                               message:[NSString stringWithFormat:@"%@ and Code %d",error.description,error.code]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
                   [saveNote show];
               }
               

            });
                }];

}

- (void) scheduleNotification
{
    
    // Create Local Notification
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
	Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
		
		UILocalNotification *notif = [[cls alloc] init];
		notif.fireDate = [self.WishdatePicker date];
		notif.timeZone = [NSTimeZone defaultTimeZone];
		
		notif.alertBody = @"You have a wish ...";
		notif.alertAction = @"Show me";
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber = 1;
        notif.repeatInterval = 0;
		
/* will do later		
 NSInteger index = [self.WishStatusChecker selectedSegmentIndex];
		switch (index) {
			case 1:
				notif.repeatInterval = NSDayCalendarUnit;
				break;
			case 2:
				notif.repeatInterval = NSMonthCalendarUnit;
				break;
			default:
				notif.repeatInterval = 0;
				break;
		}
 */
		
		NSDictionary *userDict = [NSDictionary dictionaryWithObject:self.WishTitle.text
                                                             forKey:kRemindMeNotificationDataKey];
		notif.userInfo = userDict;
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
	}
}

#pragma mark -
#pragma mark === Public Methods ===
#pragma mark -

- (void)showReminder:(NSString *)text {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SaveRecords"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = dataSaved; //
        if (!segueShouldOccur) {
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}


-(IBAction)PhotoSelection:(id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select image source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo", @"Choose from library", nil];
    popupQuery.tag = 1;
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.AddPhotoBtn];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self insertPhoto:buttonIndex];
    
}


- (void)insertPhoto:(int) type
{
    self.imgPicker = [[UIImagePickerController alloc] init];
    if(type == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            {
                self.imgPicker.cameraDevice =  UIImagePickerControllerCameraDeviceFront;
            }
            else
            {
                self.imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
        }
        else {
            NSLog(@"Camera not available");
        }
    }
    else
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.imgPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imgPicker.sourceType];
    
    self.imgPicker.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
    {
        UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController:self.imgPicker];
        [popOverController presentPopoverFromRect:self.AddPhotoBtn.bounds inView:self.AddPhotoBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        imagePickerPopover = popOverController;
        
    }
    else
    {
        [self presentModalViewController:self.imgPicker animated:YES];
    }
}

static int i = 0;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Obtain the path to save to
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@photo%i.png", [iWishUtil shared].ProfileName, i]];
    
    //store image path
    [self.imageArray addObject:imagePath];

    
    
    // Extract image from the picker and save it
    UIImage *image;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
        
    }
    
/* get the image name of the original image , not used now
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        image = [UIImage imageNamed:[imageRep filename]];
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    */
    
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
        [imagePickerPopover dismissPopoverAnimated:YES];
    else
        [picker dismissModalViewControllerAnimated:YES];
    
    UIImageView *tempImageView;
    tempImageView = [[UIImageView alloc] init];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    tempImageView.image = image;
    tempImageView.backgroundColor = [UIColor whiteColor];
    
    [self.imageView addImageView:tempImageView withSize:CGSizeMake(120,120) withTapImageBlock:^(UIImage *content) {
        dispatch_async(dispatch_get_main_queue(), ^{
                                                        self.bigImageView.image = [UIImage imageResize:content withSize:self.bigImageView.frame.size];;
                                                    }
                                                    );
        }];
        
    
}




@end
