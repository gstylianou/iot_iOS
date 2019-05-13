//
//  AppDelegate.m
//  IOT
//
//  Created by Georgios Stylianou on 30/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import "AppDelegate.h"
#import "IOTCommunication.h"
#import "dbAccess.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize q;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//    [IOTCommunication getTVRemoteInstructions:@"JNqX4Rz6PW7n"];
//    [IOTCommunication sendIRInstruction:@"VolumeUp" forID:@"JNqX4Rz6PW7n"];
    

    [self createEditableCopyOfDatabaseIfNeeded:false];
    
    
    q=[[dbAccess alloc]init];
    
    
    return YES;
}


-(bool) createEditableCopyOfDatabaseIfNeeded:(bool)force {
    // First , test for existence .
    BOOL success ;
    NSFileManager * fileManager = [ NSFileManager defaultManager];
    NSError * error ;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask , YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * DBPath = [ documentsDirectory stringByAppendingPathComponent :@"iot.sqlite"];
    
    //  docPath=[paths objectAtIndex:0];
    
    success = [fileManager fileExistsAtPath:DBPath];
    if(success && !force)
    return false;
    // The writable database does not exist , so copy the                         default to the appropriate location .
    NSString * defaultDBPath = [[[NSBundle mainBundle]resourcePath ] stringByAppendingPathComponent :@"iot.sqlite"];
    
    if(success)
    [fileManager removeItemAtPath:DBPath error:&error];
    
    success = [fileManager copyItemAtPath : defaultDBPath toPath : DBPath error :& error ];
    if (!success )
    {
        NSAssert1 (0, @" Failed to create writable database file with message '%@ '." , [ error
                                                                                         localizedDescription ]);
    }
    else{
        NSURL*URL=[NSURL fileURLWithPath:DBPath];
       // success=[fileManager addSkipBackupAttributeToItemAtURL:URL];
        
        NSLog(@"Do not backup success=%d",success);
        
        
    }
    return true;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
