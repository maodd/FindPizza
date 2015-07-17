//
//  VenueItem.m
//
//  Created by Frank Mao on 2015-07-17
//

#import "VenueItem.h"

@implementation VenueItem

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
                   tip:(NSString *)tip {
    
    self = [super init];
    if (self) {
        _venueName          = venueName;
        _venueId            = venueId;
        _venueLocation      = venueLocation;
        _venueDistance      = venueDistance;
        _venueAddress       = venueAddress;
        _venuePhone         = venuePhone;
        _venueCategoryItem  = venueCategoryItem;
        _venueURL           = venueURL;
        _venue4sqURL        = venue4sqURL;
        _venueCheckinsCount = venueCheckinsCount;
        _venueUsersCount    = venueUsersCount;
        _venueLikesCount    = venueLikesCount;
        _hereNowCount       = hereNowCount;
        _verified           = verified;
        _openStatus         = openStatus;
        _photo              = photo;
        _rating             = rating;
        _tip                = tip;
    }
    return self;
}

@end
