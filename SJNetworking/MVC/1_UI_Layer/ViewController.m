//
//  ViewController.m
//  SJNetworking
//
//  Created by Surjit Joshi on 24/12/17.
//  Copyright © 2017 Surjit Joshi. All rights reserved.
//

/******************************************************************************
 *                                     Header Files
 ******************************************************************************/

#import "ViewController.h"
#import "AppDelegate.h"
#import "DataStorage_AllRows.h"
#import "CustomTableViewCell.h"
#import "IconDownloader.h"
#import "Reachability.h"

/******************************************************************************
 *                                     Interface Declaration
 ******************************************************************************/

@interface ViewController()
{
    AppDelegate *mainDelegate;
}


/******************************************************************************
 *           Public Variables
 ******************************************************************************/

@property (nonatomic) Reachability *internetReachability;

@end


/******************************************************************************
 *                                     Interface Definition
 ******************************************************************************/

@implementation ViewController
@synthesize dataHandler;
@synthesize imageDownloadsInProgress;

#pragma mark - ViewController Methods

/*
 * Function Name        : viewDidLoad, viewWillAppear, viewDidAppear, viewWillDisappear
 *
 * Author               : Surjit Joshi
 *
 * Description          : Default function called when this screen appears/disappears
 *
 * Detailed description : Set all screen initialization objects and UI positions
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // object of AppDelegate to access objects and methods defined in AppDelegate implementation
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // refresh button on right side of Navigation bar
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RefreshIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshScreenData:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    // configure default visibility of tableview
    self.tableView.hidden = TRUE;
    self.tableView.frame = CGRectMake(0, 0, mainDelegate.screenWidth, mainDelegate.screenHeight+64);
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // initialize Reachability class
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    // initialize object to store status of images to be downloaded
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    // start getting data for screen
    [self startDataDownload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // add device orientation listener
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(arrangeSubviewsAccordingToOrientation)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    // update UI
    [self arrangeSubviewsAccordingToOrientation];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // destrot objects
    [self stopDataDownload];
}

#pragma mark - Reachability Methods

/*
 * Function Name        : reachabilityChanged
 *
 * Author               : Surjit Joshi
 *
 * Description          : Called by Reachability whenever status changes.
 *
 * Detailed description : -
 *
 * ParaIn               : NSNotification
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
}

#pragma mark - Data Download Methods

/*
 * Function Name        : startDataDownload
 *
 * Author               : Surjit Joshi
 *
 * Description          : Initialize Business Layer classes depending upon Reachability
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void) startDataDownload {
    
    // get current network status
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    
    // check network status
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"NotReachable");
            UIAlertController *noDataAlertController = [UIAlertController alertControllerWithTitle:@"SJNetworking"
                                                                                           message:@"Please check your internet connection."
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            // You can add as many actions as you want
            UIAlertAction *okButtonAction = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       [self noDataAlertMethod];
                                                                   }];
            
            // Add actions to the controller so they will appear
            [noDataAlertController addAction:okButtonAction];
            
            // Finally present the action
            [self presentViewController:noDataAlertController animated:true completion:nil];
            
            break;
        }
        case ReachableViaWWAN:
        case ReachableViaWiFi:
        {
            NSLog(@"ReachableViaWWAN/ReachableViaWiFi");
            
            // add listener for "Display_RowData" message to be broadcasted by Business layer class
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(Display_RowData:)
                                                         name:@"Display_RowData" object:nil];
            
            // initialize Business Layer
            self.dataHandler = [[DataHandler alloc] init];
            
            break;
        }
    }
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

- (void) stopDataDownload
{
    // remove all subscribed listeners and deallocate objects
    [self terminateAllDownloads];
    
    [self.dataHandler stopSendingData];
    self.dataHandler = nil;
}

/*
 * Function Name        : Display_RowData
 *
 * Author               : Surjit Joshi
 *
 * Description          : Refresh UITableView with data stored in Model classes
 *
 * Detailed description : -
 *
 * ParaIn               : pObjNotification - provides string info
 *
 * ParaOut              : -
 *
 * Return               : -
 */

