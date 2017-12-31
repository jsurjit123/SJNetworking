//
//  DataStorage.h
//  SJNetworking
//
//  Created by Surjit Joshi on 29/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStorage_AllRows : NSObject

@property (nonatomic, retain)  NSString *mainTitle;
@property (nonatomic, retain)  NSMutableArray *allRowsArray;

@end


@interface DataStorage_OneRow : NSObject

@property (nonatomic, retain)  NSString *title;
@property (nonatomic, retain)  NSString *description;
@property (nonatomic, retain)  NSString *imageHref;

@end
