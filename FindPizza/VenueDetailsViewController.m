//
//  VenueDetailsViewController.m
//
//  Created by İlyas Doğruer
//

#import "VenueDetailsViewController.h"
#import "Tools.h"

@interface VenueDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * addressLabel;
@property (nonatomic, weak) IBOutlet UILabel * phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * checkinsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * usersCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * likesCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * verifiedLabel;
@property (nonatomic, weak) IBOutlet UILabel * openStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel * ratingLabel;
@property (nonatomic, weak) IBOutlet UILabel * tipLabel;


@end

@implementation VenueDetailsViewController



@synthesize HUD                     = _HUD;
@synthesize detailsTableView        = _detailsTableView;
@synthesize currentVenue            = _currentVenue;

 

/************************************* VIEW LIFECYCLE METHODS ***********************************/
-(void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    //Setting NavigationBar Items
 
    
    
    //Setting Title View texts
    self.title =  [_currentVenue venueName];
 
    self.nameLabel.text = _currentVenue.venueName;
    self.likesCountLabel.text = [NSString stringWithFormat:@"%d", self.currentVenue.venueLikesCount.intValue];
    self.usersCountLabel.text = [NSString stringWithFormat:@"%d", self.currentVenue.venueUsersCount.intValue];
    self.checkinsCountLabel.text = [NSString stringWithFormat:@"%d", self.currentVenue.venueCheckinsCount.intValue];
    self.addressLabel.text = _currentVenue.venueAddress;
    self.phoneLabel.text = _currentVenue.venuePhone;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f/10", _currentVenue.rating];
    self.tipLabel.text = _currentVenue.tip;
 
    self.openStatusLabel.text = _currentVenue.openStatus;
    
    
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    
    //Setting Title View texts
    self.title = [_currentVenue venueName];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setToolbarHidden:YES animated:YES];
}


@end
