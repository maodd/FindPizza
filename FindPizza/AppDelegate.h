//
//  AppDelegate.h
//  FindPizza
//
//  Created by Frank Mao on 2015-07-17.
//  Copyright (c) 2015 mazoic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class VenueItem;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)addVenue:(VenueItem*)venueItem;
- (NSArray*)getAllVenues;

+ (AppDelegate*)globalDelegate;


@end

