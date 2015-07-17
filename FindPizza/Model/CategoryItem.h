//
//  CategoryItem.h
//
//  Created by Frank Mao on 2015-07-17
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryColor;
@property (nonatomic, strong) NSString *categoryIcon;
@property (nonatomic, strong) NSString *categoryPin;

-(id)initWithCategoryId:(NSString *)categoryId
           categoryName:(NSString *)categoryName
          categoryColor:(NSString *)categoryColor
           categoryIcon:(NSString *)categoryIcon
            categoryPin:(NSString *)categoryPin;

@end
