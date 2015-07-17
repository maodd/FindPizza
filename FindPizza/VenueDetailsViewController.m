//
//  VenueDetailsViewController.m
//
//  Created by İlyas Doğruer
//

#import "VenueDetailsViewController.h"

#import "Tools.h"
#import "UIImageView+Webcache_Animation.h"
#import "AFNetworking.h"

UIView                  *mainView;

UIBarButtonItem         *fsqBarButton;
UIBarButtonItem         *webBarButton;
UIBarButtonItem         *callBarButton;
UIBarButtonItem         *mapBarButton;

NSDictionary            *venueAttributes;
NSDictionary            *venueTimeFrames;
NSString                *_currentDateString;

BOOL                    detailsFirstTime = NO;
BOOL                    venueDetailsLoadedSuccessfully;

@interface VenueDetailsViewController ()

@end

@implementation VenueDetailsViewController

static CGFloat WindowHeight         = 270.0;
static CGFloat ImageHeight          = 400.0;
static CGFloat PageControlHeight    = 20.0f;
static CGFloat thumbSize            = 60;

@synthesize HUD                     = _HUD;
@synthesize detailsTableView        = _detailsTableView;
@synthesize currentVenue            = _currentVenue;
@synthesize configDictionary        = _configDictionary;
@synthesize venueDetailsDictionary  = _venueDetailsDictionary;
@synthesize socialShareMessage      = _socialShareMessage;
@synthesize socialShareImage        = _socialShareImage;
@synthesize venueTips               = _venueTips;

@synthesize photoDataSource         = _photoDataSource;

/************************************* VIEW LIFECYCLE METHODS ***********************************/
-(void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    //Setting NavigationBar Items
 
    
    
    //Setting Title View texts
    self.title =  [_currentVenue venueName];
 
    
    //Setting Progress HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _HUD.delegate=self;
    _HUD.labelColor = [Tools colorFromHexString:[[_configDictionary objectForKey:@"application"] objectForKey:@"loadingTextColor"] withAlpha:1.0];
    _HUD.opacity = 0;
    _HUD.labelText=NSLocalizedString(@"LoadingText", @"");
    _HUD.dimBackground=NO;
    
    //Setting ToolBar Buttons
    fsqBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"foursquareButton"] style:UIBarButtonItemStylePlain target:self action:@selector(openVenueOn4sq)];
    webBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"webButton"] style:UIBarButtonItemStylePlain target:self action:@selector(openVenuesWebPage)];
    callBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"callButton"] style:UIBarButtonItemStylePlain target:self action:@selector(callVenue)];
 
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:fsqBarButton, flexibleSpace, webBarButton, flexibleSpace, callBarButton, flexibleSpace, mapBarButton,nil]];
    [[UIToolbar appearance] setTintColor:[Tools colorFromHexString:[[_currentVenue venueCategoryItem] categoryColor] withAlpha:1]];
    [[UIToolbar appearance] setBarStyle:UIBarStyleDefault];
    
    //Share Message
    _socialShareMessage = [NSString stringWithFormat:@"%@\n%@",[_currentVenue venueName],[_currentVenue venueAddress]?[_currentVenue venueAddress]:@""];
    
    //Current Date String
    _currentDateString = [Tools getCurrentDateStringWithFormat:@"YYYYMMdd"];

    
    //Venue Details View
    _detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350) style:UITableViewStylePlain];
    [_detailsTableView setDelegate:self];
    [_detailsTableView setDataSource:self];
    [_detailsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //Parallax Scrollers
    CGRect bounds = self.view.bounds;
    _imageScroller  = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _imageScroller.backgroundColor = [UIColor clearColor];
    _imageScroller.showsHorizontalScrollIndicator = NO;
    _imageScroller.showsVerticalScrollIndicator = NO;
    _imageScroller.pagingEnabled = YES;
    _imageScroller.frame = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height);
    _imageViews = [[NSMutableArray alloc] init];
    _transparentScroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _transparentScroller.backgroundColor = [UIColor clearColor];
    _transparentScroller.delegate = self;
    _transparentScroller.bounces = NO;
    _transparentScroller.pagingEnabled = YES;
    _transparentScroller.showsVerticalScrollIndicator = YES;
    _transparentScroller.showsHorizontalScrollIndicator = NO;
    _transparentScroller.frame = CGRectMake(0.0, 0.0, bounds.size.width, WindowHeight);
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.delegate = self;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.frame = bounds;
    [_contentScrollView setExclusiveTouch:NO];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    [_pageControl setHidesForSinglePage:YES];
    _pageControl.frame = CGRectMake(0.0, WindowHeight - PageControlHeight, bounds.size.width, PageControlHeight);
    _pageControl.numberOfPages = [_imageViews count];
    [_contentScrollView addSubview:_detailsTableView];
    [_contentScrollView addSubview:_pageControl];
    [_contentScrollView addSubview:_transparentScroller];
    _contentView = _detailsTableView;
    [self layoutImages];
    [self layoutContent];
    [self updateOffsets];
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [mainView setAlpha:0];
    [mainView addSubview:_imageScroller];
    [mainView addSubview:_contentScrollView];
    [[self view] addSubview:mainView];
    
    detailsFirstTime = YES;

    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!detailsFirstTime) {
        [[self navigationController] setToolbarHidden:NO animated:YES];
    }
    
    //Setting Title View texts
    self.title = [_currentVenue venueName];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setToolbarHidden:YES animated:YES];
}
/************************************* VIEW LIFECYCLE METHODS ***********************************/

