//
//  CustomTableViewCell.h
//  SJNetworking
//
//  Created by Surjit Joshi on 31/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import <UIKit/UIKit.h>

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UIImageView *iconImageView;

/******************************************************************************
 *           Public Methods/Functions
 ******************************************************************************/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
