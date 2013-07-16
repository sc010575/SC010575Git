//
//  ProfileCreationViewController.m
//  iWish
//
//  Created by Suman Chatterjee on 23/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "ProfileCreationViewController.h"
#import "DbController.h"
#import "UIScrollViewWithAdjustableKB.h"
#import "iWishUtil.h"
@interface ProfileCreationViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL dataSaved;
    UIPopoverController *imagePickerPopover;
    NSString *imagePath;
}

@property (weak, nonatomic) IBOutlet UIScrollViewWithAdjustableKB *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *FirstName;
@property (weak, nonatomic) IBOutlet UITextField *ProfilePassword;
@property (weak, nonatomic) IBOutlet UITextField *PasswordConfirm;
@property (weak, nonatomic) IBOutlet UIButton *photoSelectionBtm;
@property (strong,  nonatomic) UIImagePickerController *imgPicker;

@property (weak, nonatomic) IBOutlet UITextField *LastName;
@property (weak, nonatomic) IBOutlet UITextField *EmailAdd;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileUIImage;

@property (weak, nonatomic) IBOutlet UIButton *SaveData;
@property (weak, nonatomic) IBOutlet UIButton *ClearData;

- (IBAction)PhotoSelection:(id)sender;
- (IBAction)SaveData:(id)sender;

@end

@implementation ProfileCreationViewController

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
    dataSaved = NO;
    [self.scrollView sizeToContent];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) saveCurrentProfile
{
    //delete the current row from the table
    [[DbController shared] deleteFromTable:@"CURRENTUSER" withWhareClause:nil withCompletionBlock:^(NSError *error) {
        if(error != nil)
        {
            NSString *errorText = [NSString stringWithFormat:@"%@ and Code %d",error.description,error.code];
            [[iWishUtil shared] showAlart:errorText ];
        }
        
        
    // insert the new row now
        NSMutableDictionary  *FirstName = [[NSMutableDictionary alloc] init];
        [FirstName setObject:@"FirstName" forKey:@"columnname"];
        [FirstName setObject:[NSString stringWithFormat:@"%@",self.FirstName.text] forKey:@"Value"];
        
        
        NSMutableDictionary  *LastName = [[NSMutableDictionary alloc] init];
        [LastName setObject:@"LastName" forKey:@"columnname"];
        [LastName setObject:[NSString stringWithFormat:@"%@",self.LastName.text] forKey:@"Value"];
        
        
        NSMutableDictionary  *Passward = [[NSMutableDictionary alloc] init];
        [Passward setObject:@"Passward" forKey:@"columnname"];
        [Passward setObject:[NSString stringWithFormat:@"%@",self.ProfilePassword.text] forKey:@"Value"];
        
        NSMutableDictionary  *PicturePath = [[NSMutableDictionary alloc] init];
        [PicturePath setObject:@"Picture" forKey:@"columnname"];
        [PicturePath setObject:imagePath forKey:@"Value"];
        

        
        
        NSArray *colDataArray = [NSArray arrayWithObjects:FirstName,LastName,Passward,PicturePath,nil];
        dataSaved = NO;
        
        [[DbController shared] insertIntoTable:@"CURRENTUSER" withColumn:colDataArray withCompletionBlock:^(NSError *error) {
                 if(error == nil)
                {
                    dataSaved = YES;
                }
                else
                {
                    // show the error
                    NSString *errorText = [NSString stringWithFormat:@"%@ and Code %d",error.description,error.code];
                    [[iWishUtil shared] showAlart:errorText ];
                    dataSaved = NO;
                }
        }];
    }];
    
    return dataSaved;
}

- (IBAction)SaveData:(id)sender {
    
    [self.FirstName resignFirstResponder];
    [self.LastName  resignFirstResponder];
    [self.EmailAdd  resignFirstResponder];
    
    //Save data in database

    if(self.FirstName.text.length == 0 ||
       self.LastName.text.length == 0){
        [[iWishUtil shared] showAlart:@"Name Can Not be blank " ];
        return;
    }
    
    if(imagePath.length == 0)
    {
        [[iWishUtil shared] showAlart:@"Select your profile image "];
        return;

    }
    
    if(self.ProfilePassword.text.length == 0 ){
        [[iWishUtil shared] showAlart:@"Please enter a Password.. " ];
        return;
    }

    
    if (![self.ProfilePassword.text isEqualToString:self.PasswordConfirm.text])
    {
        [[iWishUtil shared] showAlart:@"Password not matched .. " ];
        return;

    }
    NSMutableDictionary  *FirstName = [[NSMutableDictionary alloc] init];
    [FirstName setObject:@"FirstName" forKey:@"columnname"];
    [FirstName setObject:[NSString stringWithFormat:@"%@",self.FirstName.text] forKey:@"Value"];
    
    
    NSMutableDictionary  *LastName = [[NSMutableDictionary alloc] init];
    [LastName setObject:@"LastName" forKey:@"columnname"];
    [LastName setObject:[NSString stringWithFormat:@"%@",self.LastName.text] forKey:@"Value"];

    NSMutableDictionary  *Email = [[NSMutableDictionary alloc] init];
    [Email setObject:@"email" forKey:@"columnname"];
    [Email setObject:[NSString stringWithFormat:@"%@",self.EmailAdd.text] forKey:@"Value"];

    
    NSMutableDictionary  *PicturePath = [[NSMutableDictionary alloc] init];
    [PicturePath setObject:@"Picture" forKey:@"columnname"];
    [PicturePath setObject:imagePath forKey:@"Value"];
    
    
    NSMutableDictionary  *Passward = [[NSMutableDictionary alloc] init];
    [Passward setObject:@"Passward" forKey:@"columnname"];
    [Passward setObject:[NSString stringWithFormat:@"%@",self.ProfilePassword.text] forKey:@"Value"];
    
    
    
    
    NSArray *colDataArray = [NSArray arrayWithObjects:FirstName,LastName,Email,PicturePath,Passward,nil];
    dataSaved = NO;
    
    [[DbController shared] insertIntoTable:@"PROFILE" withColumn:colDataArray withCompletionBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *saveNote;
            if(error == nil)
            {
                
                // shows alert to user
                [saveNote show];
                iWishUtil * wishUtil =  [iWishUtil shared];
                 wishUtil.ProfileName = self.FirstName.text;
                wishUtil.ImagePath  = imagePath;
                if ([self saveCurrentProfile])
                    [self performSegueWithIdentifier:@"SaveProfile" sender:sender];
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


#pragma mark -
#pragma mark === Text Field Delegate ===
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    [self.scrollView adjustOffsetToIdealIfNeeded];
    return YES;

}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SaveProfile"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = dataSaved; //
        if (!segueShouldOccur) {
             return NO;
        }
   

    }

    // by default perform the segue transition
    return YES;
}

#pragma mark
#pragma photoselction 

-(IBAction)PhotoSelection:(id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select image source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo", @"Choose from library", nil];
    popupQuery.tag = 1;
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.photoSelectionBtm];
    
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
        [popOverController presentPopoverFromRect:self.photoSelectionBtm.bounds inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%i.png",[iWishUtil shared].ProfileName, i]];
    
    // Extract image from the picker and save it
    UIImage *image;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
    }
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
        [imagePickerPopover dismissPopoverAnimated:YES];
    else
        [picker dismissModalViewControllerAnimated:YES];
    self.ProfileUIImage.image = image;
}





@end