// update screen data
- (void) Display_RowData:(NSNotification *)pObjNotification {
    
    dispatch_async(dispatch_get_main_queue(), ^()  {
        
        if(pObjNotification == nil)
        {
            // broadcast the data
            return;
        }
        
        if(pObjNotification.object == nil)
        {
            // broadcast the data
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Display_RowData" object:@"DataNotReceived"];
            
        }
        
        if([pObjNotification.object isKindOfClass:[NSString class]])
        {
            // convert NSNotification to NSString
            NSString *responseInfo = (NSString *) pObjNotification.object;
            
            // check if data is properly received
            if([responseInfo isEqualToString:@"DataNotReceived"])
            {
                // show alert  - DataNotReceived
                UIAlertController *noDataAlertController = [UIAlertController alertControllerWithTitle:@"SJNetworking"
                                                                                              message:@"Data not received OR there might be error with your connection."
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                // You can add as many actions as you want
                UIAlertAction *okButtonAction = [UIAlertAction actionWithTitle:@"OK"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction *action) {
                                                                           [self noDataAlertMethod];
                                                                       }];
                
                // Add actions to the controller so they will appear
                [noDataAlertController addAction:okButtonAction];
                
                // Finally present the action
                [self presentViewController:noDataAlertController animated:true completion:nil];
            }
            else
            {
                // data received
                
                // populate title on navigation bar
                self.title = mainDelegate.dataStorage_AllRows.mainTitle;
                
                // refresh the table now
                self.tableView.hidden = FALSE;
                [self.tableView reloadData];
            }
        }
        
    });
}

#pragma mark - Button Action Methods

/*
 * Function Name        : refreshScreenData
 *
 * Author               : Surjit Joshi
 *
 * Description          : Removes existing data from table and Model classes and calls Business layer classes
 *
 * Detailed description : -
 *
 * ParaIn               : sender - reference to button
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (IBAction) refreshScreenData:(id)sender {
    
    self.tableView.hidden = TRUE;
    
    self.title = @"";
    
    mainDelegate.dataStorage_AllRows.mainTitle = NULL;
    
    if(mainDelegate.dataStorage_AllRows.allRowsArray != NULL)
    {
        if([mainDelegate.dataStorage_AllRows.allRowsArray count] > 0)
        {
            [mainDelegate.dataStorage_AllRows.allRowsArray removeAllObjects];
        }
    }
    
    [self startDataDownload];
}

/*
 * Function Name        : noDataAlertMethod
 *
 * Author               : Surjit Joshi
 *
 * Description          : -
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void) noDataAlertMethod {
    
}


/*
 * Function Name        : UITableView Delegate & Data Source Methods
 *
 * Author               : Surjit Joshi
 *
 * Description          : UITableView Delegate & Data Source Methods
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [mainDelegate.dataStorage_AllRows.allRowsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateHeightForRow : indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // get data for cell from storage
    DataStorage_OneRow *dataStorage_OneRow = [mainDelegate.dataStorage_AllRows.allRowsArray objectAtIndex:indexPath.row];
    
    // decide width of cell depending upon orienation
    CGFloat labelWidth = mainDelegate.screenWidth;
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
       [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        labelWidth = mainDelegate.screenHeight;
    }
    
    /* START - CONFIGURE CELL  */
    static NSString *CellIdentifier = @"SJNETWORKING";

    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell != nil)
    {
        // Remove existing views from cell's contentview to avoid cell content overlapping
        for(UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
    }
    else
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /* END - CONFIGURE CELL  */

    /* START - CONFIGURE TITLE  */

    cell.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5.0, 0, 0)];
    cell.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.titleLabel.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = dataStorage_OneRow.title;
    
    // calculate height & width for label
    CGSize expectedLabelSize1 = [self getSizeRequiredForLabel : dataStorage_OneRow.title : [UIFont systemFontOfSize:16.0]];
    //adjust the label the the new height.
    CGRect newFrame1 = cell.titleLabel.frame;
    newFrame1.size.height = expectedLabelSize1.height;
    newFrame1.size.width = labelWidth-110;

    // calculate number of rows for label
    cell.titleLabel.frame = newFrame1;
    CGFloat num1 = expectedLabelSize1.height/cell.titleLabel.font.lineHeight;
    cell.titleLabel.numberOfLines = num1;
    
    [cell.contentView addSubview:cell.titleLabel];
    
    /* END - CONFIGURE TITLE  */

    /* START - CONFIGURE DESCRIPTION  */

    cell.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 25.0, 0, 0)];
    cell.descriptionLabel.font = [UIFont systemFontOfSize:14.0];
    cell.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    cell.descriptionLabel.textColor = [UIColor lightGrayColor];
    cell.descriptionLabel.backgroundColor = [UIColor clearColor];
    cell.descriptionLabel.text = dataStorage_OneRow.description;
    
    // calculate height & width for label
    CGSize expectedLabelSize2 = [self getSizeRequiredForLabel : dataStorage_OneRow.description : [UIFont systemFontOfSize:14.0]];
    //adjust the label the the new height.
    CGRect newFrame2 = cell.descriptionLabel.frame;
    newFrame2.size.height = expectedLabelSize2.height;
    newFrame2.size.width = labelWidth-110;
    cell.descriptionLabel.frame = newFrame2;
    
    // calculate number of rows for label
    CGFloat num2 = expectedLabelSize2.height/cell.descriptionLabel.font.lineHeight;
    cell.descriptionLabel.numberOfLines = num2;
    [cell.contentView addSubview:cell.descriptionLabel];
    
    /* END - CONFIGURE DESCRIPTION  */

    dataStorage_OneRow.rowHeight = [self calculateHeightForRow : indexPath];
    
    
    /* START - CONFIGURE IMAGEVIEW  */

    cell.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, dataStorage_OneRow.rowHeight-10)];
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!dataStorage_OneRow.iconImage)
    {
        // check if valid URL is there for image
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO &&
            [dataStorage_OneRow.imageHref isEqualToString:@" "] == FALSE)
        {
            [self startIconDownload:dataStorage_OneRow forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.iconImageView.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        // default image
        cell.iconImageView.image = dataStorage_OneRow.iconImage;
    }

    [cell.contentView addSubview:cell.iconImageView];

    /* END - CONFIGURE IMAGEVIEW  */
    
    
    // configure the cell & table with custom paramters
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    tableView.separatorColor = [UIColor lightGrayColor];
    
    return cell;
}



