//
//  ViewController.m
//  SJNetworking
//
//  Created by Surjit Joshi on 24/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DataStorage_AllRows.h"
#import "CustomTableViewCell.h"

@interface ViewController()
{
    AppDelegate *mainDelegate;
}
@end

@implementation ViewController
@synthesize dataHandler;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Display_RowData:)
                                                 name:@"Display_RowData" object:nil];
    self.dataHandler = [[DataHandler alloc] init];

    self.tableView.frame = CGRectMake(0, 0, mainDelegate.screenWidth, mainDelegate.screenHeight+64);
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [[NSNotificationCenter defaultCenter] addObserver:self.tableView  selector:@selector(reloadData)    name:UIContentSizeCategoryLarge  object:nil];
    
    
    // add device orientatio listener
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(arrangeSubviewsAccordingToOrientation)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    // update ui
    [self arrangeSubviewsAccordingToOrientation];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

// update screen data
- (void) Display_RowData:(NSNotification *)pObjNotification
{
    dispatch_async(dispatch_get_main_queue(), ^()  {
        
        [self.tableView reloadData];
        
    });
}

-(void) reloadData
{
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainDelegate.dataStorage_AllRows.allRowsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DataStorage_OneRow *dataStorage_OneRow = [mainDelegate.dataStorage_AllRows.allRowsArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ImageOnCell";
    
    CGFloat labelWidth = mainDelegate.screenWidth;
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
       [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        labelWidth = mainDelegate.screenHeight;
    }
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell != nil)
    {
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
    }
    else
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(296, 296);
    
    cell.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5.0, 0, 0)];
    cell.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.titleLabel.backgroundColor = [UIColor redColor];
    cell.titleLabel.text = dataStorage_OneRow.title;
    
    //cell.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CGSize expectedLabelSize1 = [dataStorage_OneRow.title sizeWithFont:cell.titleLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.titleLabel.lineBreakMode];
    //adjust the label the the new height.
    CGRect newFrame1 = cell.titleLabel.frame;
    newFrame1.size.height = expectedLabelSize1.height;
    newFrame1.size.width = labelWidth-110;

    cell.titleLabel.frame = newFrame1;
    CGFloat num1 = expectedLabelSize1.height/cell.titleLabel.font.lineHeight;
    cell.titleLabel.numberOfLines = num1;
    [cell.contentView addSubview:cell.titleLabel];
    
    
    cell.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 25.0, 0, 0)];
    cell.descriptionLabel.font = [UIFont systemFontOfSize:14.0];
    cell.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    cell.descriptionLabel.textColor = [UIColor darkGrayColor];
    cell.descriptionLabel.backgroundColor = [UIColor greenColor];
    cell.descriptionLabel.text = dataStorage_OneRow.description;
    
    //cell.descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CGSize expectedLabelSize2 = [dataStorage_OneRow.description sizeWithFont:cell.descriptionLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.descriptionLabel.lineBreakMode];
    //adjust the label the the new height.
    CGRect newFrame2 = cell.descriptionLabel.frame;
    newFrame2.size.height = expectedLabelSize2.height;
    newFrame2.size.width = labelWidth-110;
    cell.descriptionLabel.frame = newFrame2;
    
    CGFloat num2 = expectedLabelSize2.height/cell.descriptionLabel.font.lineHeight;
    cell.descriptionLabel.numberOfLines = num2;
    [cell.contentView addSubview:cell.descriptionLabel];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateHeightForRow : indexPath];
}

-(CGFloat) calculateHeightForRow : (NSIndexPath *) indexPath
{
    CGFloat totalHeight = 44;
    
    if([mainDelegate.dataStorage_AllRows.allRowsArray count] > 0)
    {
        DataStorage_OneRow *dataStorage_OneRow = [mainDelegate.dataStorage_AllRows.allRowsArray objectAtIndex:indexPath.row];
        
        CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
        
        //cell.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        CGSize expectedLabelSize1 = [dataStorage_OneRow.title sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat textLabel1Height = expectedLabelSize1.height;
        
        
        //cell.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        CGSize expectedLabelSize2 = [dataStorage_OneRow.description sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat detailTextLabel1Height = expectedLabelSize2.height;
        
        totalHeight = textLabel1Height+detailTextLabel1Height+10;
    }
    
    return totalHeight;
}


#pragma mark -
#pragma mark Orientation methods


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return TRUE;
}

-(void) arrangeSubviewsAccordingToOrientation
{
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
