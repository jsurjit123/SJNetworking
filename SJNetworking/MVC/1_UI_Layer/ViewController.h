//
//  ViewController.h
//  SJNetworking
//
//  Created by Surjit Joshi on 24/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "DataHandler.h"
#import "AppMacros.h"

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface ViewController : UITableViewController

/******************************************************************************
 *           Public Variables
 ******************************************************************************/

// object for data handler which provides data
@property (nonatomic, retain) DataHandler *dataHandler;

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;


/******************************************************************************
 *           Public Methods/Functions
 ******************************************************************************/

-(CGFloat) calculateHeightForRow : (NSIndexPath *) indexPath;
-(CGSize) getSizeRequiredForLabel : (NSString *) textForLabel : (UIFont *) font;

@end

