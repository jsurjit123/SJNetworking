//
//  DataProvider.m
//  SJNetworking
//
//  Created by Surjit Joshi on 28/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

#import "DataProvider.h"

@implementation DataProvider

@synthesize urlForWebService;
@synthesize receivedData;


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

// this method called to start retrieving data from URL
-(void)startUpdating
{
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    self.receivedData = [NSMutableData dataWithCapacity: 0];
    
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
    theConnection = nil;
    self.receivedData = nil;
}

@end
