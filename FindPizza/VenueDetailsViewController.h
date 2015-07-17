//
//  VenueDetailsViewController.h
//
//  Created by Frank Mao on 2015-07-17
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"



#import "VenueItem_j.h"

@interface VenueDetailsViewController : UIViewController<MBProgressHUDDelegate>  {
  
}

@property (retain, nonatomic) MBProgressHUD         *HUD;
@property (retain, nonatomic) UITableView           *detailsTableView;
@property (nonatomic, retain) VenueItem_j             *currentVenue;


@end
