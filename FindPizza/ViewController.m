//
//  ViewController.m
//  FindPizza
//
//  Created by Frank Mao on 2015-07-17.
//  Copyright (c) 2015 mazoic. All rights reserved.
//

#import "ViewController.h"
#import "Tools.h"
#import "AFNetworking.h"
#import "VenueItem.h"
#import <CoreLocation/CoreLocation.h>
#import "VeneneCell.h"

#import "VenueDetailsViewController.h"
 


#define kDataLoadedSuccessNotification @"kDataLoadedSuccessNotification"



@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end

@implementation ViewController{
    NSString            *_currentDateString;
    NSDictionary        *_configDictionary;
    CLLocationManager   * _locationManager;
    CLLocation          * _userLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Loading Configuration File

    self.title = @"Find Pizza";
    
    
    [self startLocationService];
    
 

}

#pragma mark - location
- (void)startLocationService
{
    //Starting Location Services
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    [_locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _userLocation = [locations lastObject];
    [_locationManager stopUpdatingLocation];
    [_locationManager setDelegate:nil];
    
    NSLog(@"LOCATION: %@",[locations lastObject]);
    
    [self doFourSquareQuery];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (![Tools isLocationServiceEnabled]) {
        [Tools showLocationServicesErrorByType:@"locationServicesDisabledError"];
    }
    else if (![Tools isLocationServicesEnabledForApp]) {
        [Tools showLocationServicesErrorByType:@"locationServicesAuthorizationStatusDenied"];
    }
}


#pragma mark - 4square

- (void)doFourSquareQuery
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    _configDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //Current Date String for foursquare request, ex:20130925
    _currentDateString = [Tools getCurrentDateStringWithFormat:@"YYYYMMdd"];
    
    _currentFilterItem = [FilterItem new];
    
    _currentFilterItem.apiType = @"venues/explore?";
    CategoryItem * category = [CategoryItem new];
    category.categoryId= @"4bf58dd8d48988d1ca941735";
    category.categoryName = @"Pizza Places";
    _currentFilterItem.categoryItem   = category;
    _currentFilterItem.distanceRadius = @"1000";
    _currentFilterItem.isOpen = @"NO";
    _currentFilterItem.resultCount = @"5";
    
    _currentFilterItem.userLocation = _userLocation;
    _currentFilterItem.sortByDistance = YES;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _HUD.delegate=self;
    
    
    if (![Tools isLocationServiceEnabled]) {
        [Tools showLocationServicesErrorByType:@"locationServicesDisabledError"];
        [_HUD hide:YES];
    }
    else {
        if (![Tools isNetworkAvailable]) {
            [Tools showNetworkError];
            [_HUD hide:YES];
        }
        else {
            [_HUD show:YES];
            _HUD.labelText=NSLocalizedString(@"Loading", @"");
            _HUD.mode = MBProgressHUDAnimationFade;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [[self tableView] setAlpha:0];
            [[self tableView] scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            
            [self getVenues];
        }
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataLoadedSuccessNotification object:nil];
}


-(void)getVenues {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kDataLoadedSuccessNotification object:nil];
    
    NSURL *requestURL = [NSURL URLWithString:[self configureRequestURLWithApiType:[_currentFilterItem apiType]
                                                                       categoryId:[[_currentFilterItem categoryItem] categoryId]
                                                                   distanceRadius:[_currentFilterItem distanceRadius]
                                                                           isOpen:[_currentFilterItem isOpen]
                                                                      resultCount:[[_currentFilterItem resultCount] intValue]]
                         ];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    
    NSLog(@"VENUES REQUEST: %@",requestURL);
    
    
    //Request for JSON object
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         _venuesDictionary = (NSDictionary *)JSON;
         _venuesArray = [[NSMutableArray alloc] init];
         NSLog(@"JSON: %@",JSON);
         if([[_currentFilterItem apiType] isEqualToString:[[_configDictionary objectForKey:@"foursquare"] objectForKey:@"venuesExplore"]])
         {
             _venuesArray = [[[[_venuesDictionary objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
             _venueItemsArray = [[NSMutableArray alloc] init];
             
             if (_venuesArray.count!=0) {
                 for (int i=0; i<_venuesArray.count; i++) {
                     VenueItem *vi = [[VenueItem alloc]
                                      initWithVenueName:[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"name"]
                                      venueId:[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"id"]
                                      venueLocation:CLLocationCoordinate2DMake([[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] floatValue],[[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"] floatValue])
                                      venueDistance:[[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"distance"] floatValue]
                                      venueAddress:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"address"]
                                      venuePhone:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"contact"] objectForKey:@"formattedPhone"]
                                      venueCategoryItem:[[CategoryItem alloc]
                                                         initWithCategoryId:[[_currentFilterItem categoryItem] categoryId]
                                                         categoryName:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"categories"] count]>0?[[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"name"]:[[_currentFilterItem categoryItem] categoryName]
                                                         categoryColor:[[_currentFilterItem categoryItem] categoryColor]
                                                         categoryIcon:[[_currentFilterItem categoryItem] categoryIcon]
                                                         categoryPin:[[_currentFilterItem categoryItem] categoryPin]]
                                      venueURL:[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"url"]
                                      venue4sqURL:[NSString stringWithFormat:@"http://foursquare.com/v/%@",[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"id"]]
                                      venueCheckinsCount:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"stats"] objectForKey:@"checkinsCount"]?[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"stats"] objectForKey:@"checkinsCount"]:0
                                      venueUsersCount:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"stats"] objectForKey:@"usersCount"]?[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"stats"] objectForKey:@"usersCount"]:0
                                      venueLikesCount:[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"ratingSignals"]?[NSNumber numberWithInteger:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"ratingSignals"] integerValue]]:[NSNumber numberWithInt:0]
                                      hereNowCount:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"hereNow"] objectForKey:@"count"]?[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"hereNow"] objectForKey:@"count"]:0
                                      verified:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"verified"] boolValue]?@"YES":@"NO"
                                      openStatus:[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"hours"] objectForKey:@"status"]
                                      photo:([[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"photos"] objectForKey:@"groups"] count]!=0)?(([[[[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"photos"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] count]!=0)?[NSString stringWithFormat:@"%@600x320%@",[[[[[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"photos"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"prefix"],[[[[[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"photos"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"suffix"]]:nil):nil
                                      rating:[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"rating"]?[[[[_venuesArray objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"rating"] floatValue]:0.0
                                      tip:[[[[_venuesArray objectAtIndex:i] objectForKey:@"tips"] objectAtIndex:0] objectForKey:@"text"]?[[[[_venuesArray objectAtIndex:i] objectForKey:@"tips"] objectAtIndex:0] objectForKey:@"text"]:@""
                                      ];
                     [_venueItemsArray addObject:vi];
                 }
             }
             
             //Filter venues by search query
             if ([_currentFilterItem searchQuery] && ![[_currentFilterItem searchQuery] isEqualToString:@""] && ![[_currentFilterItem searchQuery] isEqualToString:@" "]) {
                 _venueItemsArray = [[NSMutableArray alloc] initWithArray:[self filterVenuesByQuery:[_currentFilterItem searchQuery] andVenueItems:_venueItemsArray]];
             }
             
             //Filter verified venues
             if ([_currentFilterItem isVerified]) {
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"verified LIKE[c] %@", @"YES"];
                 _venueItemsArray = [[NSMutableArray alloc] initWithArray:[Tools getFilteredArray:_venueItemsArray filterWith:predicate]];
             }
             
             //Sort venues by sort type
             if ([_currentFilterItem sortByDistance]){
                 _venueItemsArray = [[NSMutableArray alloc] initWithArray:[Tools getSortedArray:_venueItemsArray sortBy:@"venueDistance" ascending:YES]];
             }
             else if ([_currentFilterItem sortByRating]) {
                 _venueItemsArray = [[NSMutableArray alloc] initWithArray:[Tools getSortedArray:_venueItemsArray sortBy:@"rating" ascending:NO]];
             }
             else if ([_currentFilterItem sortByLikes]){
                 _venueItemsArray = [[NSMutableArray alloc] initWithArray:[Tools getSortedArray:_venueItemsArray sortBy:@"venueLikesCount" ascending:NO]];
             }
         }
         [self loadingDataFinishedWithSuccessStatus:YES];
     }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         [self loadingDataFinishedWithSuccessStatus:NO];
     }];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse){return nil;}];
    [operation start];
}

-(NSString *)configureRequestURLWithApiType:(NSString *)apiType categoryId:(NSString *)categoryId distanceRadius:(NSString *)radius isOpen:(BOOL)isOpen resultCount:(int)resultCount {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@client_id=%@&client_secret=%@&ll=%f,%f&categoryId=%@&radius=%@&limit=%d&venuePhotos=1&openNow=%@&v=%@&m=foursquare",
                            [[_configDictionary objectForKey:@"foursquare"] objectForKey:@"apiBaseUrl"],
                            apiType,
                            [[_configDictionary objectForKey:@"foursquare"] objectForKey:@"foursquareClientId"],
                            [[_configDictionary objectForKey:@"foursquare"] objectForKey:@"foursquareClientSecret"],
                            _currentFilterItem.userLocation.coordinate.latitude,
                            _currentFilterItem.userLocation.coordinate.longitude,
                            categoryId,radius,resultCount,[NSNumber numberWithBool:isOpen],_currentDateString
                            ];
    NSLog(@"BOOL : %@",requestURL);
    NSString *encodedRequestURL = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)requestURL,NULL,(CFStringRef)@"ığüşöçİĞÜŞÖÇ",kCFStringEncodingUTF8);
    return encodedRequestURL;
}