/********************************** DETAILS CONTROLLER METHODS **********************************/
-(void)loadImageFromURLString:(NSString*)urlString forImageView:(UIImageView*)imageView {
    [imageView
     setImageWithURL:[NSURL URLWithString:urlString]
     placeholderImage:[UIImage imageNamed:[[_configDictionary objectForKey:@"application"] objectForKey:@"photoPlaceholderImage"]]
     animated:YES duration:0.5
    ];
}

- (void)addImage:(id)image atIndex:(int)index {
    UIImageView *imageView  = [[UIImageView alloc] init];
    if ([image isKindOfClass:[UIImage class]]) {
        [imageView setImage:image];
    }
    else if ([image isKindOfClass:[NSString class]]) {
        [self loadImageFromURLString:(NSString*)image forImageView:imageView];
    }
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [_imageScroller addSubview:imageView];
    [_imageViews insertObject:imageView atIndex:index];
    [_pageControl setNumberOfPages:_pageControl.numberOfPages + 1];
    [self layoutImages];
}

-(void)addImages:(NSArray *)moreImages {
    for (id image in moreImages) {
        [self addImage:image atIndex:(int)[_imageViews count]];
    }
    [_pageControl setNumberOfPages:[_imageViews count]];
    [self layoutImages];
}

- (void)updateOffsets {
    CGFloat yOffset   = _contentScrollView.contentOffset.y;
    CGFloat xOffset   = _transparentScroller.contentOffset.x;
    CGFloat threshold = ImageHeight - WindowHeight;
    
    if (yOffset > -threshold && yOffset < 0) {
        _imageScroller.contentOffset = CGPointMake(xOffset, floorf(yOffset / 2.0));
    }
    else if (yOffset < 0) {
        _imageScroller.contentOffset = CGPointMake(xOffset, yOffset + floorf(threshold / 2.0));
    }
    else {
        _imageScroller.contentOffset = CGPointMake(xOffset, floorf(yOffset / 2.0));
    }
}

- (void)layoutContent {
    _contentScrollView.frame = self.view.bounds;
	CGFloat yOffset = WindowHeight;
	CGFloat xOffset = 0.0;
	CGSize contentSize = _contentView.frame.size;
	contentSize.height += yOffset;
	_contentView.frame = (CGRect){.origin = CGPointMake(xOffset, yOffset), .size = _contentView.frame.size};
	_contentScrollView.contentSize = contentSize;
}

