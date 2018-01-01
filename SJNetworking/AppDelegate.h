//
//  AppDelegate.h
//  SJNetworking
//
//  Created by Surjit Joshi on 24/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DataStorage_AllRows.h"

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/******************************************************************************
 *           Public Variables
 ******************************************************************************/

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

// main data storage object
@property (nonatomic, retain) DataStorage_AllRows *dataStorage_AllRows;

// Object to store screen's height and width
@property CGFloat screenWidth, screenHeight;

/******************************************************************************
 *           Public Methods/Functions
 ******************************************************************************/

-(void) getScreenResolution;

@end

