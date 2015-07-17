//
//  Tools.h
//
//  Created by Frank Mao on 2015-07-17
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface Tools : NSObject <CLLocationManagerDelegate>

/***************************** UICOLOR FROM HEXADECIMAL STRING & VALUE **************************/
+(UIColor *)colorFromHexString:(NSString *)hexString withAlpha:(float)alpha;
+(UIColor *)colorFromHexValue:(UInt32)hexValue withAlpha:(float)alpha;

/***************************************** NETWORK STATUS  **************************************/
+(BOOL)isNetworkAvailable;

/**************************************** LOCATION SERVICES *************************************/
+(BOOL)isLocationServiceEnabled;
+(BOOL)isLocationServicesEnabledForApp;
+(BOOL)isLocationValid:(CLLocationCoordinate2D)coordinate;

/******************************************* DATE & TIME ****************************************/
+(NSString *)getCurrentDateStringWithFormat:(NSString *)formatString;
+(NSString *)getDateStringFromTimeStamp:(NSString *)timeStamp andFormatString:(NSString *)formatString;

/************************************** SORT AND FILTER ARRAY ***********************************/
+(NSArray *)getSortedArray:(NSArray *)sourceArray sortBy:(NSString *)key ascending:(BOOL)ascending;
+(NSArray *)getFilteredArray:(NSArray *)sourceArray filterWith:(NSPredicate *)predicate;

/******************************************* ANIMATION ******************************************/
+(void)showViewWithTransition:(UIView *)view duration:(NSTimeInterval)duration andAlpha:(CGFloat)alpha;

/************************************ OPEN NATIVE APPLICATIONS **********************************/
+(void)open4sqForVenue:(NSString *)venueId;
+(void)open4sqForTip:(NSString *)tipId;
+(void)startCallWithPhoneNumber:(NSString *)phoneNumber;
+(void)openSafariWithURL:(NSString *)url;
+(void)openMapsAppWithSourceLocation:(CLLocationCoordinate2D)sourceLocation andDestinationLocation:(CLLocationCoordinate2D)destinationLocation;

/****************************************** ERROR ALERTS ****************************************/
+(void)showNetworkError;
+(void)showLocationServicesErrorByType:(NSString *)messageType;

@end
