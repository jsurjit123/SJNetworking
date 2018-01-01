/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Helper object for managing the downloading of a particular app's icon.
  It uses NSURLSession/NSURLSessionDataTask to download the app's icon in the background if it does not
  yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 */

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "DataStorage_AllRows.h"

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface IconDownloader : NSObject <NSURLConnectionDelegate>

/******************************************************************************
 *           Public Variables
 ******************************************************************************/

@property (nonatomic, retain) DataStorage_OneRow *dataStorage_OneRow;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, copy) void (^completionHandler)(void);

/******************************************************************************
 *           Public Methods/Functions
 ******************************************************************************/

- (void)startDownload;
- (void)cancelDownload;

@end
