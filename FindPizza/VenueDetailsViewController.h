//
//  VenueDetailsViewController.h
//
//  Created by İlyas Doğruer
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"



#import "VenueItem.h"

@interface VenueDetailsViewController : UIViewController <UIScrollViewDelegate, MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray          *_imageViews;
    UIScrollView            *_imageScroller;
    UIScrollView            *_transparentScroller;
    UIScrollView            *_contentScrollView;
    UIView                  *_contentView;
    UIPageControl           *_pageControl;
    
    MBProgressHUD           *_HUD;
    UITableView             *_detailsTableView;
    VenueItem               *_currentVenue;
    NSDictionary            *_configDictionary;
    NSDictionary            *_venueDetailsDictionary;
    NSArray                 *_venuePhotos;
    NSArray                 *_venueTips;
    NSString                *_socialShareMessage;
    UIImage                 *_socialShareImage;
 
    NSMutableArray          *_photoDataSource;
}

@property (retain, nonatomic) MBProgressHUD         *HUD;
@property (retain, nonatomic) UITableView           *detailsTableView;
@property (nonatomic, retain) VenueItem             *currentVenue;
@property (nonatomic, retain) NSDictionary          *configDictionary;
@property (nonatomic, retain) NSDictionary          *venueDetailsDictionary;
@property (nonatomic, retain) NSArray               *venuePhotos;
@property (nonatomic, retain) NSArray               *venueTips;
@property (nonatomic, retain) NSString              *socialShareMessage;
@property (nonatomic, retain) UIImage               *socialShareImage;
@property (nonatomic, strong) NSMutableArray        *photoDataSource;

@end
