//
//  DataHandler.m
//  SJNetworking
//
//  Created by Surjit Joshi on 28/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import "DataHandler.h"
#import "AppDelegate.h"

/******************************************************************************
 *                                     Interface Declation
 ******************************************************************************/

@interface DataHandler()
{
    AppDelegate *mainDelegate;
}

@end

/******************************************************************************
 *                                     Interface Definition
 ******************************************************************************/

@implementation DataHandler
@synthesize dataProvider;

/*
 * Function Name        : init
 *
 * Author               : Surjit Joshi
 *
 * Description          : Start the Data Layer and receives JSON data
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

// this method called when object of this class is instantiated
-(id)init
{
    self = [super init];
    
    if(self)
    {
        // object of AppDelegate to access objects and methods defined in AppDelegate implementation
        mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

        // add listener for "JSONData" message to be broadcasted by Data layer class
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(GET_JSONData:)
                                                     name:@"JSONData" object:nil];
        
        // initialize Data Layer
        self.dataProvider = [[DataProvider alloc] initWithURLStr:@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"];
    }
    
    return self;
}


/*
 * Function Name        : stopDataDownload
 *
 * Author               : Surjit Joshi
 *
 * Description          : Destroys Business Layer classes
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

-(void) stopSendingData
{
    // stop listening to message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JSONData" object:nil];
    
    // destroy objects
    [self.dataProvider stopUpdating];
    self.dataProvider = nil;
}


/*
 * Function Name        : GET_JSONData
 *
 * Author               : Surjit Joshi
 *
 * Description          : Receives JSON data from Data Layer, parses it and send to UI Layer
 *
 * Detailed description : -
 *
 * ParaIn               : pObjNotification - provides row JSON data
 *
 * ParaOut              : -
 *
 * Return               : -
 */

// update screen data
- (void) GET_JSONData:(NSNotification *)pObjNotification
{
    if(pObjNotification == nil)
    {
        // broadcast the data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Display_RowData" object:@"DataNotReceived"];
    }
    
    if(pObjNotification.object == nil)
    {
        // broadcast the data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Display_RowData" object:@"DataNotReceived"];
    }
    
    if([pObjNotification.object isKindOfClass:[NSMutableData class]])
    {
        // convert row data to NSMutableData
        NSMutableData *data = (NSMutableData *) pObjNotification.object;
        
        // convert raw data to string using "NSISOLatin1StringEncoding" encoding
        // NSISOLatin1StringEncoding is required as there are special characters in JSON information
        
        NSString *dataFromJSON = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        NSLog(@"Before parsing: %@", dataFromJSON);

        // convert String to Data using "NSUTF8StringEncoding" encoding
        // this extra step is required to overcome issue of difference between "NSISOLatin1StringEncoding" and "NSUTF8StringEncoding"
        NSData *resData = [dataFromJSON dataUsingEncoding:NSUTF8StringEncoding];

        // use default parser to serialize JSON data
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&localError];
        
        // check for parser error
        if (localError != nil)
        {
            NSLog(@"Parser Error");
            
            // broadcast the data
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Display_RowData" object:@"DataNotReceived"];
        }
        else
        {
            // store title
            mainDelegate.dataStorage_AllRows.mainTitle = [parsedObject valueForKey:@"title"];
            
            // store all rows to array
            mainDelegate.dataStorage_AllRows.allRowsArray = [[NSMutableArray alloc] init];
            
            NSArray *allDataRowsOfJSON = [parsedObject valueForKey:@"rows"];
            //NSLog(@"Count %lu", (unsigned long)allDataRowsOfJSON.count);
            
            for (NSDictionary *oneRowDict in allDataRowsOfJSON)
            {
                // create one row information
                DataStorage_OneRow *dataStorage_OneRow = [[DataStorage_OneRow alloc] init];
                
                // check for NULL
                if(!([oneRowDict objectForKey:@"title"] == nil ||
                     [[oneRowDict objectForKey:@"title"] isKindOfClass:[NSNull class]] ||
                     [[oneRowDict objectForKey:@"title"] length] == 0))
                {
                    dataStorage_OneRow.title = [oneRowDict objectForKey:@"title"];
                }
                else
                {
                    // default value
                    dataStorage_OneRow.title = @" ";
                }
                
                // check for NULL
                if(!([oneRowDict objectForKey:@"description"] == nil ||
                     [[oneRowDict objectForKey:@"description"] isKindOfClass:[NSNull class]] ||
                     [[oneRowDict objectForKey:@"description"] length] == 0))
                {
                    dataStorage_OneRow.description = [oneRowDict objectForKey:@"description"];
                }
                else
                {
                    // default value
                    dataStorage_OneRow.description = @" ";
                }

                
                // check for NULL
                if(!([oneRowDict objectForKey:@"imageHref"] == nil ||
                     [[oneRowDict objectForKey:@"imageHref"] isKindOfClass:[NSNull class]] ||
                     [[oneRowDict objectForKey:@"imageHref"] length] == 0))
                {
                    dataStorage_OneRow.imageHref = [oneRowDict objectForKey:@"imageHref"];
                }
                else
                {
                    // default value
                    dataStorage_OneRow.imageHref = @" ";
                }
                
                
                if(!([dataStorage_OneRow.title isEqualToString:@" "] &&
                   [dataStorage_OneRow.description isEqualToString:@" "] &&
                   [dataStorage_OneRow.imageHref isEqualToString:@" "]))
                {
                    // add one row information if all the objects are valid
                    [mainDelegate.dataStorage_AllRows.allRowsArray addObject:dataStorage_OneRow];
                }
            }
        }
        
        // broadcast the data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Display_RowData" object:@"DataReceived"];
    }
    else
    {
        // broadcast the data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Display_RowData" object:@"DataNotReceived"];
    }
}

@end
