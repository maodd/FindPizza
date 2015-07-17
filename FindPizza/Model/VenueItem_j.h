//
//  VenueItem_j.h
//  
//
//  Created by Frank Mao on 2015-07-17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VenueItem_j : NSManagedObject

@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * venueAddress;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSNumber * venueDistance;
@property (nonatomic, retain) NSString * venuePhone;
@property (nonatomic, retain) NSString * openStatus;
@property (nonatomic, retain) NSNumber * venueCheckinsCount;
@property (nonatomic, retain) NSNumber * venueUsersCount;
@property (nonatomic, retain) NSNumber * venueLikesCount;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * tip;

@end
