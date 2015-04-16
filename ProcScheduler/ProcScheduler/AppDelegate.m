//
//  AppDelegate.m
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "UploadImageController.h"


@interface AppDelegate ()
{
    UploadImageController *uploadController;
}
@end

@implementation AppDelegate

NSString *const FILE_UPLOAD = @"FILE_UPLOAD";
NSString *const FILE_DOWNLOAD = @"FILE_DOWNLOAD";
NSString *const DATA_TRANSFER = @"DATA_TRANSFER";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [Parse setApplicationId:@"cd3wYGnFJk6xu3pUfIEaWhkdey1WjSWr6TGmwTjH" clientKey:@"3ucnOuyb4XNJvzsVcQNKhECqaDmMBQgK3nzPPAlj"];

    //Register for Local Notifications
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //Handle local notification
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        [self handleLocalNotification:localNotif];
        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    for (int i=0; i<[scheduledNotifications count]; i++)
//    {
//        [self handleLocalNotification:[scheduledNotifications objectAtIndex:i]];
//     
//    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)handleLocalNotification:(UILocalNotification *)localNotif
{
    if ([localNotif.alertTitle isEqualToString:FILE_UPLOAD]) {
        
        uploadController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"uploadController"];
        [uploadController fileUpload:localNotif.userInfo];
    }
    else if ([localNotif.alertTitle isEqualToString:FILE_DOWNLOAD]) {
        
        uploadController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"uploadController"];
        [uploadController fileDownload:localNotif.userInfo];
    }
    else if ([localNotif.alertTitle isEqualToString:DATA_TRANSFER]) {
        
        uploadController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"uploadController"];
        [uploadController dataTransfer:localNotif.userInfo];
    }
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    
    [self handleLocalNotification:notif];
    
    app.applicationIconBadgeNumber = notif.applicationIconBadgeNumber - 1;
    
}
@end
