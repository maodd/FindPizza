//
//  VenueDetailsViewController.h
//
//  Created by İlyas Doğruer
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"



#import "VenueItem.h"

@interface VenueDetailsViewController : UIViewController<MBProgressHUDDelegate>  {
  
}

@property (retain, nonatomic) MBProgressHUD         *HUD;
@property (retain, nonatomic) UITableView           *detailsTableView;
@property (nonatomic, retain) VenueItem             *currentVenue;


@end