/*
 * Function Name        : calculateHeightForRow
 *
 * Author               : Surjit Joshi
 *
 * Description          : Calculates height for row by adding title and description label heights
 *
 * Detailed description : -
 *
 * ParaIn               : indexPath - reference to row
 *
 * ParaOut              : -
 *
 * Return               : CGFloat - height required for row
 */

- (CGFloat) calculateHeightForRow : (NSIndexPath *) indexPath
{
    // default height
    CGFloat totalHeight = ROWHEIGHT_MIN;
    
    if([mainDelegate.dataStorage_AllRows.allRowsArray count] > 0)
    {
        // get data from specified row
        DataStorage_OneRow *dataStorage_OneRow = [mainDelegate.dataStorage_AllRows.allRowsArray objectAtIndex:indexPath.row];
        
        // calculate height for title label
        CGSize expectedLabelSize1 = [self getSizeRequiredForLabel : dataStorage_OneRow.title : [UIFont systemFontOfSize:16.0]];
        CGFloat textLabel1Height = expectedLabelSize1.height;
        
        // calculate height for description label
        CGSize expectedLabelSize2 = [self getSizeRequiredForLabel : dataStorage_OneRow.description : [UIFont systemFontOfSize:14.0]];
        CGFloat detailTextLabel1Height = expectedLabelSize2.height;
        
        // add both label heights
        totalHeight = textLabel1Height+detailTextLabel1Height+10;  // add some margin
    }
    
    return totalHeight;
}



/*
 * Function Name        : getSizeRequiredForLabel
 *
 * Author               : Surjit Joshi
 *
 * Description          : Calculates height for row by adding title and description label heights
 *
 * Detailed description : -
 *
 * ParaIn               : textForLabel - text for label
 *                        font - font of label
 *
 * ParaOut              : -
 *
 * Return               : CGSize - size required for label
 */

