//
//  CustomTableViewCell.m
//  SJNetworking
//
//  Created by Surjit Joshi on 31/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import "CustomTableViewCell.h"

/******************************************************************************
 *                                     Interface Definition
 ******************************************************************************/

@implementation CustomTableViewCell

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize iconImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    
    return self;
}

@end
