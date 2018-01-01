//
//  DataStorage.h
//  SJNetworking
//
//  Created by Surjit Joshi on 29/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface DataStorage_AllRows : NSObject


/******************************************************************************
 *           Public Variables
 ******************************************************************************/

@property (nonatomic, retain)  NSString *mainTitle;
@property (nonatomic, retain)  NSMutableArray *allRowsArray;

@end

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/




@interface DataStorage_OneRow : NSObject

/******************************************************************************
 *           Public Variables
 ******************************************************************************/

@property (nonatomic, retain)  NSString *title;
@property (nonatomic, retain)  NSString *description;
@property (nonatomic, retain)  NSString *imageHref;
@property (nonatomic, retain)  UIImage  *iconImage;
@property                      CGFloat   rowHeight;

@end