- (void)layoutImages {
    CGFloat imageWidth   = _imageScroller.frame.size.width;
    CGFloat imageYOffset = floorf((WindowHeight  - ImageHeight) / 2.0);
    CGFloat imageXOffset = 0.0;
    
    for (UIImageView *imageView in _imageViews) {
        imageView.frame = CGRectMake(imageXOffset, imageYOffset, imageWidth, ImageHeight);
        imageXOffset   += imageWidth;
    }
    
    _imageScroller.contentSize = CGSizeMake([_imageViews count]*imageWidth, self.view.bounds.size.height);
    _imageScroller.contentOffset = CGPointMake(0.0, 0.0);
    _transparentScroller.contentSize = CGSizeMake([_imageViews count]*imageWidth, WindowHeight);
}

-(void)actionBack {
    if (self.view.window) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

-(void)shareContent {
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:_socialShareMessage, _socialShareImage, nil] applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop];
    [self presentViewController:activityController animated:YES completion:nil];
}

-(void)loadData {
    if (![Tools isNetworkAvailable]) {
        [Tools showNetworkError];
        [_HUD hide:YES];
    }
    else {
        [_HUD show:YES];
        _HUD.labelText=NSLocalizedString(@"LoadingText", @"");
        _HUD.mode = MBProgressHUDAnimationFade;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self getVenueDetailsAndVenuePhotos];
    }
}

-(void)getVenueDetailsAndVenuePhotos {
    NSString *apiRequestURL = [NSString stringWithFormat:@"%@%@/venues/%@,/venues/%@/photos,/venues/%@/tips&client_id=%@&client_secret=%@&v=%@&m=foursquare",
                               [[_configDictionary objectForKey:@"foursquare"] objectForKey:@"apiBaseUrl"],
                               [[_configDictionary objectForKey:@"foursquare"] objectForKey:@"multiRequest"],
                               [_currentVenue venueId], [_currentVenue venueId], [_currentVenue venueId],
                               [[_configDictionary objectForKey:@"foursquare"] objectForKey:@"foursquareClientId"],
                               [[_configDictionary objectForKey:@"foursquare"] objectForKey:@"foursquareClientSecret"],
                               _currentDateString
                              ];
    
    NSLog(@"DETAILS REQUEST: %@",apiRequestURL);

    
    NSURL *requestURL = [NSURL URLWithString:apiRequestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];

    // TODO: load venuedetails
}

-(void)loadingDataFinishedWithSuccessStatus:(BOOL)success {
    if (success) {
        venueDetailsLoadedSuccessfully = YES;
        [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
        [self setButtonsStatus];
        [self startLoadImages];
        detailsFirstTime = NO;
        
        [Tools showViewWithTransition:mainView duration:0.4 andAlpha:1.0];
        [_detailsTableView reloadData];
    }
    else {
        venueDetailsLoadedSuccessfully = NO;
        [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
        
        if (![Tools isNetworkAvailable]) {
            [Tools showNetworkError];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:NSLocalizedString(@"LoadingDataErrorMessage", @"")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"AlertCancelButtonLabel", @"")
                                  otherButtonTitles:NSLocalizedString(@"RetryButtonLabel", @""),nil];
            [alert show];
            [alert setTag:1];
        }
    }
    [[self navigationController] setToolbarHidden:!venueDetailsLoadedSuccessfully animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_HUD hide:YES];
}

-(void)setButtonsStatus {
    [fsqBarButton setEnabled:[_currentVenue venue4sqURL]?YES:NO];
    [webBarButton setEnabled:[_currentVenue venueURL]?YES:NO];
    [callBarButton setEnabled:[_currentVenue venuePhone]?YES:NO];
}

-(void)startLoadImages {
    NSInteger photoCount=0;
    if (_venuePhotos.count == 0) {
        [self addImage:[UIImage imageNamed:[[_configDictionary objectForKey:@"application"] objectForKey:@"noPhotosImage"]] atIndex:0];
        _socialShareImage = nil;
    }
    else {
        NSMutableArray *arrPhotos = [[NSMutableArray alloc] init];
        int counter = [_venuePhotos count]>6?6:(int)[_venuePhotos count];
        for (int i=0; i<counter; i++) {
            NSString *photoURL = [NSString stringWithFormat:@"%@500x500%@",
                                  [[_venuePhotos objectAtIndex:i] objectForKey:@"prefix"],
                                  [[_venuePhotos objectAtIndex:i] objectForKey:@"suffix"]
                                  ];
            photoCount++;
            [arrPhotos addObject:photoURL];
        }
        [self addImages:arrPhotos];
        _socialShareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrPhotos objectAtIndex:0]]]];
    }
}

