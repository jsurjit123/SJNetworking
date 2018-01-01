//
//  DataProvider.h
//  SJNetworking
//
//  Created by Surjit Joshi on 28/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject <NSURLConnectionDelegate>
{
    NSURLConnection *theConnection;
    
}

@property (nonatomic, retain) NSString *urlForWebService;
@property (nonatomic, retain) NSMutableData *receivedData;

-(id)initWithURLStr:(NSString *)objectURLStr;
-(void)startUpdating;
-(void)stopUpdating;

@property (nonatomic, copy) void (^completionHandler)(void);


@end
