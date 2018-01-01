//
//  DataHandler.h
//  SJNetworking
//
//  Created by Surjit Joshi on 28/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "DataProvider.h"

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface DataHandler : NSObject


/******************************************************************************
 *           Public Variables
 ******************************************************************************/

@property (nonatomic, retain) DataProvider *dataProvider;

/******************************************************************************
 *           Public Methods/Functions
 ******************************************************************************/

-(void) stopSendingData;
- (void) GET_JSONData:(NSNotification *)pObjNotification;

@end
