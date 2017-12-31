//
//  ViewController.h
//  SJNetworking
//
//  Created by Surjit Joshi on 24/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"
#import "AppMacros.h"

@interface ViewController : UITableViewController


@property (nonatomic, retain) DataHandler *dataHandler;

-(CGFloat) calculateHeightForRow : (NSIndexPath *) indexPath;

@end

