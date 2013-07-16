//
//  AppDelegate.m
//  iWish
//
//  Created by Suman Chatterjee on 19/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "AppDelegate.h"
#import "WishBuilderViewController.h"
#import "DbController.h"
#import "iWishUtil.h"

@interface AppDelegate ()

// @brief   Root view controller.
@property (strong, nonatomic) IBOutlet UINavigationController *navigation;


@end

@implementation AppDelegate

NSString *kRemindMeNotificationDataKey = @"kRemindMeNotificationDataKey";

#pragma mark -
#pragma mark === Application Delegate Methods ===
#pragma mark -


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
	Class cls = NSClassFromString(@"UILocalNotification");
	if (cls) {
		UILocalNotification *notification = [launchOptions objectForKey:
                                             UIApplicationLaunchOptionsLocalNotificationKey];
		
		if (notification) {
			NSString *reminderText = [notification.userInfo
									  objectForKey:kRemindMeNotificationDataKey];
            WishBuilderViewController* viewcontroller = (WishBuilderViewController*)self.window.rootViewController;
			[viewcontroller  showReminder:reminderText];
		}
	}
	
	application.applicationIconBadgeNumber = 0;
    
    
    // create and use CURRENTUSER table which is only one row table
    NSString *storyboardName = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?@"MainStoryboard_iPad":@"MainStoryboard_iPhone";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    __block NSString *vcString;
    NSLog(@"Preparing CURRENTUSER table if not exists");
    
    NSMutableDictionary  *FirstName = [[NSMutableDictionary alloc] init];
    [FirstName setObject:@"FirstName" forKey:@"columnname"];
    [FirstName setObject:@"TEXT" forKey:@"Type"];
    
    NSMutableDictionary  *LastName = [[NSMutableDictionary alloc] init];
    [LastName setObject:@"LastName" forKey:@"columnname"];
    [LastName setObject:@"TEXT" forKey:@"Type"];
    
    NSMutableDictionary  *Passward = [[NSMutableDictionary alloc] init];
    [Passward setObject:@"Passward" forKey:@"columnname"];
    [Passward setObject:@"TEXT" forKey:@"Type"];
  
    NSMutableDictionary  *PicturePath = [[NSMutableDictionary alloc] init];
    [PicturePath setObject:@"Picture" forKey:@"columnname"];
    [PicturePath setObject:@"TEXT" forKey:@"Type"];
 
    
    NSArray *colDataArray = [NSArray arrayWithObjects:FirstName,LastName,Passward,PicturePath,nil];
    
    //temp one
    //[[DbController shared] dropTable:@"CURRENTUSER" withCompletionBlock:nil];
    
    [[DbController shared] CreateTableIfNotExists:@"CURRENTUSER" withColumn:colDataArray withPrimaryKey:@"FirstName" withCompletionBlock:nil];
    
    NSArray *colName = [ NSArray arrayWithObjects:@"FirstName",@"LastName",@"Passward",@"Picture",nil];
    [[DbController shared] selectDataFromTable:@"CURRENTUSER" withColumn:colName  withWhareClause:nil withCompletionBlock:nil  andResultBlock:^(NSArray *result){
            if(result.count > 0 )
            {
                vcString =@"MainViewController";
                NSString * fullRow = [result objectAtIndex:0];
                NSArray *subStrings = [fullRow componentsSeparatedByString:@","];
                [iWishUtil shared].ProfileName = [subStrings objectAtIndex:0];
                [iWishUtil shared].ProfileLastName  = [subStrings objectAtIndex:1];
                [iWishUtil shared].ProfileCode = [subStrings objectAtIndex:2];
                [iWishUtil shared].ImagePath =  [subStrings objectAtIndex:3];
            }
            else
            {
                vcString =@"LoginViewController";
               
            }
    }];
    
    // Set root view controller and make windows visible
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcString];
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:vc];

    self.window.rootViewController = navigationController;
     [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	
	application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
	
	// UIApplicationState state = [application applicationState];
	// if (state == UIApplicationStateInactive) {
    
    // Application was in the background when notification
    // was delivered.
	// }
	
	
	application.applicationIconBadgeNumber = 0;
	NSString *reminderText = [notification.userInfo
							  objectForKey:kRemindMeNotificationDataKey];
    WishBuilderViewController* viewcontroller = (WishBuilderViewController*)self.window.rootViewController;
    [viewcontroller  showReminder:reminderText];
}


@end
