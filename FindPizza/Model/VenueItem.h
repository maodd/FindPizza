//
//  VenueItem.h
//
//  Created by Frank Mao on 2015-07-17
//

#import <Foundation/Foundation.h>
#import "CategoryItem.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface VenueItem : NSObject

@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, assign) CLLocationCoordinate2D venueLocation;
@property (nonatomic, assign) CGFloat venueDistance;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venuePhone;
@property (nonatomic, strong) CategoryItem *venueCategoryItem;
@property (nonatomic, strong) NSString *venueURL;
@property (nonatomic, strong) NSString *venue4sqURL;
@property (nonatomic, strong) NSNumber *venueCheckinsCount;
@property (nonatomic, strong) NSNumber *venueUsersCount;
@property (nonatomic, strong) NSNumber *venueLikesCount;
@property (nonatomic, strong) NSNumber *hereNowCount;
@property (nonatomic, strong) NSString *verified;
@property (nonatomic, strong) NSString *openStatus;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, strong) NSString *tip;

-(id)initWithVenueName:(NSString *)venueName
               venueId:(NSString *)venueId
         venueLocation:(CLLocationCoordinate2D)venueLocation
         venueDistance:(CGFloat)venueDistance
          venueAddress:(NSString *)venueAddress
            venuePhone:(NSString *)venuePhone
     venueCategoryItem:(CategoryItem *)venueCategoryItem
              venueURL:(NSString *)venueURL
           venue4sqURL:(NSString *)venue4sqURL
    venueCheckinsCount:(NSNumber *)venueCheckinsCount
       venueUsersCount:(NSNumber *)venueUsersCount
       venueLikesCount:(NSNumber *)venueLikesCount
          hereNowCount:(NSNumber *)hereNowCount
              verified:(NSString *)verified
            openStatus:(NSString *)openStatus
                 photo:(NSString *)photo
                rating:(CGFloat)rating
                   tip:(NSString *)tip;

@end
