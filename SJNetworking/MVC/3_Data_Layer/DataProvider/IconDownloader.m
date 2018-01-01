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

#import "IconDownloader.h"

/******************************************************************************
 *                                     Interface Definition
 ******************************************************************************/

@implementation IconDownloader
@synthesize dataStorage_OneRow;
@synthesize request;

/*
 * Function Name        : startDownload
 *
 * Author               : Surjit Joshi
 *
 * Description          : Start download for image
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)startDownload
{
    if(![self.dataStorage_OneRow.imageHref isEqualToString:@" "])
    {
        // create NSURLRequest with URL
        self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dataStorage_OneRow.imageHref]];
        
        // create queue for request
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        // create asynchronous request
        [NSURLConnection sendAsynchronousRequest:self.request queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             // error check
             if (error != nil)
             {
                 // default image
                 self.dataStorage_OneRow.iconImage = [UIImage imageNamed:@"Placeholder.png"];
             }
             else
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                     
                     if(data != NULL)
                     {
                         // Set appIcon and clear temporary data/image
                         UIImage *image = [[UIImage alloc] initWithData:data scale:1.0];
                         
                         if(image != NULL)
                         {
                             self.dataStorage_OneRow.iconImage = image;
                         }
                         else
                         {
                             // default image
                             self.dataStorage_OneRow.iconImage = [UIImage imageNamed:@"Placeholder.png"];
                         }
                     }
                     else
                     {
                         // default image
                         self.dataStorage_OneRow.iconImage = [UIImage imageNamed:@"Placeholder.png"];
                     }
                     
                     
                     // call our completion handler to tell our client that our icon is ready for display
                     if (self.completionHandler != nil)
                     {
                         self.completionHandler();
                     }
                 }];
             }
         }];
    }
    else
    {
        // default image
        self.dataStorage_OneRow.iconImage = [UIImage imageNamed:@"Placeholder.png"];
    }
}

/*
 * Function Name        : cancelDownload
 *
 * Author               : Surjit Joshi
 *
 * Description          : Cancel download for image
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)cancelDownload
{
    self.request = nil;
}

@end

