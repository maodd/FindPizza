//
//  FilterItem.m
//
//  Created by Frank Mao on 2015-07-17
//

#import "FilterItem.h"

@implementation FilterItem

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
              resultCount:(NSString *)resultCount {
    
    self = [super init];
    if (self) {
        _categoryItem       = categoryItem;
        _subCategoryIndex   = subCategoryIndex;
        _apiType            = apiType;
        _isOpen             = isOpen;
        _distanceRadius     = distanceRadius;
        _isVerified         = isVerified;
        _sortByDistance     = sortByDistance;
        _sortByRating       = sortByRating;
        _sortByLikes        = sortByLikes;
        _searchQuery        = searchQuery;
        _userLocation       = userLocation;
        _resultCount        = resultCount;
    }
    return self;
}

@end
