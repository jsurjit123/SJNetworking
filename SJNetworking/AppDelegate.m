//
//  AppDelegate.m
//  SJNetworking
//
//  Created by Surjit Joshi on 24/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import "AppDelegate.h"

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@implementation AppDelegate
@synthesize dataStorage_AllRows;
@synthesize screenWidth, screenHeight;

/*
 * Function Name        : didFinishLaunchingWithOptions
 *
 * Author               : Surjit Joshi
 *
 * Description          : -
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // initialize window, rootviewcontroller and navigation controller
    [self initializeWindowWithNavigationController];
    
    // get resolution of screen
    [self getScreenResolution];
    
    // initialize storage for JSON data
    self.dataStorage_AllRows = [[DataStorage_AllRows alloc] init];
        
    return YES;
}

/*
 * Function Name        : initializeWindowWithNavigationController
 *
 * Author               : Surjit Joshi
 *
 * Description          : Initialize window, rootviewcontroller and navigation controller
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

-(void) initializeWindowWithNavigationController
{
    _rootViewController = [[ViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 3);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.25;
    self.navigationController.navigationBar.layer.masksToBounds = NO;
    self.navigationController.navigationBar.layer.shouldRasterize = YES;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:128.00/255.00 green:163.00/255.00 blue:194.00/255.00 alpha:1.0];
    
    // check current OS version
    if(iOS_Version >= 7)
    {
        // iOS7+ comes with new design of Navigation bar which includes Status bar in it
        // So, we have to specify the background color, appearance effect, font etc for Navigation bar
        
        self.navigationController.navigationBar.translucent = NO;
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:128.00/255.00 green:163.00/255.00 blue:194.00/255.00 alpha:1.0]];;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
        NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:attributes1];
    }
    
    // window
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.clipsToBounds = NO;
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
}

/*
 * Function Name        : getScreenResolution
 *
 * Author               : Surjit Joshi
 *
 * Description          : Get resolution of screen
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

-(void) getScreenResolution
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    if(iOS_Version >= 8.0)
    {
        if (screenSize.width > screenSize.height)
        {
            self.screenHeight = screenSize.width;
            self.screenWidth = screenSize.height;
        }
        else
        {
            self.screenHeight = screenSize.height;
            self.screenWidth = screenSize.width;
        }
    }
    else
    {
        self.screenHeight = screenSize.height;
        self.screenWidth = screenSize.width;
    }
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
