//
//  CategoryItem.m
//
//  Created by Frank Mao on 2015-07-17
//

#import "CategoryItem.h"

@implementation CategoryItem

-(id)initWithCategoryId:(NSString *)categoryId
           categoryName:(NSString *)categoryName
          categoryColor:(NSString *)categoryColor
           categoryIcon:(NSString *)categoryIcon
            categoryPin:(NSString *)categoryPin {
    
    self = [super init];
    if (self) {
        _categoryId     = categoryId;
        _categoryName   = categoryName;
        _categoryColor  = categoryColor;
        _categoryIcon   = categoryIcon;
        _categoryPin    = categoryPin;
    }
    return self;
}

@end