- (CGSize) getSizeRequiredForLabel : (NSString *) textForLabel : (UIFont *) font
{
    // maximum height & width
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);

    // calculate size for label
    CGSize expectedLabelSize = [textForLabel sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize;
}



#pragma mark - Table cell image support

/*
 * Function Name        : startIconDownload
 *
 * Author               : Surjit Joshi
 *
 * Description          : Starts downloading of image for the row
 *
 * Detailed description : -
 *
 * ParaIn               : dataStorage_OneRow - Model class object
 *                        indexPath - reference of row
 *
 * ParaOut              : -
 *
 * Return               : CGSize - size required for label
 */

- (void)startIconDownload:(DataStorage_OneRow *)dataStorage_OneRow forIndexPath:(NSIndexPath *)indexPath
{
    //
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        // initialize
        iconDownloader = [[IconDownloader alloc] init];
        
        // provide data to iconDownloader
        iconDownloader.dataStorage_OneRow = dataStorage_OneRow;
        
        // on completetion
        [iconDownloader setCompletionHandler:^{
            
            //  assign image to cell's iconImageView
            CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.iconImageView.image = dataStorage_OneRow.iconImage;
            cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

/*
 * Function Name        : loadImagesForOnscreenRows
 *
 * Author               : Surjit Joshi
 *
 * Description          : Starts downloading the image for row after scrolling the tableview
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)loadImagesForOnscreenRows
{
    if ([mainDelegate.dataStorage_AllRows.allRowsArray count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            DataStorage_OneRow *dataStorage_OneRow = (mainDelegate.dataStorage_AllRows.allRowsArray)[indexPath.row];
            
            if (!dataStorage_OneRow.iconImage)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:dataStorage_OneRow forIndexPath:indexPath];
            }
        }
    }
}



#pragma mark - UIScrollViewDelegate

/*
 * Function Name        : scrollViewDidEndDragging:willDecelerate:
 *
 * Author               : Surjit Joshi
 *
 * Description          : Starts downloading the image for row after scrolling the tableview
 *
 * Detailed description : -
 *
 * ParaIn               : scrollView - reference to scrollview(default) of uitabelview
 *                        decelerate - boolean to know that acceleration has stopped
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self performSelector:@selector(loadImagesForOnscreenRows) withObject:nil afterDelay:0.2];
    }
}


/*
 * Function Name        : scrollViewDidEndDecelerating:scrollView
 *
 * Author               : Surjit Joshi
 *
 * Description          : When scrolling stops, proceed to load the app icons that are on screen.
 *
 * Detailed description : -
 *
 * ParaIn               : scrollView - reference to scrollview(default) of uitabelview
 *
 * ParaOut              : -
 *
 * Return               : -
 */

// -------------------------------------------------------------------------------
//    scrollViewDidEndDecelerating:scrollView
//
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // do stuff after some delay
    [self performSelector:@selector(loadImagesForOnscreenRows) withObject:nil afterDelay:0.2];
}


#pragma mark - Orientation methods

/*
 * Function Name        : shouldAutorotateToInterfaceOrientation:willDecelerate:
 *
 * Author               : Surjit Joshi
 *
 * Description          : -
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return TRUE;
}


/*
 * Function Name        : arrangeSubviewsAccordingToOrientation:willDecelerate:
 *
 * Author               : Surjit Joshi
 *
 * Description          : Listener method which reloads tableview after orientation change
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void) arrangeSubviewsAccordingToOrientation
{
    [self.tableView reloadData];
}



/*
 * Function Name        : terminateAllDownloads:willDecelerate:
 *
 * Author               : Surjit Joshi
 *
 * Description          : -
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

/*
 * Function Name        : dealloc:willDecelerate:
 *
 * Author               : Surjit Joshi
 *
 * Description          : -
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)dealloc
{
    // terminate all pending download connections
    [self terminateAllDownloads];
}

/*
 * Function Name        : didReceiveMemoryWarning
 *
 * Author               : Surjit Joshi
 *
 * Description          : -
 *
 * Detailed description : -
 *
 * ParaIn               : -
 *
 * ParaOut              : -
 *
 * Return               : -
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    [self terminateAllDownloads];
}



@end
