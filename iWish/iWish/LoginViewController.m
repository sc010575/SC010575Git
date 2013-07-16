//
//  LoginViewController.m
//  iWish
//
//  Created by Suman Chatterjee on 26/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "LoginViewController.h"
#import "DbController.h"
#import "iWishUtil.h"

@interface LoginViewController ()<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *ProfileArray;
    NSString *firstName;
    NSString *lastName;
    NSString *password;
    NSString *imagePath;
}

@property (weak, nonatomic) IBOutlet UIButton *profileSelect;

@property (weak, nonatomic) IBOutlet UIPickerView *ProfilePicker;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UIButton *NewProfile;
@property (weak, nonatomic) IBOutlet UIButton *Start;
@property (weak, nonatomic) IBOutlet UILabel *PasscodeLb;
@property (weak, nonatomic) IBOutlet UIButton *CheckProfile;

- (IBAction)DoCheckProfile:(id)sender;

- (IBAction)DoSelectExistingProfile:(id)sender;

@end

@implementation LoginViewController

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
    self.Start.enabled = NO;
    self.PasswordField.hidden = YES;
    self.PasscodeLb.hidden = YES;
    self.ProfilePicker.hidden = YES;
    self.CheckProfile.hidden  = YES;
    self.ProfilePicker.delegate = self;
    self.ProfilePicker.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DoCheckProfile:(id)sender {
    [self.PasswordField resignFirstResponder];
    if(self.PasswordField.text.length == 0 ){
        UIAlertView *saveNote = [[UIAlertView alloc]
                                 initWithTitle:@"Alert"
                                 message:@"Please enter a Password for checking .. "
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        
        // shows alert to user
        [saveNote show];
        return;
    }
/*
 NSArray *colName = [ NSArray arrayWithObject:@"Passward"];
 NSString * make_where = [NSString stringWithFormat:@"FirstName=\"%@\"",firstName ];
[[DbController shared] selectDataFromTable:@"PROFILE" withColumn:colName  withWhareClause:make_where withCompletionBlock:^(NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *saveNote;
        if(error != nil)
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
} andResultBlock:^(NSArray *result){
    dispatch_async(dispatch_get_main_queue(), ^{
        if(result.count > 0 )
        {
            NSString *p = [result objectAtIndex:0];
            if([p isEqualToString:password])
            {
                self.Start.enabled = YES;
            }
            else
            {
                UIAlertView *saveNote = [[UIAlertView alloc]
                            initWithTitle:@"Alert"
                            message:@"Password not matched"
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
                [saveNote show];

            }

        }
    });
}];
*/

    if ([self.PasswordField.text isEqualToString:password])
         {
             self.Start.enabled = YES;
         }
         else
         {
             UIAlertView *saveNote = [[UIAlertView alloc]
                                      initWithTitle:@"Alert"
                                      message:@"Password not matched"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
             [saveNote show];
             
         }
}

- (IBAction)DoSelectExistingProfile:(id)sender {
    NSArray *colName = [ NSArray arrayWithObjects:@"FirstName", @"LastName",@"Picture",@"Passward", nil];
    
    [[DbController shared] selectDataFromTable:@"PROFILE" withColumn:colName  withWhareClause:nil withCompletionBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *saveNote;
            if(error != nil)
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
    } andResultBlock:^(NSArray *result){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(result.count > 0 )
            {
                ProfileArray = [NSArray arrayWithArray:result];
                // show the the data
                self.ProfilePicker.hidden = NO;
                 [self.ProfilePicker reloadAllComponents];
                
            }
        });
    }];
    
    // Do any additional setup after loading the view from its nib.

}


// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"NewUser"])
    {
        //create the wish table
        NSLog(@"Preparing Profile table if not exists");
        
        NSMutableDictionary  *FirstName = [[NSMutableDictionary alloc] init];
        [FirstName setObject:@"FirstName" forKey:@"columnname"];
        [FirstName setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *LastName = [[NSMutableDictionary alloc] init];
        [LastName setObject:@"LastName" forKey:@"columnname"];
        [LastName setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *email = [[NSMutableDictionary alloc] init];
        [email setObject:@"email" forKey:@"columnname"];
        [email setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *PicturePath = [[NSMutableDictionary alloc] init];
        [PicturePath setObject:@"Picture" forKey:@"columnname"];
        [PicturePath setObject:@"TEXT" forKey:@"Type"];
        
        NSMutableDictionary  *Passward = [[NSMutableDictionary alloc] init];
        [Passward setObject:@"Passward" forKey:@"columnname"];
        [Passward setObject:@"TEXT" forKey:@"Type"];

        
        NSArray *colDataArray = [NSArray arrayWithObjects:FirstName,LastName,email,PicturePath,Passward,nil];
        
        //temp one
        [[DbController shared] dropTable:@"PROFILE" withCompletionBlock:nil];
        
        [[DbController shared] CreateTableIfNotExists:@"PROFILE" withColumn:colDataArray withPrimaryKey:@"FirstName" withCompletionBlock:nil];
        
        NSLog(@"Prepare PROFILE table if not exists");
    }
    else if ([[segue identifier] isEqualToString:@"GoMainPage"])
    {
        iWishUtil * wishUtil =  [iWishUtil shared];
        wishUtil.ProfileName = firstName;
        wishUtil.ImagePath  = imagePath;
        
    }
}


#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [ProfileArray count];
}


#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * fullRow = [ProfileArray objectAtIndex:row];
    NSArray *subStrings = [fullRow componentsSeparatedByString:@","];
    return [subStrings objectAtIndex:0];
}



- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString * fullRow = [ProfileArray objectAtIndex:row];
    NSArray *subStrings = [fullRow componentsSeparatedByString:@","];
    firstName = [subStrings objectAtIndex:0];
    lastName  = [subStrings objectAtIndex:1];
    imagePath = [subStrings objectAtIndex:2];
    password  = [subStrings objectAtIndex:3];
    self.PasswordField.hidden   = NO;
    self.PasscodeLb.hidden      = NO;
    self.CheckProfile.hidden    = NO;

}


#pragma mark -
#pragma mark === Text Field Delegate ===
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return YES;
}


@end
