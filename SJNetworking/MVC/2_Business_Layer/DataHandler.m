//
//  DataHandler.m
//  SJNetworking
//
//  Created by Surjit Joshi on 28/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

#import "DataHandler.h"
#import "AppDelegate.h"

@interface DataHandler()
{
    AppDelegate *mainDelegate;
}

@end

@implementation DataHandler
@synthesize dataProvider;

// this method called when object of this class is instantiated
-(id)init
{
    self = [super init];
    
    if(self)
    {
        mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(GET_JSONData:)
                                                     name:@"JSONData" object:nil];
        
        self.dataProvider = [[DataProvider alloc] initWithURLStr:@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"];
    }
    
    return self;
}

-(void) stopSendingData
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JSONData" object:nil];
    [self.dataProvider stopUpdating];
    self.dataProvider = nil;
}

// update screen data
- (void) GET_JSONData:(NSNotification *)pObjNotification
{
    if(pObjNotification == nil)
    {
        return;
    }
    
    if(pObjNotification.object == nil)
    {
        return;
    }
    
    if([pObjNotification.object isKindOfClass:[NSMutableData class]])
    {
        NSMutableData *data = (NSMutableData *) pObjNotification.object;
        NSString *dataFromJSON = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        NSLog(@"Before parsing: %@", dataFromJSON);

        NSData *resData = [dataFromJSON dataUsingEncoding:NSUTF8StringEncoding];

        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&localError];
        
        if (localError != nil)
        {
            NSLog(@"Parser Error");
        }
        else
        {
            mainDelegate.dataStorage_AllRows.mainTitle = [parsedObject valueForKey:@"title"];
            mainDelegate.dataStorage_AllRows.allRowsArray = [[NSMutableArray alloc] init];
            
            NSArray *allDataRowsOfJSON = [parsedObject valueForKey:@"rows"];
            NSLog(@"Count %lu", (unsigned long)allDataRowsOfJSON.count);
            
            for (NSDictionary *oneRowDict in allDataRowsOfJSON)
            {
                DataStorage_OneRow *dataStorage_OneRow = [[DataStorage_OneRow alloc] init];
                
                
                if(!([oneRowDict objectForKey:@"title"] == nil ||
                     [[oneRowDict objectForKey:@"title"] isKindOfClass:[NSNull class]] ||
                     [[oneRowDict objectForKey:@"title"] length] == 0))
                {
                    dataStorage_OneRow.title = [oneRowDict objectForKey:@"title"];
                }
                else
                {
                    dataStorage_OneRow.title = @" ";
                }
                
                
                if(!([oneRowDict objectForKey:@"description"] == nil ||
                     [[oneRowDict objectForKey:@"description"] isKindOfClass:[NSNull class]] ||
                     [[oneRowDict objectForKey:@"description"] length] == 0))
                {
                    dataStorage_OneRow.description = [oneRowDict objectForKey:@"description"];
                    
                    //dataStorage_OneRow.description = @"Warmer than you might think.";
                }
                else
                {
                    dataStorage_OneRow.description = @" ";
                }

                
                if(!([oneRowDict objectForKey:@"imageHref"] == nil ||
                     [[oneRowDict objectForKey:@"imageHref"] isKindOfClass:[NSNull class]] ||
                     [[oneRowDict objectForKey:@"imageHref"] length] == 0))
                {
                    dataStorage_OneRow.imageHref = [oneRowDict objectForKey:@"imageHref"];
                }
                else
                {
                    dataStorage_OneRow.imageHref = @" ";
                }
                
                
                if(!([dataStorage_OneRow.title isEqualToString:@" "] &&
                   [dataStorage_OneRow.description isEqualToString:@" "] &&
                   [dataStorage_OneRow.imageHref isEqualToString:@" "]))
                {
                    [mainDelegate.dataStorage_AllRows.allRowsArray addObject:dataStorage_OneRow];
                }
            }
        }
        
        NSLog(@"Title : %@", mainDelegate.dataStorage_AllRows.mainTitle);
        NSLog(@"allRowsArray : %@", mainDelegate.dataStorage_AllRows.allRowsArray);

        
        // broadcast the data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Display_RowData" object:nil];
        
    }
}

@end