-(NSArray *)filterVenuesByQuery:(NSString *)searchQuery andVenueItems:(NSMutableArray *)venueItemsArray {
    NSString *encodedQuery = [[[[[[[[[[[[[[searchQuery stringByReplacingOccurrencesOfString:@"ı" withString:@"i"] stringByReplacingOccurrencesOfString:@"ğ" withString:@"g"] stringByReplacingOccurrencesOfString:@"ü" withString:@"u"] stringByReplacingOccurrencesOfString:@"ş" withString:@"s"] stringByReplacingOccurrencesOfString:@"ö" withString:@"o"] stringByReplacingOccurrencesOfString:@"ç" withString:@"c"] stringByReplacingOccurrencesOfString:@"İ" withString:@"i"] stringByReplacingOccurrencesOfString:@"I" withString:@"i"] stringByReplacingOccurrencesOfString:@"Ğ" withString:@"g"] stringByReplacingOccurrencesOfString:@"Ü" withString:@"u"] stringByReplacingOccurrencesOfString:@"Ş" withString:@"s"] stringByReplacingOccurrencesOfString:@"Ö" withString:@"o"] stringByReplacingOccurrencesOfString:@"Ç" withString:@"c"] lowercaseString];
    
    NSString *lowerCasedSearchQuery = [[[[[[[[searchQuery stringByReplacingOccurrencesOfString:@"İ" withString:@"i"] stringByReplacingOccurrencesOfString:@"I" withString:@"ı"] stringByReplacingOccurrencesOfString:@"Ğ" withString:@"ğ"] stringByReplacingOccurrencesOfString:@"Ü" withString:@"ü"] stringByReplacingOccurrencesOfString:@"Ş" withString:@"ş"] stringByReplacingOccurrencesOfString:@"Ö" withString:@"ö"] stringByReplacingOccurrencesOfString:@"Ç" withString:@"ç"] lowercaseString];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venueName CONTAINS[c] %@ OR venueCategoryItem.categoryName CONTAINS[c] %@ OR venueAddress CONTAINS[c] %@ OR tip CONTAINS[c] %@ OR venueName CONTAINS[c] %@ OR venueCategoryItem.categoryName CONTAINS[c] %@ OR venueAddress CONTAINS[c] %@ OR tip CONTAINS[c] %@",lowerCasedSearchQuery,lowerCasedSearchQuery,lowerCasedSearchQuery,lowerCasedSearchQuery,encodedQuery,encodedQuery,encodedQuery,encodedQuery];
    NSArray *filteredArray = [Tools getFilteredArray:venueItemsArray filterWith:predicate];
    return filteredArray;
}

