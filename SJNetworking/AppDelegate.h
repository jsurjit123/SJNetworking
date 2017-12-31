//
//  AppDelegate.h
//  SJNetworking
//
//  Created by Surjit Joshi on 24/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DataStorage_AllRows.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, retain) DataStorage_AllRows *dataStorage_AllRows;

// Object to store screen's height and width
@property CGFloat screenWidth, screenHeight;

-(void) getScreenResolution;

@end

