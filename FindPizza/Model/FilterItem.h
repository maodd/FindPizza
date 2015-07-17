//
//  FilterItem.h
//
//  Created by Frank Mao on 2015-07-17
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CategoryItem.h"

@interface FilterItem : NSObject

@property (nonatomic, strong) CategoryItem  *categoryItem;
@property (nonatomic, assign) NSInteger     subCategoryIndex;
@property (nonatomic, strong) NSString      *apiType;
@property (nonatomic, assign) BOOL          isOpen;
@property (nonatomic, strong) NSString      *distanceRadius;
@property (nonatomic, assign) BOOL          isVerified;
@property (nonatomic, assign) BOOL          sortByDistance;
@property (nonatomic, assign) BOOL          sortByRating;
@property (nonatomic, assign) BOOL          sortByLikes;
@property (nonatomic, strong) NSString      *searchQuery;
@property (nonatomic, strong) CLLocation    *userLocation;
@property (nonatomic, assign) NSString      *resultCount;

-(id)initWithCategoryItem:(CategoryItem *)categoryItem
         subCategoryIndex:(NSInteger)subCategoryIndex
                  apiType:(NSString *)apiType
                   isOpen:(BOOL)isOpen
           distanceRadius:(NSString *)distanceRadius
               isVerified:(BOOL)isVerified
           sortByDistance:(BOOL)sortByDistance
             sortByRating:(BOOL)sortByRating
              sortByLikes:(BOOL)sortByLikes
              searchQuery:(NSString *)searchQuery
             userLocation:(CLLocation *)userLocation
              resultCount:(NSString *)resultCount;

@end
