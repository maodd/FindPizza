//
//  ViewController.h
//  FindPizza
//
//  Created by Frank Mao on 2015-07-17.
//  Copyright (c) 2015 mazoic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FilterItem.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MBProgressHUDDelegate, CLLocationManagerDelegate> {
    MBProgressHUD       *_HUD;
    
  
    NSDictionary        *_venuesDictionary;
    NSMutableArray      *_venuesArray;
    NSMutableArray      *_venueItemsArray;
    
    FilterItem          *_currentFilterItem;
    NSDictionary        *_subCategoriesDictionary;
}

@property (retain, nonatomic) MBProgressHUD     *HUD;

@property (nonatomic, retain) NSDictionary      *configDictionary;
@property (nonatomic, retain) NSDictionary      *venuesDictionary;
@property (nonatomic, retain) NSMutableArray    *venuesArray;
@property (nonatomic, retain) NSMutableArray    *venueItemsArray;

@property (nonatomic, retain) FilterItem        *currentFilterItem;
@property (nonatomic, retain) NSDictionary      *subCategoriesDictionary;



@end