-(void)loadingDataFinishedWithSuccessStatus:(BOOL)success {
    
    
    
    if (success) {
        [[self tableView] setTableFooterView:[_venueItemsArray count]!=0?[[UIImageView alloc] initWithImage:[UIImage imageNamed:[[_configDictionary objectForKey:@"foursquare"] objectForKey:@"foursquareFooterImage"]]]:nil];
        [Tools showViewWithTransition:[self tableView] duration:0.5 andAlpha:1.0];

        
        // TODO: user notification center instead.
        [[NSNotificationCenter defaultCenter] postNotificationName:kDataLoadedSuccessNotification object:nil];
        
        if ([_venueItemsArray count]==0) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:[NSString stringWithFormat:@"%@",NSLocalizedString(@"NoVenueMessage", @"")]
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"AlertCancelButtonLabel", @""),NSLocalizedString(@"NewFilterButtonLabel", @""),nil];
            [alert show];
            [alert setTag:2];
        }
        else {
            //Setting TableView background color
            [[self tableView] setBackgroundColor:[Tools colorFromHexString:[[_configDictionary objectForKey:@"generalTableView"] objectForKey:@"backgroundColor"] withAlpha:1.0]];
   
            
        }
    }
    else{
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_HUD hide:YES];
}


#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_venueItemsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    VeneneCell *cell = (VeneneCell*)[tableView dequeueReusableCellWithIdentifier:@"VeneueCell"];
    if (cell == nil) {
        // Create a temporary UIViewController to instantiate the custom cell.
          cell = (VeneneCell*)[[[NSBundle mainBundle] loadNibNamed:@"VeneueCell" owner:self options:nil] lastObject];
        // Grab a pointer to the custom cell.
        
    }
    
    VenueItem * venue = _venueItemsArray[indexPath.row];
    cell.name.text = venue.venueName;
    cell.address.text = venue.venueAddress;
    cell.distance.text = [NSString stringWithFormat:@"%.0fm", venue.venueDistance];
    
    return cell;
        
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView * )tableView
didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
    VenueItem * item = _venueItemsArray[indexPath.row];
    
    VenueDetailsViewController * vc = [VenueDetailsViewController new];
    
    vc.currentVenue = item;
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
        if (buttonIndex==0) {
            [self actionBack];
        }
        else if (buttonIndex==1) {
//            [self openVenueFiltersView];
        }
    }
}
/******************************** ALERTVIEW DELEGATE METHODS ************************************/

-(void)actionBack {
    if (self.view.window) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}
@end
