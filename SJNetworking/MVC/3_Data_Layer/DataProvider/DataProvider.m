//
//  DataProvider.m
//  SJNetworking
//
//  Created by Surjit Joshi on 28/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import "DataProvider.h"

/******************************************************************************
 *                                     Interface Definition
 ******************************************************************************/

@implementation DataProvider
@synthesize urlForWebService;

/*
 * Function Name        : initWithURLStr
 *
 * Author               : Surjit Joshi
 *
 * Description          : Start download for JSON data
 *
 * Detailed description : -
 *
 * ParaIn               : objectURLStr - URL for request
 *
 * ParaOut              : -
 *
 * Return               : -
 */

-(id)initWithURLStr:(NSString *)objectURLStr
{
    self = [super init];
    
    if(self)
    {
        self.urlForWebService = objectURLStr;
        
        [self startUpdating];
    }
    
    return self;
}

/*
 * Function Name        : startUpdating
 *
 * Author               : Surjit Joshi
 *
 * Description          : Start download for JSON data
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

// this method called to start retrieving data from URL
-(void)startUpdating
{
    // Create the request.
    NSURLRequest *theGETRequest = [NSURLRequest requestWithURL:
                     [NSURL URLWithString:self.urlForWebService]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                 timeoutInterval:5.0];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theGETRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error != nil)
         {
             // broadcast the data
             [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONData" object:NULL];
         }
         else
         {
             if([data length] > 0)
             {
                 // broadcast the data
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONData" object:data];
             }
             else
             {
                 // broadcast the data
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONData" object:NULL];
             }
             
             // call our completion handler to tell our client that our icon is ready for display
             if (self.completionHandler != nil)
             {
                 self.completionHandler();
             }
         }
     }];
}

// this method called to stop retrieving data from URL
-(void)stopUpdating
{
    
}

@end
