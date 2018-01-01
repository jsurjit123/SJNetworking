//
//  DataProvider.h
//  SJNetworking
//
//  Created by Surjit Joshi on 28/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import <Foundation/Foundation.h>

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface DataProvider : NSObject <NSURLConnectionDelegate>

/******************************************************************************
 *           Public Variables
 ******************************************************************************/

@property (nonatomic, retain) NSString *urlForWebService;
@property (nonatomic, copy) void (^completionHandler)(void);

/******************************************************************************
 *           Public Methods/Functions
 ******************************************************************************/

-(id)initWithURLStr:(NSString *)objectURLStr;
-(void)startUpdating;
-(void)stopUpdating;



@end