- (void)openVenueOn4sq {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:[NSString stringWithFormat:NSLocalizedString(@"OpenOnFoursquareMessage", @""),[_currentVenue venueName]]
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"AlertCancelButtonLabel", @"")
                          otherButtonTitles:NSLocalizedString(@"OpenButtonLabel", @""), nil];
    [alert show];
    [alert setTag:2];
}

- (void)openVenuesWebPage {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:[NSString stringWithFormat:NSLocalizedString(@"OpenWithSafariMessage", @""),[_currentVenue venueURL]]
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"AlertCancelButtonLabel", @"")
                          otherButtonTitles:NSLocalizedString(@"OpenButtonLabel", @""), nil];
    [alert show];
    [alert setTag:3];
}

- (void)callVenue {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:[NSString stringWithFormat:@"%@ \n %@",[_currentVenue venueName],[NSString stringWithFormat:NSLocalizedString(@"CallPhoneMessage", @""),[_currentVenue venuePhone]]]
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"AlertCancelButtonLabel", @"")
                          otherButtonTitles:NSLocalizedString(@"CallButtonLabel", @""), nil];
    [alert show];
    [alert setTag:4];
}

/********************************** DETAILS CONTROLLER METHODS **********************************/

/********************************** SCROLLVIEW DELEGATE METHODS *********************************/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pageControl setCurrentPage:floor(_transparentScroller.contentOffset.x/_imageScroller.frame.size.width)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateOffsets];
}
/********************************** SCROLLVIEW DELEGATE METHODS *********************************/

/******************************** TABLEVIEW DELEGATE METHODS ************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 25)];
    [headerV setBackgroundColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"sectionColor"] withAlpha:0.8]];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 25)];
    [headerTitle setTextColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"detailTextColor1"] withAlpha:1.0]];
    [headerTitle setFont:[UIFont systemFontOfSize:12.0]];
    
    switch (section) {
        case 0: [headerTitle setText:NSLocalizedString(@"TipsSectionLabel", @"")]; break;
        case 1: [headerTitle setText:NSLocalizedString(@"AllPhotosSectionLabel", @"")]; break;
    }
    
    [headerV addSubview:headerTitle];
    return headerV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight=0;
    switch ([indexPath section]) {
        case 0: rowHeight = [_venueTips count]==0?40:thumbSize+25; break;
        case 1: rowHeight = [_venuePhotos count]>0?thumbSize+25:40; break;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_detailsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UIView *selectedBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [selectedBg setBackgroundColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"selectionColor"] withAlpha:[[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"selectionAlpha"] floatValue]]];
    [cell setSelectedBackgroundView:selectedBg];
    
    switch ([indexPath section]) {
        case 0: {
            if ([_venueTips count] == 0) {
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                [[cell textLabel] setTextColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"detailTextColor1"] withAlpha:1.0]];
                [[cell textLabel] setText:NSLocalizedString(@"NoTipMessage", @"")];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            else{
                UIImageView *thumbBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, thumbSize+5, thumbSize+5)];
                [thumbBgView setImage:[UIImage imageNamed:@"thumbBg"]];
                [cell addSubview:thumbBgView];
                
                UIImageView *thumbView =[[UIImageView alloc] initWithFrame:CGRectMake(12.5, 12.5, thumbSize, thumbSize)];
                [thumbView
                 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@120x120%@", [[[[_venueTips objectAtIndex:0] objectForKey:@"user"] objectForKey:@"photo"] objectForKey:@"prefix"], [[[[_venueTips objectAtIndex:0] objectForKey:@"user"] objectForKey:@"photo"] objectForKey:@"suffix"]]]
                 placeholderImage:[UIImage imageNamed:[[_configDictionary objectForKey:@"application"] objectForKey:@"userPlaceholderImage"]]
                 animated:YES duration:0.8
                ];
                [cell addSubview:thumbView];
                
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, 220, 50)];
                [tipLabel setTextColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"detailTextColor1"] withAlpha:1.0]];
                [tipLabel setFont:[UIFont systemFontOfSize:14.0]];
                [tipLabel setText:[[_venueTips objectAtIndex:0] objectForKey:@"text"]];
                [tipLabel setNumberOfLines:2];
                [cell addSubview:tipLabel];
                
                UILabel *tipUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, 220, 20)];
                [tipUserLabel setTextColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"detailTextColor2"] withAlpha:1.0]];
                [tipUserLabel setFont:[UIFont systemFontOfSize:11.0]];
                [tipUserLabel setText:[NSString stringWithFormat:@"%@, %@ %@", [Tools getDateStringFromTimeStamp:[[_venueTips objectAtIndex:0] objectForKey:@"createdAt"] andFormatString:@"dd MMM yyyy"], [[[_venueTips objectAtIndex:[indexPath row]] objectForKey:@"user"] objectForKey:@"firstName"], (![[[_venueTips objectAtIndex:0] objectForKey:@"user"] objectForKey:@"lastName"])?@"":[[[_venueTips objectAtIndex:0] objectForKey:@"user"] objectForKey:@"lastName"]]];
                [tipUserLabel setNumberOfLines:1];
                [cell addSubview:tipUserLabel];
                
                [[cell textLabel] setText:@""];
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            }
            break;
        }
        case 1: {
            if ([_venuePhotos count]>0) {
                CGFloat thumbGap = (self.view.frame.size.width-(4*thumbSize))/5;
                int counter = [_venuePhotos count]>4?4:(int)[_venuePhotos count];
                for (int i=0; i<counter; i++) {
                    UIImageView *thumbBgView = [[UIImageView alloc] initWithFrame:CGRectMake((thumbSize*i)+(thumbGap*(i+1))-5, 10, thumbSize+5, thumbSize+5)];
                    [thumbBgView setImage:[UIImage imageNamed:@"thumbBg"]];
                    [cell addSubview:thumbBgView];
                    
                    UIImageView *thumbView = [[UIImageView alloc] initWithFrame:CGRectMake((thumbSize*i)+(thumbGap*(i+1))-2.5, 12.5, thumbSize, thumbSize)];
                    
                    [thumbView
                     setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@120x120%@",[[_venuePhotos objectAtIndex:i] objectForKey:@"prefix"],[[_venuePhotos objectAtIndex:i] objectForKey:@"suffix"]]]
                     placeholderImage:[UIImage imageNamed:[[_configDictionary objectForKey:@"application"] objectForKey:@"iconPlaceholderImage"]]
                     animated:YES duration:0.8
                    ];
                    [cell addSubview:thumbView];
                }
                [[cell textLabel] setText:@""];
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            }
            else{
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
                [[cell textLabel] setTextColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"detailTextColor1"] withAlpha:1.0]];
                [[cell textLabel] setText:NSLocalizedString(@"NoPhotoMessage", @"")];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_detailsTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/******************************** TABLEVIEW DELEGATE METHODS ************************************/

/******************************** ALERTVIEW DELEGATE METHODS ************************************/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex==0) {
            [self actionBack];
        }
        else if (buttonIndex==1) {
            [self loadData];
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex==1) {
            [Tools open4sqForVenue:[_currentVenue venueId]];
        }
    }
    else if (alertView.tag == 3) {
        if (buttonIndex==1) {
            [Tools openSafariWithURL:[_currentVenue venueURL]];
        }
    }
    else if (alertView.tag == 4) {
        if (buttonIndex==1) {
            [Tools startCallWithPhoneNumber:[_currentVenue venuePhone]];
        }
    }
}
/******************************** ALERTVIEW DELEGATE METHODS ************************************/

@end
